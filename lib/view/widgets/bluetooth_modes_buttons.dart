import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:myBlueAd/services/firebase_db_retailstores.dart' as db;

//boton demo con query zona solo enabled si bluetooth on
class DemoButton extends StatelessWidget {
  bool _enabled;
  DemoButton(this._enabled);
  //zonas demo
  List<String> _zonas=
  [

    "welcome",
    "shoes",
    "jewelry",
    "perfumery",
    "sports"
  ];
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "demo",
      label: Text("Demo", style: TextStyle(color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),),
      icon: Icon(Icons.visibility, color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
      splashColor: Colors.blue,
      hoverColor: Colors.blue,
      disabledElevation: 0.1,
      backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==false ? Colors.white54 : _enabled==true ? Colors.blueAccent : Colors.white54,
      tooltip: _enabled==true ? "Demo enabled" : "Demo disabled",
      onPressed: _enabled==true ? () {
        _zonas.shuffle();
        //_showOptionDialog(context);
        //print(_lista[0]);
        //Baliza b = Baliza(url: "https://www.google.com", zona: "prueba");
        // _lista.add("prueba");
        //db.registerBeacon(b);
        /*List <String>_adurl = [
          "https://www.googlee.com"
        ];
        db.deleteFavAds(userstate.user.uid);*/
        //envia la zona a la pagina de ads
        //si se devuelve un valor es porque  no le gusta el anuncio
        //se quitan de las opciones
       //Navigator.of(context).pushNamed('/ads', arguments: _zonas[0]).then((value) {
         //_zonas.remove(value);
          Navigator.of(context).pushNamed('/adsdemo', arguments: _zonas);
        //});
      } : null
    );
  }
}

//TODO BOTON SCANNING, solo enabled si bluetooth on
class ScanButton extends StatelessWidget {
  bool _enabled;
  ScanButton(this._enabled);
  @override
  Widget build(BuildContext context) {
      return FloatingActionButton.extended(
          heroTag: "scan",
          label: Text("Start", style: TextStyle(color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
          icon: Icon(Icons.bluetooth, color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          disabledElevation: 0.1,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==false ? Colors.white54 : _enabled==true ? Colors.blueAccent : Colors.white54,
          tooltip: _enabled==true ? "Scanning enabled" : "Scanning disabled",
          onPressed: _enabled==true ? () {
           //TODO SCANNING DB
            Navigator.of(context).pushNamed('/scan');
            //db.resetUID('holaa');
            //});
          } : null
      );
    }

  }

  //clase stop button. con enable de si esta o no el bluetooth activado
  class StopButton extends StatelessWidget {
  StopButton(this._flutterblue, this._enabled);
  final FlutterBlue _flutterblue;
  bool _enabled;
    @override
    Widget build(BuildContext context) {
      return FloatingActionButton.extended(
          tooltip: _enabled==true ? "Stop enabled" : "Stop disabled",
        heroTag: "stop",
          label: Text("Stop", style: TextStyle(color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
          icon: Icon(Icons.stop, color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          backgroundColor: _enabled==true? Colors.red : Colors.white54,
          disabledElevation: 0.1,
          onPressed: _enabled== true ?()
          {
            _flutterblue
              .stopScan();
          } : null
      );
    }
  }

  //clase scanagain. con enable de si esta bluetooth activado o no
  class ScanAgainButton extends StatelessWidget {
    ScanAgainButton(this._flutterblue, this._enabled);
    final FlutterBlue _flutterblue;
    bool _enabled;
    @override
    Widget build(BuildContext context) {
      return FloatingActionButton.extended(
          heroTag: "scanagain",
          label: Text("Scan", style: TextStyle(color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
          icon: Icon(Icons.bluetooth, color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==false ? Colors.white54 : _enabled==true ? Colors.blueAccent : Colors.white54,
          disabledElevation: 0.1,
          onPressed: _enabled== true ?()
          {
            _flutterblue
                .startScan(timeout: Duration(seconds:4));
          } : null
      );
    }
    }



//boton demo primera etapa
  /*class BeaconButton extends StatelessWidget {
    List<String> _zonas=
    [

      "welcome",
      "shoes",
      "jewelry",
      "perfumery",
      "sports"
    ];
    bool _enabled;
    BeaconButton(this._enabled);
    @override
    Widget build(BuildContext context) {
      return FloatingActionButton(
          child: Icon(Icons.bluetooth, color: _enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          disabledElevation: 0.1,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==false ? Colors.white54 : _enabled==true ? Colors.blueAccent : Colors.white54,
          tooltip: _enabled==true ? "Demo enabled" : "Demo disabled",
          onPressed: _enabled==true ? () {
            _zonas.shuffle();
            Navigator.of(context).pushNamed('/adsdemo', arguments: _zonas);
          } : null
      );
    }
  }*/


