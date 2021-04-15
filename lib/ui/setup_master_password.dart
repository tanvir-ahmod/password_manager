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
    var size = MediaQuery.of(context).size;

    return BlocBuilder<SetupMasterPasswordBloc, SetupMasterPasswordState>(
        builder: (context, state) {
      if (state is MasterPasswordSetSate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, ShowPasswordsRoute, (r) => false);
        });
      }
      return _setupMasterPasswordUI(size);
    });
  }

  Widget _setupMasterPasswordUI(Size size) {
    final focus = FocusNode();
    return Scaffold(
      appBar: AppBar(title: Text("Setup master password")),
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
                        labelText: 'Password',
                        border: OutlineInputBorder(),
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
                        if (val != _pass.text) return 'Password does not match';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
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
              child: Text("Set Password"),
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
                  BlocProvider.of<SetupMasterPasswordBloc>(context)
                      .add(SaveMasterPasswordEvent(_pass.text));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
