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

class ShowPasswords extends StatefulWidget {
  @override
  _ShowPasswordsState createState() => _ShowPasswordsState();
}

class _ShowPasswordsState extends State<ShowPasswords> {
  var _isDraggable = false;

  List<PasswordModel> passwords = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShowPasswordBloc, ShowPasswordState>(
      listener: (context, state) {
        if (state is GetPasswordState) {
          setState(() {
            passwords = state.passwords;
          });
        }
        if (state is RearrangedState) {
          _showSnackbar();
        }
        if (state is LoadingState) {
          _showLoaderDialog();
        } else {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      },
      child: _showPasswords(),
    );
  }

  Widget _showPasswords() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final oddItemColor = colorScheme.primary.withOpacity(0.05);
    final evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: _showAppBar(),
      body: () {
        if (passwords.isEmpty) {
          return Center(
            child: Text("No Data Found"),
          );
        } else {
          return ReorderableListView(
            buildDefaultDragHandles: _isDraggable,
            children: <Widget>[
              for (int index = 0; index < passwords.length; index++)
                Container(
                  key: Key('$index'),
                  color: index.isOdd ? oddItemColor : evenItemColor,
                  child: ListTile(
                    title: Text(passwords[index].title),
                    subtitle: Text(passwords[index].userName),
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/lock_icon_2.png'),
                    ),
                    trailing: () {
                      return _isDraggable
                          ? Icon(Icons.drag_handle)
                          : Icon(Icons.keyboard_arrow_right);
                    }(),
                    onTap: () {
                      Navigator.pushNamed(context, ShowDetailsRoute,
                          arguments:
                              PasswordModelWithIndex(index, passwords[index]));
                    },
                  ),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = passwords.removeAt(oldIndex);
                passwords.insert(newIndex, item);
              });
            },
          );
        }
      }(),
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

  Widget _showAppBar() {
    return AppBar(
      title: Text("Show passwords"),
      actions: <Widget>[
        () {
          if (_isDraggable)
            return Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ShowPasswordBloc>(context)
                            .add(RearrangeListEvent(passwords));
                        setState(() {
                          _isDraggable = false;
                        });
                      },
                      child: Icon(
                        Icons.done,
                        size: 26.0,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDraggable = false;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 26.0,
                      ),
                    )),
              ],
            );
          else
            return Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDraggable = true;
                        });
                      },
                      child: Icon(
                        Icons.drag_indicator,
                        size: 26.0,
                      ),
                    )),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleMenuClick(context, value);
                  },
                  itemBuilder: (BuildContext context) {
                    return {CHANGE_MASTER_PASSWORD, LOGOUT}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            );
        }()
      ],
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

  void _showSnackbar() {
    final snackBar = SnackBar(
      content: Text('Order updated'),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showLoaderDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
            ],
          ),
        );
      },
    );
  }
}
