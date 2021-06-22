import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
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

//funcion que devuelva el id con el maximo rssi, el que esta más cerca.
String getmaxrssi(List <ScanResult> results) {
  List <int> _rssi = [];
  ScanResult def;
  print(results);
    for (ScanResult r in results) {
      _rssi.add(r.rssi);
      _rssi.reduce(max);
      if (r.rssi == _rssi.reduce(max))
        def = r;
    }
    return def.device.id.id;
  }


class ScanButton extends StatefulWidget {
  bool _enabled;
  ScanButton(this._enabled);

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  FlutterBlue flutterblue = FlutterBlue.instance;

  List <ScanResult> res=[];
  String uid;

  @override
  Widget build(BuildContext context) {
      return FloatingActionButton.extended(
          heroTag: "scan",
          label: Text("Start", style: TextStyle(color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
          icon: Icon(Icons.bluetooth, color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          disabledElevation: 0.1,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==false ? Colors.white54 : widget._enabled==true ? Colors.blueAccent : Colors.white54,
          tooltip: widget._enabled==true ? "Scan enabled" : "Scan disabled",
          onPressed: widget._enabled==true ? () async {
            //flutterblue.stopScan();
            //empezamos el escaneo y le pasamos la instancia a la siguiente pagina
            flutterblue.startScan(scanMode: ScanMode.lowPower);
            flutterblue.scanResults.listen((results)  {
              // do something with scan results
              //for (ScanResult r in results) {
                //print('${r.device.name} found! rssi: ${r.rssi} id ${r.device.id}');
             // }
              if (results!=null)
              res=results;
            });
            //forzamos a que espere un poco
            if (getmaxrssi(res)==null)
              await Future.delayed(Duration(milliseconds:500));
            //comprobamos si es el primero escaneo, si todos los uid estan a null en la bbdd.
            //si lo es añade el uid + proximo en cualquier doc random
            if (await db.nullUID()) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Adding scanned beacons to database...", context));
              //se le da un tiempo para que escanee , por si acaso.
              await Future.delayed(Duration(seconds: 4));
              db.setUID(getmaxrssi(res));
            }
            else
              {
               // flutterblue.stopScan();
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Start scanning in a few seconds...", context));
                await Future.delayed(Duration(seconds: 4));
                db.resetUID(getmaxrssi(res));
              }

            //por si acaso
            /*if (getmaxrssi(res)==null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Please scan again.", context));
                  flutterblue.stopScan();
            }
            else {
              print(getmaxrssi(res));

            }*/
            //});
            //flutterblue.stopScan();
            Navigator.of(context).pushNamed(
                '/scan');
          } : null
      );
    }
}

  //clase stop button. con enable de si esta o no el bluetooth activado, no hace nada masque parar el scan
  class StopButton extends StatelessWidget {
  StopButton(this._enabled);
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
            FlutterBlue.instance
              .stopScan();
          } : null
      );
    }
  }
//scan again button, vuelve a empezar el scanning
  class ScanAgainButton extends StatefulWidget {

    ScanAgainButton(this._enabled);
    bool _enabled;

  @override
  State<ScanAgainButton> createState() => _ScanAgainButtonState();
}

class _ScanAgainButtonState extends State<ScanAgainButton> {
    FlutterBlue flutterblue = FlutterBlue.instance;

    List <ScanResult> res=[];

    String uid;

    @override
    Widget build(BuildContext context) {
      return FloatingActionButton.extended(
          tooltip: widget._enabled==true ? "Scan enabled" : "Scan disabled",
          heroTag: "scanagain",
          label: Text("Scan", style: TextStyle(color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
          icon: Icon(Icons.bluetooth, color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
          splashColor: Colors.blue,
          hoverColor: Colors.blue,
          backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==false ? Colors.white54 : widget._enabled==true ? Colors.blueAccent : Colors.white54,
          disabledElevation: 0.1,
          onPressed: widget._enabled== true ?() async
          {
            flutterblue.startScan(scanMode: ScanMode.lowPower);
            flutterblue.scanResults.listen((results) {
              // do something with scan results
              //for (ScanResult r in results) {
              //print('${r.device.name} found! rssi: ${r.rssi} id ${r.device.id}');
              // }
              if (results != null)
                res = results;
            });

            //forzamos a que espere un poco
            if (getmaxrssi(res)==null)
              await Future.delayed(Duration(milliseconds:500));
            //se supone que ya no esta null el uid, pero lo comprobamos por si se ha borrado de la bbdd
            if (await db.nullUID()) {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                  "Adding scanned beacons to database...", context));
              //se le da un tiempo para que escanee , por si acaso.
              await Future.delayed(Duration(seconds: 4));
              db.setUID(getmaxrssi(res));
            }

            //por si acaso
            if (getmaxrssi(res) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Please scan again.", context));
              flutterblue.stopScan();
            }
            else {
              print(getmaxrssi(res));

          }

            }


            //FlutterBlue.instance
                //.startScan(timeout: Duration(seconds:4));
           : null
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


