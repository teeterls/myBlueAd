import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
//TODO BLUETOOTH AND LOCATION dialogs
class PrincipalBlueNoUser extends StatefulWidget {
  @override
  _PrincipalBlueNoUserState createState() => _PrincipalBlueNoUserState();
}

class _PrincipalBlueNoUserState extends State<PrincipalBlueNoUser> {
  final Duration initialDelay = Duration(milliseconds: 500);
  //boton
  bool _pressed;
  List<String> _zonas=
  [
    "welcome",
    "shoes",
    "jewelry",
    "perfumary",
    "sports"
  ];

  @override
  void initState() {
    _pressed = false;
    //dialogo de crear perfil
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
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>
        [
          DelayedDisplay(
            delay: initialDelay,
            child: Text(
              "Welcome!", textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height:120),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DelayedDisplay(
                    delay: Duration(seconds:initialDelay.inSeconds + 2),
                    child: Image.asset("assets/logo_store.png", width:80)
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: DelayedDisplay(
                    delay: Duration(seconds: initialDelay.inSeconds + 2),
                    child: Text(
                      "myBlueStore",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ]
          ),
          SizedBox(
            height: 30.0,
          ),
          DelayedDisplay(
            delay: Duration(seconds:initialDelay.inSeconds + 3),
            child: Center(
              child: Text("Waiting for blue ads...", style: TextStyle( fontSize:18,
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            ),
          ),
          //todo cambiar que este esperando hasta que le llegue uid
          SizedBox(height: 30),
          DelayedDisplay(
            delay: Duration(seconds:initialDelay.inSeconds + 3),
            child:   Visibility(visible: !_pressed, child: BlueLoading()),
          ),
          SizedBox(height: 30),
          DelayedDisplay(
            delay: Duration(seconds: initialDelay.inSeconds + 3),
            child:  Center(
              child: OutlinedButton(
                  child: Text("Beacon", style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
                  ),
                  onPressed: () {
                    setState(() {
                      _pressed = !_pressed;
                    });
                    _zonas.shuffle();
                    //print(_lista[0]);
                    //Baliza b = Baliza(url: "https://www.google.com", zona: "prueba");
                    // _lista.add("prueba");
                    //db.registerBeacon(b);
                    Navigator.of(context).pushNamed('/ads', arguments: _zonas[0]);
                  }
              ),
            ),),
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
        Navigator.of(context).pushNamed('/signlogin', arguments: "Log in");
      },
        onLongPress: () {
          Navigator.of(context).pushNamed('/signlogin', arguments: "Log in");
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
          Navigator.of(context).pushNamed('/signlogin',  arguments: "Log in");
        },
        onLongPress: () {
          Navigator.of(context).pushNamed('/signlogin',  arguments: "Log in");
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
