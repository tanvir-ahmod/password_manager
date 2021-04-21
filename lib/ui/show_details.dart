import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_details/show_details_bloc.dart';
import 'package:password_manager/bloc/show_details/show_details_event.dart';
import 'package:password_manager/bloc/show_details/show_details_state.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/models/password_model_with_index.dart';

class ShowDetails extends StatefulWidget {
  final index;
  final PasswordModelWithIndex passwordModelWithIndex;

  const ShowDetails({Key key, this.passwordModelWithIndex, this.index})
      : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState(
      passwordModelWithIndex.passwordModel, passwordModelWithIndex.index);
}

class _ShowDetailsState extends State<ShowDetails> {
  final PasswordModel _passwordModel;
  final index;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  bool _isEditable = false;
  bool _isPasswordHidden = true;

  String _decryptedPassword = "";

  _ShowDetailsState(this._passwordModel, this.index);

  @override
  void initState() {
    super.initState();
    _title.text = _passwordModel.title;
    _userName.text = _passwordModel.userName;
    _pass.text = _passwordModel.password;

    BlocProvider.of<ShowDetailsBloc>(context)
        .add(DecryptPasswordEvent(_pass.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShowDetailsBloc, ShowDetailsState>(
        listener: (context, state) {
          if (state is DecryptPasswordState) {
            _decryptedPassword = state.password;
          }
          if (state is DeleteDetailsState) {
            BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());
            _showSuccessDialog("Data deleted successfully");
          }
          if (state is UpdateDetailsState) {
            BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());
            _showSuccessDialog("Data updated successfully");
          }
        },
        child: _showDetailsUI());
  }

  Widget _showDetailsUI() {
    var size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditable ? "Edit Details" : "Show Details"),
        actions: <Widget>[
          (() {
            if (_isEditable) {
              return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditable = false;
                        _pass.text = _isPasswordHidden
                            ? _passwordModel.password
                            : _decryptedPassword;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 26.0,
                    ),
                  ));
            } else {
              return Row(children: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditable = true;
                          _pass.text = _decryptedPassword;
                        });
                      },
                      child: Icon(
                        Icons.edit,
                        size: 26.0,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        _showDeleteConfirmationDialog();
                      },
                      child: Icon(
                        Icons.delete,
                        size: 26.0,
                      ),
                    )),
              ]);
            }
          }())
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Image.asset(
                "assets/images/lock_icon.png",
                height: size.height * 0.3,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: !_isEditable,
                      controller: _title,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      onEditingComplete: () => node.nextFocus(),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      readOnly: !_isEditable,
                      controller: _userName,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Username / Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      readOnly: !_isEditable,
                      controller: _pass,
                      textInputAction: TextInputAction.done,
                      obscureText: _isPasswordHidden,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      onEditingComplete: () => node.unfocus(),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        suffix: InkWell(
                          onTap: () {
                            if (!_isEditable) {
                              if (_isPasswordHidden) {
                                _pass.text = _decryptedPassword;
                              } else {
                                _pass.text = _passwordModel.password;
                              }
                            }

                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          child: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            (() {
              if (_isEditable) {
                return ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100, height: 40),
                  child: ElevatedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.blueAccent)))),
                    onPressed: () async {
                      if (_form.currentState.validate()) {
                        BlocProvider.of<ShowDetailsBloc>(context).add(
                            UpdateDetailsEvent(PasswordModelWithIndex(
                                index,
                                PasswordModel(
                                    title: _title.text,
                                    password: _pass.text,
                                    userName: _userName.text))));
                      }
                    },
                  ),
                );
              } else
                return Container();
            }()),
          ],
        ),
      ),
    );
  }

  _showDeleteConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Do you want to delete this data?"),
            actions: [
              ElevatedButton(
                child: Text("Confirm"),
                onPressed: () {
                  BlocProvider.of<ShowDetailsBloc>(context)
                      .add(DeleteDetailsEvent(index));
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
              ),
              ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _showSuccessDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text(message),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  var count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                },
              )
            ],
          );
        });
  }
}
