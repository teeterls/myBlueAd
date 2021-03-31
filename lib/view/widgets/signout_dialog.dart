import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';

import 'dart:io' show Platform;


Future _showSignOutDialog(BuildContext context) async {
  if (Platform.isAndroid)
  {
    return showDialog(
      context: context,
      builder: (_) => _buildAndroidSignOutDialog(context),
    );

  } else if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => _buildiOSSignOutDialog(context),
    );
  }
}

Widget _buildAndroidSignOutDialog(BuildContext context) {
  return AlertDialog(
    title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>
        [
          Text('Save your fav blue ads', style: TextStyle(color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
              .of(context)
              .primaryColor)),
          Icon(Icons.favorite_border, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
              .of(context)
              .primaryColor),

        ]
    ),
    content:
    Text("Creat a profile with an email account to save your info & fav blue ads!"),
    actions: [
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/addprofile');
        },
        icon: Icon(Icons.add, color: Provider
            .of<ThemeModel>(context, listen: false)
            .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
        label: Text("Create profile", style: TextStyle(
          color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
        )),
      ),
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon:Icon(Icons.cancel_outlined, color: Colors.red),
        label: Text("Not yet", style: TextStyle(
            color: Colors.red
        )),
      ),
    ],
  );
}

Widget _buildiOSSignOutDialog(BuildContext context) {
  return CupertinoAlertDialog(
    title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>
        [
          Text('Save your fav blue ads', style: TextStyle(color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
              .of(context)
              .primaryColor)),
          Icon(Icons.favorite_border, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
              .of(context)
              .primaryColor),

        ]
    ),
    content:
    Text("Creat a profile with an email account to save your info & fav blue ads!"),
    actions: [
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/addprofile');
        },
        icon: Icon(Icons.add, color: Provider
            .of<ThemeModel>(context, listen: false)
            .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
        label: Text("Create profile", style: TextStyle(
          color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
        )),
      ),
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon:Icon(Icons.cancel_outlined, color: Colors.red),
        label: Text("Not yet", style: TextStyle(
            color: Colors.red
        )),
      ),
    ],
  );
}