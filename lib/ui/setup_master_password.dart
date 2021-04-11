import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/utils/constants.dart';
import 'package:password_manager/utils/password_manager.dart';

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
                  await _saveMasterPassword(_pass.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _saveMasterPassword(String password) async {
    final storage = new FlutterSecureStorage();
    String randomKey = PasswordManager.generateRandomKey(32);
    String plainPass = _generateMinimum32CharMasterPassword(_pass.text);
    String encryptedMasterPassword =
        PasswordManager.encryptData(plainPass, randomKey);
    await storage.write(key: Constants.RANDOM_KEY, value: randomKey);
    await storage.write(
        key: Constants.ENCRYPTED_MASTER_PASSWORD,
        value: encryptedMasterPassword);
  }

  String _generateMinimum32CharMasterPassword(String masterPassword) {
    int passwordLength = masterPassword.length;

    // minimum key length must be 32
    if (passwordLength < 32) {
      int requiredLength = 32 - passwordLength;
      for (var i = 0; i < requiredLength; i++) {
        masterPassword += ".";
      }
    }
    return masterPassword;
  }
}
