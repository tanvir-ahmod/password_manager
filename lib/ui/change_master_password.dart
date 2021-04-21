import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_bloc.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_event.dart';
import 'package:password_manager/bloc/change_master_password/change_master_password_state.dart';
import 'package:password_manager/utils/app_router.dart';

class ChangeMasterPassword extends StatefulWidget {
  @override
  _ChangeMasterPasswordState createState() => _ChangeMasterPasswordState();
}

class _ChangeMasterPasswordState extends State<ChangeMasterPassword> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isOldPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeMasterPasswordBloc, ChangeMasterPasswordState>(
      listener: (context, state) {
        if (state is UpdateMasterPasswordState) {
          _showDialog(state.isSuccess);
        }
      },
      child: _changeMasterPasswordUI(),
    );
  }

  Widget _changeMasterPasswordUI() {
    var size = MediaQuery.of(context).size;
    final focusNode1 = FocusNode();
    final focusNode2 = FocusNode();
    return Scaffold(
      appBar: AppBar(title: Text("Change master password")),
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
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _oldPassword,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode1),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Current password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _isOldPasswordHidden = !_isOldPasswordHidden;
                            });
                          },
                          child: Icon(
                            _isOldPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: focusNode1,
                      controller: _newPassword,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode2),
                      obscureText: _isNewPasswordHidden,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'New Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _isNewPasswordHidden = !_isNewPasswordHidden;
                            });
                          },
                          child: Icon(
                            _isNewPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: focusNode2,
                      controller: _confirmPassword,
                      textInputAction: TextInputAction.done,
                      obscureText: _isConfirmPasswordHidden,
                      validator: (val) {
                        if (val.isEmpty) return 'Field can not be empty';
                        if (val != _newPassword.text)
                          return 'Password does not match';
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                            });
                          },
                          child: Icon(
                            _isConfirmPasswordHidden
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
            ConstrainedBox(
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueAccent)))),
                onPressed: () async {
                  if (_form.currentState.validate()) {
                    BlocProvider.of<ChangeMasterPasswordBloc>(context).add(
                        UpdateMasterPasswordEvent(
                            _oldPassword.text, _newPassword.text));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _showDialog(bool isSuccess) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isSuccess ? "Success" : "Error"),
            content: Text(isSuccess
                ? "Password Updated Successfully"
                : "Invalid Old Password"),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  if (isSuccess) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, EnterMasterPasswordRoute, (r) => false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
