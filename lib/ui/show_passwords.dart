import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/bloc/show_password/show_password_state.dart';
import 'package:password_manager/models/password_model.dart';

class ShowPasswords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());
    return Scaffold(
        appBar: AppBar(title: Text("Show passwords")),
        body: BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
            builder: (context, state) {
          if (state is GetPasswordState) {
            return _showPasswords(state.passwords);
          } else {
            return Container();
          }
        }));
  }

  Widget _showPasswords(List<PasswordModel> passwords) {
    return ListView.separated(
        itemCount: passwords.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(passwords[index].title),
            subtitle: Text(passwords[index].userName),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/lock_icon_2.png'),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }
}
