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
  var _isSearching = false;

  List<PasswordModel> passwords = [];

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<PasswordModel> filteredPasswords = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShowPasswordBloc>(context).add(GetPasswordsEvent());

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredPasswords = passwords;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShowPasswordBloc, ShowPasswordState>(
      listener: (context, state) {
        if (state is GetPasswordState) {
          setState(() {
            passwords = state.passwords;
            filteredPasswords = passwords;
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
          if (_searchText.isNotEmpty) {
            List<PasswordModel> tempList = [];
            for (int i = 0; i < passwords.length; i++) {
              if (passwords[i]
                      .title
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()) ||
                  passwords[i]
                      .userName
                      .contains(_searchText.toLowerCase())) {
                tempList.add(passwords[i]);
              }
            }
            filteredPasswords = tempList;

            if (filteredPasswords.isEmpty)
              return Center(
                child: Text("No Data Found"),
              );
          }

          return ReorderableListView(
            buildDefaultDragHandles: _isDraggable,
            children: <Widget>[
              for (int index = 0; index < filteredPasswords.length; index++)
                Container(
                  key: Key('$index'),
                  color: index.isOdd ? oddItemColor : evenItemColor,
                  child: ListTile(
                    title: Text(filteredPasswords[index].title),
                    subtitle: Text(filteredPasswords[index].userName),
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
                          arguments: PasswordModelWithIndex(
                              index, filteredPasswords[index]));
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
      title: _isSearching
          ? TextField(
              controller: _filter,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search), hintText: 'Search...'))
          : Text("Show passwords"),
      leading: _isSearching
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isSearching = false;
                  _filter.clear();
                });
              },
              child: Icon(
                Icons.close,
                size: 26.0, // add custom icons also
              ),
            )
          : null,
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
          else if (!_isSearching)
            return Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        size: 26.0,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 10.0),
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
          else
            return Container();
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
        label: 'OK',
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
