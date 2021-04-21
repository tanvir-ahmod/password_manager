import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/enter_password/enter_password_bloc.dart';
import 'package:password_manager/bloc/enter_password/enter_password_state.dart';

import '../bloc/enter_password/enter_password_event.dart';
import '../utils/app_router.dart';

class EnterMasterPassword extends StatefulWidget {
  @override
  _EnterMasterPasswordState createState() => _EnterMasterPasswordState();
}

class _EnterMasterPasswordState extends State<EnterMasterPassword> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocListener<EnterPasswordBloc, EnterPasswordState>(
        listener: (context, state) {
          if (state is CheckPasswordState) {
            if (state.isMasterPasswordCorrect) {
              Navigator.pushNamedAndRemoveUntil(
                  context, ShowPasswordsRoute, (r) => false);
            } else {
              _showErrorDialog();
            }
          }
        },
        child: _enterPasswordUI(context, size));
  }

  Widget _enterPasswordUI(BuildContext context, Size size) {
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
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Form(
                  key: _form,
                  child: TextFormField(
                    controller: _pass,
                    textInputAction: TextInputAction.next,
                    obscureText: _isPasswordHidden,
                    validator: (val) {
                      if (val.isEmpty) return 'Field can not be empty';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter master password",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  "Proceed",
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
                onPressed: () {
                  if (_form.currentState.validate()) {
                    BlocProvider.of<EnterPasswordBloc>(context)
                        .add(CheckPasswordEvent(_pass.text));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Invalid Password"),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
