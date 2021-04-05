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
  //boton
  bool _pressed;
  List <String> _lista= <String> [];

  @override
  void initState() {
    // TODO: implement initState
    _pressed=false;
  }
  @override
  Widget build(BuildContext context) {
    _lista.add("Hola");
    _lista.add("Hola1");
    _lista.add("Hola2");
    _lista.add("Hola3");
    _lista.add("Hola4");
    _lista.add("Hola5");
    _lista.shuffle();
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
            Visibility(visible: !_pressed, child: BlueLoading()),
            //BOTON QUE AÑADE BEACONS
            FlatButton(
              child: Text("shuffle"),
              onPressed: ()
                {
                  setState(() {
                    _pressed = !_pressed;
                  });
                  print(_lista);
                  _lista.shuffle();
                  print(_lista);
                }
            )
          ],),
      );
    }
  }
}
