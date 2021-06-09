import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

class _PrincipalBlueState extends State<PrincipalBlue> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final Duration initialDelay = Duration(milliseconds: 500);

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
                      //SizedBox(height: 30),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds + 3),
                        child: Center(
                          child:  Lottie.asset('assets/2727-qimtronics.json', width: 200, height: 180),
                        ),
                      ),
                      //SizedBox(height: 30),
                    ],),
                );
              }
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
            delay: Duration(seconds:initialDelay.inSeconds + 3),
            child: Center(
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
            ),),
                    SizedBox(height:20),
                    DelayedDisplay(
                      delay: Duration(seconds: initialDelay.inSeconds + 3),
                      child: Center(
                        child:  Lottie.asset('assets/12435-turn-on-bluetooth.json', width: 200, height: 100),
                      ),
                    ),
                    //SizedBox(height: 30),
                  ],),
              );

          });
    }
  }







