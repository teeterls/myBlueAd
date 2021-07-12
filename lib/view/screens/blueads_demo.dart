import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'dart:async';

import 'package:myBlueAd/services/firestore_db_retailstores.dart' as db;
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_appbar.dart';
import 'package:myBlueAd/view/widgets/custom_backbutton.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'package:myBlueAd/view/widgets/error.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlueAdsDemo extends StatefulWidget {

  @override
  _BlueAdsDemoState createState() => _BlueAdsDemoState();
}

class _BlueAdsDemoState extends State<BlueAdsDemo> {
  Stream<Widget> demo (List<BlueAd> bluead) async*
  {

    //random
    bluead.shuffle();
    //forzar delay
    await Future.delayed(Duration(seconds: 3));
    for (int i=0; i<bluead.length; i++)
    {
      yield WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
        child:SafeArea(
          child: Scaffold(
            body: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<BluetoothState>(
                  stream: FlutterBlue.instance.state,
                  initialData: BluetoothState.unknown,
                  builder: (c, snapshot) {
                    final state = snapshot.data;
                    if (state == BluetoothState.on) {
                      return GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("This is only a demo, go back and start searching for nearby blueads! :)", context));
                          //Navigator.of(context).pushNamed('/viewblueads', arguments: bluead[i]);
                        },
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("This is only a demo, go back and start searching for nearby blueads! :)", context));
                          //Navigator.of(context).pushNamed('/viewblueads', arguments: bluead[i]);
                        },
                        onDoubleTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("This is only a demo, go back and start searching for nearby blueads! :)", context));
                          //Navigator.of(context).pushNamed('/viewblueads', arguments: bluead[i]);
                        },
                        child: Card(
                          child: Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/${bluead[i].zona}_demo.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                color: Colors.black.withOpacity(0.35),
                                child: ListTile(
                                  title: Text(
                                    'Hey, you are in ${bluead[i].zona} section!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                  subtitle: Text(
                                      "Continue walking...", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14
                                  )),
                                  trailing: IconButton(
                                    tooltip: "Close",
                                    icon: Icon(
                                        Icons.stop, size: 32, color: Provider
                                        .of<ThemeModel>(context, listen: false)
                                        .mode == ThemeMode.dark
                                        ? Colors.tealAccent
                                        : Theme
                                        .of(context)
                                        .primaryColor),
                                    onPressed: () {
                                      //vuelveatras
                                      Navigator.of(context).pushNamed(
                                          '/userhome');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          CustomSnackBar(
                                              "Demo stopped!",
                                              context));
                                    },
                                  ),
                                ),)),
                        ),
                      );
                    }
                    else
                        {
                      return NoBluetooth();
                    }
                  }
              ),
            ),
          ),
        ),
      );
      //forzamos delay
      await Future.delayed(Duration(seconds: 15));
    }
  }
  @override
  Widget build(BuildContext context) {
    final List<BlueAd> blueads = Provider.of<List<BlueAd>>(context);
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          //bluetooth on
          if (state == BluetoothState.on) {
            return StreamBuilder(
                      stream: demo(blueads),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.hasError) {
                          return  Center(
                              child: ErrorContainer(
                                  'An error occurred in the demo. Please try again'));
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
                            return snapshot.data;
                          case ConnectionState.done:
                            return EndBlueDemo(blueads);
                        //se acaban los datos a enviar. se muestran todas las zonas
                        }
                        return null;
                      },
                    );

            //bluetooth off
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

class EndBlueDemo extends StatefulWidget {
    EndBlueDemo(this._blueads);
  final List <BlueAd> _blueads;

  @override
  _EndBlueDemoState createState() => _EndBlueDemoState();
}

class _EndBlueDemoState extends State<EndBlueDemo> {
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
                                    if (widget._blueads.isEmpty)
                                    {

                                      Navigator.of(context).pushNamed('/userhome');
                                      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("No more blue ads to show", context));

                                    }
                                    else {
                                      widget._blueads.shuffle();
                                      Navigator.of(context).pushNamed(
                                          '/blueadsdemo', arguments: widget._blueads);
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



