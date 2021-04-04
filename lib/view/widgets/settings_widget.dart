import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:provider/provider.dart';

import 'custom_snackbar.dart';

//TODO cambios email + dialog
//reset pwd y delete account

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>
              [
              Padding(
                padding: const EdgeInsets.only(left:5, top: 10.0),
                child: Text("Settings", style: TextStyle(
                  fontFamily: "Verdana",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),),
              ),
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SignInButtonBuilder(
          shape: StadiumBorder(),
          icon: Icons.link,
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
          mini:true,
          text:"",
          onPressed: () {

          },
        ),
        GradientButton(
          increaseWidthBy: 15.0,
          increaseHeightBy: 10.0,
          shapeRadius: BorderRadius.circular(10.0),
          //registrarse
          child: Center(child: Text('Reset password')),
          callback: () async {
            String e= await Provider.of<UserState>(context, listen:false).resetPasswordUser(Provider.of<UserState>(context).user.email);
            if (e!=null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Change password failed with: ${e}.", context));
            } else
              //se queda donde esta
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar(
                      "Email sent to ${Provider.of<UserState>(context).user.email} to reset your password",
                      context));
          },
          gradient: Gradients.jShine,
          shadowColor: Gradients.jShine.colors.last.withOpacity(
              0.25),
        ),
        GradientButton(
          increaseWidthBy: 15.0,
          increaseHeightBy: 10.0,
          //entrar
          child: Text('Delete account'),
          callback: () async => _showSignOutDialog(context),
          shapeRadius: BorderRadius.circular(10.0),
          gradient: Gradients.ali,
          shadowColor: Gradients.ali.colors.last
              .withOpacity(0.25),
        ),
      ],
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
        TextButton.icon(
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
          icon: Icon(Icons.delete_forever, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Delete account", style: TextStyle(
            color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
          )),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
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
        TextButton.icon(
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
          icon: Icon(Icons.delete_forever, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Delete account", style: TextStyle(
            color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
          )),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
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
}
