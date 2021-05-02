import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../services/firestore_db_beacons.dart' as db;


class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

//TODO DETECTAR BLUETOOTH Y LOCATION

class _PrincipalBlueState extends State<PrincipalBlue> {
  WebViewController _controller;
  //boton
  bool _pressed;
  List <String> _lista = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    _lista.add("Welcome");
    _lista.add("Zapateria");
    _lista.add("Joyeria");
    _lista.add("Perfumeria");
    _lista.shuffle();
    //control estado, porque no se guardan anonimos o phone en la bbdd -> uid cambia cada vez.
    final userstate = Provider.of<UserState>(context, listen: false);
    if (userstate.user.email != null) {
      return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>
          [
            Text("Welcome to myBlueAd, ${userstate.user.email}!",
                style: TextStyle(fontSize: 12,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Waiting for blue ads...", style: TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            Visibility(visible: !_pressed, child: BlueLoading()),
            //BOTON QUE MUESTRA BEACONS
            Center(
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
                    //print(_lista);
                    _lista.shuffle();
                    print(_lista[0]);
                    //Baliza b = Baliza(url: "https://www.google.com", zona: "prueba");
                   // _lista.add("prueba");
                    //db.registerBeacon(b);
                    Navigator.of(context).pushNamed('/ads', arguments: _lista[0]);
                    //string aleatorio
                    //print(_lista);
                  }
              ),
            )
          ],),
      );
    }
  }

}







