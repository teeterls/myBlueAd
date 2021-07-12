import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:myBlueAd/services/firestore_db_retailstores.dart' as db;

//boton demo con query zona solo enabled si bluetooth on
class DemoButton extends StatelessWidget {
  bool _enabled;
  DemoButton(this._enabled);
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
          Navigator.of(context).pushNamed('/blueadsdemo');
        //});
      } : null
    );
  }
}

class ScanButton extends StatefulWidget {
  bool _enabled;
  ScanButton(this._enabled);

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  FlutterBlue flutterblue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {


      return  FloatingActionButton.extended(
              heroTag: "search",
              label: Text("Ready", style: TextStyle(color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,)),
              icon: Icon(Icons.search, color: widget._enabled==true ? Colors.white : Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark? Colors.teal : Theme.of(context).primaryColor,),
              splashColor: Colors.blue,
              hoverColor: Colors.blue,
              disabledElevation: 0.1,
              backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==true ? Colors.blueAccent: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark && widget._enabled==false ? Colors.white54 : widget._enabled==true ? Colors.blueAccent : Colors.white54,
              tooltip: widget._enabled==true ? "Search nearby enabled" : "Search nearby disabled",
              onPressed: widget._enabled==true ? () async {
                flutterblue.startScan(allowDuplicates: true);
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


