import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:animated_button/animated_button.dart';

import 'package:myBlueAd/services/firestore_db_user.dart' as db;
class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}
//TODO QUE SE LE PASE LA ZONA para el boton de anonimo.
//TODO llevar STATE a otras posibles paginas
//TODO LOCATION con alertdialog

class _PrincipalBlueState extends State<PrincipalBlue> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final Duration initialDelay = Duration(milliseconds: 500);
  //boton
  bool _pressed;
  @override
  void initState() {
    Future.delayed(Duration(seconds:2)).then((value)
       async  {
        //dialogo de crear perfil
    if (Provider.of<UserState>(context, listen: false).user.email==null)
    _showAddProfileDialog(context);
      if (!await _checkDeviceBluetoothIsOn())
        _showBluetoothDialog(context);
    });

    _pressed = false;
  }


  @override
  Widget build(BuildContext context) {
    //control estado, porque no se guardan anonimos o phone en la bbdd -> uid cambia cada vez.
   final userstate = Provider.of<UserState>(context, listen: false);

      return StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              if (userstate.user.email!=null) {
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
                          "Welcome,", textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds + 1),
                        child: Text(
                          "${userstate.user.email}!", textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      if (userstate.user.email == null &&
                          userstate.user.phoneNumber != null)
                        DelayedDisplay(
                          delay: Duration(seconds: initialDelay.inSeconds + 1),
                          child: Text(
                            "${userstate.user.phoneNumber}!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      SizedBox(height: 120),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DelayedDisplay(
                                delay: Duration(
                                    seconds: initialDelay.inSeconds + 2),
                                child: Image.asset(
                                    "assets/logo_store.png", width: 80)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: DelayedDisplay(
                                delay: Duration(seconds: initialDelay
                                    .inSeconds + 2),
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
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child: Text("Waiting for blue ads...",
                            style: TextStyle(fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),),
                        ),
                      ),
                      //todo cambiar que este esperando hasta que le llegue uid
                      SizedBox(height: 30),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child:  BlueLoading(),
                        ),
                      ),
                      //SizedBox(height: 30),
                    ],),
                );
              }
              else if (userstate.user.phoneNumber!=null)
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
                          "Welcome,", textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                        DelayedDisplay(
                          delay: Duration(seconds: initialDelay.inSeconds + 1),
                          child: Text(
                            "${userstate.user.phoneNumber}!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      SizedBox(height: 120),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DelayedDisplay(
                                delay: Duration(
                                    seconds: initialDelay.inSeconds + 2),
                                child: Image.asset(
                                    "assets/logo_store.png", width: 80)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: DelayedDisplay(
                                delay: Duration(seconds: initialDelay
                                    .inSeconds + 2),
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
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child: Text("Waiting for blue ads...",
                            style: TextStyle(fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),),
                        ),
                      ),
                      //todo cambiar que este esperando hasta que le llegue uid
                      SizedBox(height: 30),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child:  BlueLoading(),
                        ),
                      ),
                      //SizedBox(height: 30),
                    ],),
                );
              else
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
                          "Welcome,", textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 120),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DelayedDisplay(
                                delay: Duration(
                                    seconds: initialDelay.inSeconds + 2),
                                child: Image.asset(
                                    "assets/logo_store.png", width: 80)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: DelayedDisplay(
                                delay: Duration(seconds: initialDelay
                                    .inSeconds + 2),
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
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child: Text("Waiting for blue ads...",
                            style: TextStyle(fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),),
                        ),
                      ),
                      //todo cambiar que este esperando hasta que le llegue uid
                      SizedBox(height: 30),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child:  BlueLoading(),
                        ),
                      ),
                      //SizedBox(height: 30),
                    ],),
                );
            } else
            //TODO RETURN, TIENE QUE DEVOLVE ALGO -> la misma page pero sin el boton.
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
                      "Welcome,", textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  if (userstate.user.email!=null)
                    DelayedDisplay(
                      delay: Duration(seconds:initialDelay.inSeconds + 1),
                      child: Text(
                        "${userstate.user.email}!", textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  if (userstate.user.phoneNumber!=null)
                    DelayedDisplay(
                      delay: Duration(seconds:initialDelay.inSeconds + 1),
                      child: Text(
                        "${userstate.user.phoneNumber}!", textAlign: TextAlign.left,
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
                      ],
                  ),
                  SizedBox(height:30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: DelayedDisplay(
                          delay: Duration(seconds:initialDelay.inSeconds + 3),
                          child: Text(
                            "A lot of blue ads are waiting for you!", textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Provider
                                  .of<ThemeModel>(context, listen: false)
                                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:10),
                          DelayedDisplay(
                           delay: Duration(seconds:initialDelay.inSeconds + 3),
                              child:Icon(Icons.bluetooth, color: Provider
                                .of<ThemeModel>(context, listen: false)
                                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                                .of(context)
                                 .primaryColor)),
                              ],
                             ),

                ],),
            ) ;
          });
    }

  Future _showAddProfileDialog(BuildContext context) async {
    if (Platform.isAndroid)
    {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context, true),
      );

    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context, true),
      );
    }
  }

  Future _showBluetoothDialog(BuildContext context) async {
    if (Platform.isAndroid)
    {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context, false),
      );

    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context, false),
      );
    }
  }

  //todo añadir un flag que es o anonymo o blue -> true anonimo, blue false
  Widget _buildAndroidAlertDialog(BuildContext context, bool type) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text( type==true? 'Save your fav blue ads' : 'Enable Bluetooth', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
            Icon(type==true?Icons.favorite_border: Icons.bluetooth, color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor),

          ]
      ),
      content:
      Text(type==true?"Creat a profile with an email account to save your info & fav blue ads!" : "Enable Bluetooth in your device so you can scan your blue ads nearby!"),
      actions: [
        if (type)
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
          icon:Icon(type==true?Icons.cancel_outlined : Icons.close, color: Colors.red),
          label: Text(type==true?"Not yet": "Ok", style: TextStyle(
              color: Colors.red
          )),
        ),
      ],
    );
  }

  Widget _buildiOSAlertDialog(BuildContext context, bool type) {
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

  Future<bool> _checkDeviceBluetoothIsOn() async {
    return await flutterBlue.isOn;
  }
  }







