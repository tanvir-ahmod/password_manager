import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/bloc/show_password/show_password_state.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/utils/app_router.dart';

class ShowPasswords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());
    return BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
        builder: (context, state) {
      if (state is GetPasswordState) {
        return _showPasswords(context, state.passwords);
      } else {
        return _showPasswords(context, <PasswordModel>[]);
      }
    });
  }

  Widget _showPasswords(BuildContext context, List<PasswordModel> passwords) {
    return Scaffold(
      appBar: AppBar(title: Text("Show passwords")),
      body: ListView.separated(
          itemCount: passwords.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(passwords[index].title),
              subtitle: Text(passwords[index].userName),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/lock_icon_2.png'),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ShowDetailsRoute,
                    arguments: passwords[index]
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          }),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddPasswordRoute,
          );
        },
      ),
    );
  }
}
