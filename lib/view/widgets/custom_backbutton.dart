import 'package:flutter/material.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import '../../model/theme_model.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
class CustomBackButton extends StatelessWidget {

     @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Go back",
        child: Icon(Platform.isIOS ? Icons.arrow_back_ios: Icons.arrow_back, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
        hoverColor: Colors.blue,
        splashColor: Colors.blue,
        backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.white: Colors.white54,
      onPressed: ()
        {
          if (Provider.of<UserState>(context, listen:false).user==null)
            {
              Navigator.of(context).pushNamed('/home');
            }
          else
          Navigator.of(context).pushNamed('/userhome');
        }
    );
  }
}

class CustomFavBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        tooltip: "Go back",
        child: Icon(Platform.isIOS ? Icons.arrow_back_ios: Icons.arrow_back, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
        hoverColor: Colors.blue,
        splashColor: Colors.blue,
        backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.white: Colors.white54,
        onPressed: ()
        {
          if (Provider.of<UserState>(context, listen:false).user==null)
          {
            Navigator.of(context).pushNamed('/home');
          }
          else
            Navigator.of(context).pop();
        }
    );
  }
}
