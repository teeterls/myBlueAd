import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_appbar.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/custom_backbutton.dart';
import '../widgets/error.dart';
//bbdd
import '../../services/firestore_db_beacons.dart' as db;
import '../../services/firestore_db_user.dart' as dbuser;
import '../../services/firebase_storage.dart' as storage;
import '../widgets/loading.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AdsDemo extends StatefulWidget {
  AdsDemo(this._zonas);
final List <String> _zonas;

  @override
  _AdsDemoState createState() => _AdsDemoState();
}

//TODO METODOS STREAM. return streambuilder. devuelve Ad de forma repetitiva.
class _AdsDemoState extends State<AdsDemo> {
  Stream<String> zonademo (List<String> zonas) async*
  {
    for (int i=0; i<zonas.length; i++)
    {
      yield zonas[i];
      //forzamos delay
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: zonademo(widget._zonas),
      builder: (context, AsyncSnapshot<String> snapshot)
      {
        if (snapshot.hasError)
        {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        //switch-case menu de casos
        switch (snapshot.connectionState)
            {
        //stream null
          case ConnectionState.none:
            return Center(child: Error('An error occurred in the demo. Please try again'));
          //waiting for data
            case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          //llegan datos
            return Center(child: Text('${snapshot.data}', style: TextStyle(fontSize: 60),));
          case ConnectionState.done:
            return EndDemo(widget._zonas);
          //se acaban los datos a enviar. se muestran todas las zonas
        }
        return null;
      },
    );
  }
}

class EndDemo extends StatefulWidget {

  EndDemo(this._zonas);
  final List <String> _zonas;
  @override
  State<EndDemo> createState() => _EndDemoState();
}

class _EndDemoState extends State<EndDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
    child: SafeArea(
    child: Scaffold(
    key: _scaffoldKey,
    appBar: CustomAppBar(_scaffoldKey, context),
    drawer: CustomDrawer(),
    body:   SingleChildScrollView(
    child:  Center(
      child: Padding(
        padding: const EdgeInsets.only(top:180.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
          Text(
          "Your blue ads demo has finished", textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
            color: Colors.blueAccent,
          ),
        ),
              Center(
                child: Image.asset('assets/logo_store.png'),
              ),
               SizedBox(height:30),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    child: Text('Go back'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/userhome');
                    },
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                    child: Text('Repeat demo'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      elevation: 2,
                    ),
                    onPressed: () {
                      widget._zonas.shuffle();
                      Navigator.of(context).pushNamed('/adsdemo', arguments: widget._zonas);
                    },
                  ),
                ],
              ),

            ]

          ),
      ),
    ),
    )
    )
    )
    );
  }
}

