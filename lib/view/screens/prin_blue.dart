import 'package:flutter/material.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

//TODO DETECTAR BLUETOOTH Y LOCATION

class _PrincipalBlueState extends State<PrincipalBlue> {
  @override
  Widget build(BuildContext context) {
    //control estado, porque no se guardan anonimos o phone en la bbdd -> uid cambia cada vez.
    final userstate = Provider.of<UserState>(context, listen: false);
    if (userstate.user.email != null) {
      return  Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>
          [
            Text("Welcome to myBlueAd, ${userstate.user.email}!",  style: TextStyle(fontSize:12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            SizedBox(height:20),
            Text("Waiting for blue ads...", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            BlueLoading()
          ],),
      );
    }
  }
}
