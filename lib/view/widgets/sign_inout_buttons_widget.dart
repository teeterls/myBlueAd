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





