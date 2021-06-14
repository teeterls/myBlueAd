import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:provider/provider.dart';

//boton beacon que crea la lista con las zonas, shuffle y redirige a la pagina de los ads.
class myBeaconButton extends StatelessWidget {
  bool _enabled;
  myBeaconButton(this._enabled);
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
    final userstate = Provider.of<UserState>(context, listen:false);
    return FloatingActionButton(
      child: Icon(Icons.bluetooth, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: _enabled==true ? Colors.white : Theme.of(context).primaryColor,),
      splashColor: Colors.blue,
      hoverColor: Colors.blue,
      disabledElevation: 0.1,
      backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==true ? Colors.white: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && _enabled==false ? Colors.white54 : _enabled==true ? Colors.blueAccent : Colors.white54,
      tooltip: _enabled==true ? "Beacon enabled" : "Beacon disabled",
      onPressed: _enabled==true ? () {
        _zonas.shuffle();
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
       // Navigator.of(context).pushNamed('/ads', arguments: _zonas[0]).then((value) {
         // _zonas.remove(value);

          //TODO NUEVA PAGINA PARA DEMO con streambuilder
          Navigator.of(context).pushNamed('/adsdemo', arguments: _zonas);
        //});
      } : null
    );
  }
}