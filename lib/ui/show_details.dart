import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_event.dart';
import 'package:password_manager/bloc/add_password/add_password_state.dart';
import 'package:password_manager/bloc/show_details/show_details_bloc.dart';
import 'package:password_manager/bloc/show_details/show_details_event.dart';
import 'package:password_manager/bloc/show_details/show_details_state.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/models/password_model.dart';

class ShowDetails extends StatefulWidget {
  final PasswordModel passwordModel;

  const ShowDetails({Key key, this.passwordModel}) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState(passwordModel);
}

class _ShowDetailsState extends State<ShowDetails> {
  final PasswordModel _passwordModel;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  String _password = "";

  bool _isEditable = false;
  bool _isPasswordHidden = true;

  _ShowDetailsState(this._passwordModel);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShowDetailsBloc, ShowDetailsState>(
        listener: (context, state) {
          if (state is DecryptPasswordState) {
            _password = state.password;
          } else {
            _password = _passwordModel.password;
          }
        },
        child: _showDetailsUI());
  }

  Widget _showDetailsUI() {
    _title.text = _passwordModel.title;
    _userName.text = _passwordModel.userName;
    _pass.text = _password.isEmpty ? _passwordModel.password : _password;

    var size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Show Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.asset(
                "assets/images/password_setup.png",
                height: size.height * 0.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _title,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      onEditingComplete: () => node.nextFocus(),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _userName,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      decoration: InputDecoration(
                        labelText: 'Username / Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _pass,
                      textInputAction: TextInputAction.done,
                      obscureText: _isPasswordHidden,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      onEditingComplete: () => node.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffix: InkWell(
                          onTap: () {
                            if (_isPasswordHidden) {
                              BlocProvider.of<ShowDetailsBloc>(context)
                                  .add(DecryptPasswordEvent(_pass.text));
                            } else {
                              _password = _passwordModel.password;
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
                return ElevatedButton(
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.lightBlue)))),
                  onPressed: () async {
                    if (_form.currentState.validate()) {
                      BlocProvider.of<AddPasswordBloc>(context).add(
                          InsertPasswordEvent(PasswordModel(
                              title: _title.text,
                              password: _pass.text,
                              userName: _userName.text)));
                    }
                  },
                );
              } else
                return Container();
            }()),
          ],
        ),
      ),
    );
  }
}
