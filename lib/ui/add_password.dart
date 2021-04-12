import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_bloc.dart';
import 'package:password_manager/bloc/add_password/add_password_event.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/password_manager.dart';

class AddPassword extends StatefulWidget {
  @override
  _AddPasswordState createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Add password")),
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
                        labelText: 'Username / Email (optional)',
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
            ElevatedButton(
              child: Text("Save", style: TextStyle(fontSize: 16),),
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
                  String encryptedPassword = PasswordManager.encryptData(_pass.text, await PasswordManager.getDecryptedMasterKey());
                  BlocProvider.of<AddPasswordBloc>(context)
                      .add(InsertPasswordEvent(PasswordModel(title: _title.text, password: encryptedPassword, userName: _userName.text)));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
