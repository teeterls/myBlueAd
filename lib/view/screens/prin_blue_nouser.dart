import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
//TODO BLUETOOTH AND LOCATION
class PrincipalBlueNoUser extends StatefulWidget {
  @override
  _PrincipalBlueNoUserState createState() => _PrincipalBlueNoUserState();
}

class _PrincipalBlueNoUserState extends State<PrincipalBlueNoUser> {

  @override
  void initState() {
    Future.delayed(Duration(seconds:2)).then((value)
    {
      _showAddProfileDialog(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //control estado, porque no se guardan anonimos o phone en la bbdd -> uid cambia cada vez.
    final userstate = Provider.of<UserState>(context, listen: false);
    return Padding(
    padding: const EdgeInsets.all(50),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>
    [
    if (userstate.user.phoneNumber!=null)
    Text("Welcome to myBlueAd, ${userstate.user.phoneNumber}!"),
    if (userstate.user.phoneNumber==null)
    Text("Welcome to myBlueAd!",  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
    Text("Waiting for blue ads...", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
    SizedBox(height: 20),
    BlueLoading(),
    ],),
    );
  }
}

Future _showAddProfileDialog(BuildContext context) async {
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
        Navigator.of(context).pushNamed('/addprofile', arguments: Provider.of<UserState>(context, listen:false).user.phoneNumber);
      },
        onLongPress: () {
          Navigator.of(context).pushNamed('/addprofile', arguments: Provider.of<UserState>(context, listen:false).user.phoneNumber);
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
          Navigator.of(context).pushNamed('/addprofile',  arguments: Provider.of<UserState>(context, listen: false).user.phoneNumber);
        },
        onLongPress: () {
          Navigator.of(context).pushNamed('/addprofile',  arguments: Provider.of<UserState>(context, listen: false).user.phoneNumber);
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
