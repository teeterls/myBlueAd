import 'dart:async';
import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/screens/user_home_screen.dart';
import 'package:myBlueAd/view/screens/zona_beacon.dart';
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
import 'package:flutter_blue/flutter_blue.dart';

class AdsDemo extends StatefulWidget {
  AdsDemo(this._zonas);
final List <String> _zonas;

  @override
  _AdsDemoState createState() => _AdsDemoState();
}

//TODO streambuilder flutterblue, porque pierde la instancia que tenia en userhomescreen.
class _AdsDemoState extends State<AdsDemo> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  Stream<Widget> zonademo (List<String> zonas) async*
  {
    zonas.shuffle();
    //forzar
    await Future.delayed(Duration(seconds: 3));
    for (int i=0; i<zonas.length; i++)
    {
      yield WillPopScope(
        //no deja ir para atras
          onWillPop: () async => false,
          child:SafeArea(
             child: StreamBuilder<BluetoothState>(
             stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/ads', arguments: zonas[i]);
                },
                onLongPress: () {
                  Navigator.of(context).pushNamed('/ads', arguments: zonas[i]);
                },
                onDoubleTap: () {
                  Navigator.of(context).pushNamed('/ads', arguments: zonas[i]);
                },
                child: Card(
                  child: Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/${zonas[i]}_demo.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        color: Colors.black.withOpacity(0.35),
                        child: ListTile(
                          title: Text(
                            'Hey, you are next to a blue offer!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                          subtitle: Text(
                              "Tap and take a look :) !", style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          )),
                          trailing: IconButton(
                            tooltip: "Close",
                            icon: Icon(
                                Icons.not_interested, size: 32, color: Provider
                                .of<ThemeModel>(context, listen: false)
                                .mode == ThemeMode.dark
                                ? Colors.tealAccent
                                : Theme
                                .of(context)
                                .primaryColor),
                            onPressed: () {
                              print(zonas);
                              zonas.remove(zonas[i]);
                              Navigator.of(context).pushNamed(
                                  '/adsdemo', arguments: zonas);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Okey, we will not show you this ad again!",
                                      context));
                            },
                          ),
                        ),)),
                ),
              );
          }
            else
              //todo nos salimos de la demo porque ha inhabilitado bluetooth
              {

              return NoBluetooth();
               }
          }
             ),
          ),
      );
      //forzamos delay
      await Future.delayed(Duration(seconds: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return StreamBuilder(
              stream: zonademo(widget._zonas),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasError) {
                  return  ErrorContainer('Error: ${snapshot.error.toString()}');
                }
                //switch-case menu de casos
                switch (snapshot.connectionState) {
                //stream null
                  case ConnectionState.none:
                    return Center(child: ErrorContainer(
                        'An error occurred in the demo. Please try again'));
                //TODO waiting for data
                  case ConnectionState.waiting:
                    return WaitingDemo();
                  case ConnectionState.active:
                  //llegan datos
                  //TODO.
                    return snapshot.data;
                  case ConnectionState.done:
                    return EndDemo(widget._zonas);
                //se acaban los datos a enviar. se muestran todas las zonas
                }
                return null;
              },
            );
          } else {
              return NoBluetooth();
          }
        }
    );
  }
}



class NoBluetooth extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
    Widget build(BuildContext context) {
    return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
        child:SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(_scaffoldKey, context),
            drawer: CustomDrawer(),
            body: Center(
               child: Padding(
                 padding: const EdgeInsets.all(30),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                        children: <Widget>
                      [
                          Center(
                          child: Text("Enable Bluetooth in your device to continue", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 30),
                          Center(
                          child: Lottie.asset('assets/12435-turn-on-bluetooth.json', width: 200, height: 100),
                          ),

                      ],),),),
                      floatingActionButton: CustomBackButton(),)
                      ),);
  }
}


class WaitingDemo extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen: false);
    return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
    child:SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(_scaffoldKey, context),
        drawer: CustomDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>
              [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Image.asset(
                              "assets/logo_store.png", width: 80),

                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child:  Text(
                            "myBlueStore",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                    ]
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Text("Blue ads demo loading...",
                        style: TextStyle(fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 30),
                 Center(
                    child:  CircularProgressIndicator(),
                ),

              ],),),),
      floatingActionButton: CustomBackButton(),)
          ),);
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
                      if (widget._zonas.isEmpty)
                        {

                          Navigator.of(context).pushNamed('/userhome');
                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("No more blue ads to show", context));

                        }
                      else {
                        widget._zonas.shuffle();
                        Navigator.of(context).pushNamed(
                            '/adsdemo', arguments: widget._zonas);
                      }
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

