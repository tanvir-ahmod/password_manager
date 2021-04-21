import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_bloc.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_event.dart';
import 'package:password_manager/bloc/setup_master_password/setup_master_password_state.dart';
import 'package:password_manager/utils/app_router.dart';

class SetupMasterPassword extends StatefulWidget {
  @override
  _SetupMasterPasswordState createState() => _SetupMasterPasswordState();
}

class _SetupMasterPasswordState extends State<SetupMasterPassword> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupMasterPasswordBloc, SetupMasterPasswordState>(
        listener: (context, state) {
          if (state is MasterPasswordSetSate) {
            Navigator.pushNamedAndRemoveUntil(
                context, ShowPasswordsRoute, (r) => false);
          }
        },
        child: _setupMasterPasswordUI());
  }

  Widget _setupMasterPasswordUI() {
    var size = MediaQuery.of(context).size;
    final focus = FocusNode();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 64.0),
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
                  key: _form,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _pass,
                        textInputAction: TextInputAction.next,
                        obscureText: _isPasswordHidden,
                        validator: (val) {
                          if (val.isEmpty) return 'Field can not be empty';
                          return null;
                        },
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          suffix: InkWell(
                            onTap: () {
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _confirmPass,
                        focusNode: focus,
                        obscureText: _isConfirmPasswordHidden,
                        validator: (val) {
                          if (val.isEmpty) return 'Field can not be empty';
                          if (val != _pass.text)
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
              ElevatedButton(
                child: Text(
                  "Set Password",
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
                    BlocProvider.of<SetupMasterPasswordBloc>(context)
                        .add(SaveMasterPasswordEvent(_pass.text));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
