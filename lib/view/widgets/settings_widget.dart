import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'custom_appbar.dart';
import 'custom_snackbar.dart';

//TODO cambios email + dialog
//reset pwd y delete account
//TODO SCAFFOLD con drawer

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                  [
                  Padding(
                    padding: const EdgeInsets.only(left:5, top: 20.0),
                    child: Text("Settings", style: TextStyle(
                      fontFamily: "Verdana",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),),
                  ),
                  SizedBox(height:40),
                  SettingsButtons(),
                ]
          ),
    );
  }
}

//todo no hace falta usuario, se coge el email del userstate
class SettingsButtons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
        Container(
        width: 300,
        height:60,
        child: ElevatedButton(

          onPressed: () async => Navigator.of(context).pushNamed('/useraction', arguments: "changeemail"),
          child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children : <Widget> [
                Text("Change email", style: TextStyle(color:Colors.white, fontSize: 16)),
                Icon(Icons.arrow_forward_ios, color:Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Colors.yellowAccent),
              ]
          ),
          style: OutlinedButton.styleFrom(
              backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent : Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation:3.0
          ),
        ),
      ),
                SizedBox(height:20),
      Container(
      width: 300,
      height:60,
      child: ElevatedButton(
      onPressed: () async
      {
        String e= await Provider.of<UserState>(context, listen:false).resetPasswordUser(Provider.of<UserState>(context, listen:false).user.email);
        if (e!=null)
        {
          ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar("Change password failed with: ${e}.", context));
        } else
          //se queda donde esta
          ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                  "Email sent to ${Provider.of<UserState>(context, listen:false).user.email} to reset your password",
                  context));
      },
      child: Row (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children : <Widget> [
      Text("Change password", style: TextStyle(color:Colors.white, fontSize: 16)),
      Icon(Icons.arrow_forward_ios, color:Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Colors.yellowAccent),
      ]
      ),
      style: OutlinedButton.styleFrom(
      backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      ),
      elevation:3.0
      ),
      ),
      ),
                SizedBox(height:20),
                Container(
                width: 300,
      height:60,
      child: ElevatedButton(
      onPressed: () async => _showSignOutDialog(context),
      child: Row (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children : <Widget> [
      Text("Delete my account", style: TextStyle(color:Colors.white, fontSize: 16)),
      Icon(Icons.arrow_forward_ios, color:Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Colors.yellowAccent),
      ]
      ),
      style: OutlinedButton.styleFrom(
      backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      ),
      elevation:3.0
      ),
      ),),
        ],
      ),
    );
  }

  Future _showSignOutDialog(BuildContext context) async {
    if (Platform.isAndroid)
    {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context),
      );

    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context),
      );
    }
  }

  Widget _buildAndroidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Expanded(
              child: Text('Do you want to delete your account?', style: TextStyle(color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor)),
            ),
          ]
      ),
      content: Text("All your info will be deleted! Goodbye! :)"),
      actions: [
        OutlinedButton(
          child: Text('Delete account'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            elevation: 2,
          ),
          onPressed: () async {
            String e= await Provider.of<UserState>(context, listen:false).deleteUser();
            if (e!=null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account failed with: ${e}.", context));
            } else
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account successfully", context));
            Navigator.of(context).pushNamed('/');
          },
          onLongPress: () async {
            String e= await Provider.of<UserState>(context, listen:false).deleteUser();
            if (e!=null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account failed with: ${e}.", context));
            } else
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account successfully", context));
            Navigator.of(context).pushNamed('/');
          },

        ),
        OutlinedButton(
          child: Text('Not yet'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.grey,
            elevation: 2,
          ),

          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildiOSAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Expanded(
              child: Text('Do you want to delete your account?', style: TextStyle(color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor)),
            ),
          ]
      ),
      content: Text("All your info will be deleted! Goodbye! :)"),
      actions: [
            OutlinedButton(
            child: Text('Delete account'),
            style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            elevation: 2,
            ),
          onPressed: () async {
            String e= await Provider.of<UserState>(context, listen:false).deleteUser();
            if (e!=null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account failed with: ${e}.", context));
            } else
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account successfully", context));
            Navigator.of(context).pushNamed('/');
          },
          onLongPress: () async {
            String e= await Provider.of<UserState>(context, listen:false).deleteUser();
            if (e!=null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account failed with: ${e}.", context));
            } else
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Delete account successfully", context));
            Navigator.of(context).pushNamed('/');
          },

        ),
            OutlinedButton(
            child: Text('Not yet'),
            style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.grey,
            elevation: 2,
            ),

          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

