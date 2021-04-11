import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/utils/app_router.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: Text("Password Manager")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.asset(
                "assets/images/lock_icon.png",
                height: size.height * 0.3,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 28)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Manage your passwords by setting a master password",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(
              height: 120,
            ),
            ElevatedButton(
                child: Text("Get Started"),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SetupMasterPasswordRoute, (r) => false);
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.lightBlue)))))
          ],
        ));
  }
}
