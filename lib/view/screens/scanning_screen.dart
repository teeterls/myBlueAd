import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/view/widgets/bluetooth_modes_buttons.dart';
import 'package:myBlueAd/view/widgets/custom_appbar.dart';
import 'package:myBlueAd/view/widgets/custom_backbutton.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:myBlueAd/services/firebase_db_retailstores.dart' as db;
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'dart:math';

import 'package:myBlueAd/view/widgets/error.dart';
import 'package:myBlueAd/view/widgets/loading.dart';
import 'package:provider/provider.dart';

//SCANNING SCREEN, en principio no le llega nada.
//STOP BOTTON

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  FlutterBlue flutterblue= FlutterBlue.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List <ScanResult> res=[];
  final Duration initialDelay = Duration(milliseconds: 500);

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List <int> _rssi = [];
    ScanResult def;
      //else
    return WillPopScope(
      //no deja ir para atras
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Center(
            child: SingleChildScrollView(
            child: StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot)
              {
                print(snapshot.data);
                //vacio
                if (snapshot.data.toString()=="[]")
                  return ScanLoading();
                if (!snapshot.hasData)
                  return ScanLoading();
                if (snapshot.hasError)
                  return ErrorScanning("An error ocurred while scanning, please try again");
                else
                  {
                    print("max"+getmaxrssi(snapshot.data));
                    /*if (getmaxrssi(snapshot.data)==null)
                      return Loading();
                    else
                   Future.delayed(Duration(seconds:4)).then((value)
                        {
                          FlutterBlue.instance.stopScan();
                          print(getmaxrssi(snapshot.data));
                        });*/
               return  StreamBuilder<BlueAd>(
                stream: db.getBlueAd(getmaxrssi(snapshot.data)),
                builder: (context, AsyncSnapshot<BlueAd> snapshot) {
                  if (snapshot.hasError) {
                    flutterblue.stopScan();
                    return ErrorScanning("Can't find this blue ad, please try again");
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Loading());
                  }
                  return   Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:10.0),
                        child: DelayedDisplay(
                        delay: initialDelay,
                        child: Text("You are in ${snapshot.data.zona} section.", textAlign: TextAlign.start,style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(bottom:25.0),
                        child: DelayedDisplay(
                        delay: Duration(seconds:initialDelay.inSeconds + 1),
                  child: Text("Blue ad founded for you!", textAlign: TextAlign.start, style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),),
                      ),),
                  DelayedDisplay(
                  delay: Duration(seconds:initialDelay.inSeconds + 2),
                  child: GestureDetector(
                              //movimientos mas comunes de un usuario. tenemos que hacer una nueva pantalla.
                              onTap: ()
                              {
                                flutterblue.stopScan();
                              },
                              onDoubleTap: ()
                              {
                                flutterblue.stopScan();
                              },
                              onLongPress: ()
                              {
                                flutterblue.stopScan();
                              },
                              child: AlertDialog(
                                elevation: 200,
                                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                contentPadding: EdgeInsets.zero,
                                content:Container(
                                  width: 320,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot.data.image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                 decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(20),),
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data.zona[0].toUpperCase()+snapshot.data.zona.substring(1),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize:16
                                        ),
                                      ),
                                      subtitle: Text("Tap and take a look :) !", style: TextStyle(
                                          color: Colors.white,
                                          fontSize:14
                                      )),
                                      trailing: IconButton(
                                        tooltip: "Discard blue ad",
                                        icon: Icon(Icons.not_interested, size: 32,color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
                                        onPressed: ()
                                        {
                                          flutterblue.stopScan();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("New blue ads will appear next time you scan :)", context));
                                        },
                                      ),
                                    ),),),),
                            ), ),
                      DelayedDisplay(
                        delay: Duration(seconds: initialDelay.inSeconds+2),
                        child: Lottie.asset('assets/28316-tap-tap.json', height: 140),
                      ),
                    ],
                  );
                    }
                  ); /*GestureDetector(

                child:  AlertDialog(
                      backgroundColor: Colors.green,
                      elevation: 30,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.zero,
                        content:
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(snapshot.data.image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),

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

                                     print("hola");
                                    },
                                  ),
                                ),)),
                        ),
//

                    ),
                onTap: () async   {
                    FlutterBlue.instance.stopScan();
                    //TODO NUEVA PAGINA PARA FAVS PORQUE NO HACE FALTA OTRO STREAMBUILDER. le pasamos el anuncio entero blueAd
                },
                  );*/

              }
              }
              ),
              ),
          ),


            //dos streambuilders, 1º de si esta activado el bluetooth (por si lo quita en otro momento) y 2º si esta o no escaneando
            floatingActionButton: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder:
             (c, snapshot) {
                final state = snapshot.data;
                if (state == BluetoothState.on) {
                  return StreamBuilder<bool>(
                    stream: FlutterBlue.instance.isScanning,
                    //initialData: false,
                    //boolean stream, se supone que al principio
                    builder: (c, snapshot) {
                      //esta scanning
                      if (snapshot.data) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(alignment: Alignment
                                  .bottomLeft, child: ScanBackButton(FlutterBlue.instance, true)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:StopButton(true)),
                          ],
                        );
                        //no esta scanning
                      }
                      else {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(alignment: Alignment
                                  .bottomLeft, child: ScanBackButton(FlutterBlue.instance, true)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:ScanAgainButton(true)),
                          ],
                        );
                      }
                    },
                  );
                }
                else
                  return StreamBuilder<bool>(
                    stream: FlutterBlue.instance.isScanning,
                    initialData: true,
                    //boolean stream, se supone que al principio
                    builder: (c, snapshot) {
                      //esta scanning
                      if (snapshot.data) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(alignment: Alignment
                                  .bottomLeft, child: ScanBackButton(FlutterBlue.instance, false)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:StopButton(false)),
                          ],
                        );
                        //no esta scanning
                      }
                      else {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(alignment: Alignment
                                  .bottomLeft, child: ScanBackButton(FlutterBlue.instance, false)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:ScanAgainButton(false)),
                          ],
                        );
                      }
                    },
                  );
              }
          ),),
      ),);

  }
}

