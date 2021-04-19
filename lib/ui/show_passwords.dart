import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_bloc.dart';
import 'package:password_manager/bloc/show_password/show_password_event.dart';
import 'package:password_manager/bloc/show_password/show_password_state.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/models/password_model_with_index.dart';
import 'package:password_manager/utils/app_router.dart';

const String CHANGE_MASTER_PASSWORD = "Change Master Password";
const String LOGOUT = "Logout";

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
      appBar: AppBar(
        title: Text("Show passwords"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              _handleMenuClick(context, value);
            },
            itemBuilder: (BuildContext context) {
              return {CHANGE_MASTER_PASSWORD, LOGOUT}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
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
                Navigator.pushNamed(context, ShowDetailsRoute,
                    arguments: PasswordModelWithIndex(index, passwords[index]));
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

  void _handleMenuClick(BuildContext context, String value) {
    switch (value) {
      case LOGOUT:
        Navigator.pushNamedAndRemoveUntil(
            context, EnterMasterPasswordRoute, (r) => false);
        break;
      case CHANGE_MASTER_PASSWORD:
        Navigator.pushNamed(
          context,
          ChangeMasterPasswordRoute,
        );
        break;
    }
  }
}
