import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';

class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

//TODO DETECTAR BLUETOOTH Y LOCATION con alertdialog

class _PrincipalBlueState extends State<PrincipalBlue> {
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
            "Welcome,", textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.blueAccent,
            ),
          ),
        ),
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







