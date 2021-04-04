import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import 'custom_snackbar.dart';
import 'package:provider/provider.dart';
//clase donde se encuentran los botones sign in

class SigninButtons extends StatelessWidget {
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignInButtonBuilder(
          shape: StadiumBorder(),
          mini:true,
          icon: Icons.phone,
          text:"",
          onPressed: () {
            Navigator.of(context).pushNamed('/signinoptions', arguments: 'Phone');
            //Navigator.of(context).pushNamed('/phone');
          },
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
        ),
        SignInButtonBuilder(
          shape: StadiumBorder(),
          icon: Icons.link,
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
          mini:true,
          text:"",
          onPressed: () {
            Navigator.of(context).pushNamed('/signinoptions', arguments: 'Link');
          },
        ),
        SignInButton(
          Buttons.Facebook,
          mini:true,
          onPressed: () async {
            //metodo signin fb
            List e= await Provider.of<UserState>(context, listen:false).signInWithFacebook();
            print (e);
            if (e[0]!=null) {
              RegExp regex = new RegExp(pattern);
              //es email
              if (regex.hasMatch(e[0])) {
                List <dynamic> _credarg = ["Facebook", e[0]];
                //recibimos la pwd asociada al email.
                Navigator.of(context).pushNamed(
                    '/credentials', arguments: _credarg).then((pwd) async {
                      print(pwd);
                  String er = await Provider.of<UserState>(
                      context, listen: false).emailPwdCredentials(
                      e[0], pwd, e[1]);
                  if (er != null)
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                        "Sign in in failed with: ${er}.", context));
                  else {
                    //ok
                    Navigator.of(context).pushNamed("/userhome");
                  }
                });
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar("Sign in in failed with: ${e}.", context));
            }
            else {
              //ok
              Navigator.of(context).pushNamed("/userhome");
            }
            },
          text:"",

        ),
        SignInButton(
          Buttons.Twitter,
          mini:true,
          onPressed: () async {
            //metodo signin fb
            List e= await Provider.of<UserState>(context, listen:false).signInWithTwitter();
            if (e[0]!=null) {
              RegExp regex = new RegExp(pattern);
              //es email
              if (regex.hasMatch(e[0])) {
                List <dynamic> _credarg = ["Twitter", e[0]];
                //recibimos la pwd asociada al email.
                Navigator.of(context).pushNamed(
                    '/credentials', arguments: _credarg).then((pwd) async {
                      print(pwd);
                  String er = await Provider.of<UserState>(
                      context, listen: false).emailPwdCredentials(
                      e[0], pwd, e[1]);
                  if (er != null)
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                        "Sign in in failed with: ${er}.", context));
                  else {
                    //ok
                    Navigator.of(context).pushNamed("/userhome");
                  }
                });
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar("Sign in in failed with: ${e}.", context));
            }
            else {
              //ok
              Navigator.of(context).pushNamed("/userhome");
            }
          },
          text:"",
        ),

      ],
    );
  }
}

//boton signout
class mySignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    return FloatingActionButton(
      child: Icon(Icons.logout, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
      splashColor: Colors.blue,
      hoverColor: Colors.blue,
      backgroundColor: Colors.white54,
      tooltip: "Sign out",
      onPressed: () async => _showSignOutDialog(context),
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
            Text('Do you want to sign out?', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
          ]
      ),
      content:
      Provider.of<UserState>(context, listen: false).user.email!=null?
      Text("All your info & fav blue ads will be saved! See you soon! :)"):Text("See you soon! :)"),
      actions: [
        TextButton.icon(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
          onLongPress: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
          icon: Icon(Icons.logout, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Sign out", style: TextStyle(
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
            Text('Do you want to sign out?', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
          ]
      ),
      content:
      Provider.of<UserState>(context, listen: false).user.email!=null?
      Text("All your info & fav blue ads will be saved! See you soon! :)"):Text("See you soon! :)"),
      actions: [
        TextButton.icon(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
          onLongPress: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
          icon: Icon(Icons.logout, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Sign out", style: TextStyle(
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




