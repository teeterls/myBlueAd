import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:provider/provider.dart';
//clase donde se encuentran los botones sign in

class SigninButtons extends StatelessWidget {

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
          },
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
        ),
        SignInButtonBuilder(
          shape: StadiumBorder(),
          icon: Icons.link,
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
          mini:true,
          text:"",
          onPressed: () {
            Navigator.of(context).pushNamed('/signinoptions', arguments: 'Link');
          },
        ),
        //TODO 3rd part auth
        SignInButton(
          Buttons.Facebook,
          mini:true,
          onPressed: () {
            Navigator.of(context).pushNamed('/signinsocial', arguments: 'facebook');},
          text:"",

        ),
        SignInButton(
          Buttons.Twitter,
          mini:true,
          onPressed: () {
            Navigator.of(context).pushNamed('/signinsocial', arguments: 'twitter');
          },
          text:"",
        ),

      ],
    );
  }
}

