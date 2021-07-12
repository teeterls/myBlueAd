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
import 'package:myBlueAd/services/firestore_db_retailstores.dart' as db;
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
  //BlueAd encontrado
   BlueAd blueadshow;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider, recuperamos los blueads de la base de datos en tiempo real
    final List<BlueAd> blueads = Provider.of<List<BlueAd>>(context);
    //macs BBDD
    List <String> dbmacs=[];
    //macs escaneadas
    List <String> scanmacs=[];
    //macs bbdd distintas a null
    List<String> macsnotnull=[];
   
   //mac coincidente
    String foundmac=null;
    //rellenar lista macs base de datos
    //rellenar lista macs not null base de datos
    blueads.forEach((bluead) {
      dbmacs.add(bluead.uid);
      if (bluead.uid!=null)
        macsnotnull.add(bluead.uid);
    });

    return WillPopScope(
      //no deja ir para atras
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: StreamBuilder<List<ScanResult>>(
              stream:FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot)
              {
                if (!snapshot.hasData)
                  //waiting
                  return ScanLoading();
                if (snapshot.hasError)
                  return ErrorScanning("An error ocurred while scanning, please try again");
                else {
                print("Scanning results:");
                //bucle para cada scanresult
                  snapshot.data.forEach((r) {
                    print('${r.device.name} found!, rssi: ${r.rssi}, mac: ${r.device.id.id}, advertising data: ${r.advertisementData}');
                    //coincidencia macs base de datos y Bluetooth MAC escaneada
                    if (dbmacs.contains(r.device.id.id)) {
                      //evitar que se repitan las macs coincidentes guardasas
                      if (!scanmacs.contains(r.device.id.id))
                        scanmacs.add(r.device.id.id);
                      if (scanmacs.length>1) {
                        //se han encontrado más de una coincidencia, se calcula la Bluetooth MAC con mayor rssi
                        foundmac = getmaxrssi(snapshot.data);
                        print("Mac in database with max rssi founded: "+ foundmac);
                      }
                      else {
                        //solo se encuentra una
                        foundmac = scanmacs[0];
                        print("Mac in database founded: "+ foundmac);
                      }
                    }
                    else
                      //no hay coincidencia
                      print("This mac is not in database: " + r.device.id.id);
                  });
                  print("Total macs in database: " + dbmacs.toString());
                  print("Total macs in database founded: "+ scanmacs.toString());
                  if (scanmacs.length==macsnotnull.length)
                    print("All macs in database founded!");
                  //mac escogida
                  if (foundmac!=null) {
                    //obtener blue
                    blueadshow = blueads.firstWhere((bluead) =>
                    bluead.uid ==
                        foundmac, orElse: () => null);
                  }
                  while(blueadshow==null)
                    return ScanLoading();
                    return   Center(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: DelayedDisplay(
                                delay: initialDelay,
                                child: Text("You are in ${blueadshow.zona} section.", textAlign: TextAlign.start,style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top:10, bottom:25.0),
                            child: DelayedDisplay(
                              delay: Duration(seconds:initialDelay.inSeconds + 1),
                              child: Text("Blue ad found for you!", textAlign: TextAlign.start, style: TextStyle(
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
                                print("Show BlueAd with ${blueadshow.uid} MAC");
                                Navigator.of(context).pushNamed('/blueads', arguments: blueadshow);
                              },
                              onDoubleTap: ()
                              {
                                flutterblue.stopScan();
                                Navigator.of(context).pushNamed('/blueads', arguments: blueadshow);
                              },
                              onLongPress: ()
                              {
                                flutterblue.stopScan();
                                Navigator.of(context).pushNamed('/blueads', arguments: blueadshow);
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
                                      image: NetworkImage(blueadshow.image),
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
                                        blueadshow.zona[0].toUpperCase()+blueadshow.zona.substring(1),
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
                                      /*trailing: IconButton(
                                        tooltip: "Discard blue ad",
                                        icon: Icon(Icons.not_interested, size: 32,color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
                                        onPressed: ()
                                        {
                                          flutterblue.stopScan();
                                         // Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("New blue ads will appear next time you scan :)", context));
                                        },
                                      ),*/
                                    ),),),),
                            ), ),
                          DelayedDisplay(
                            delay: Duration(seconds: initialDelay.inSeconds+2),
                            child: GestureDetector(
                              child: Lottie.asset('assets/28316-tap-tap.json', height: 140),
                              //movimientos mas comunes de un usuario. tenemos que hacer una nueva pantalla.
                              onTap: ()
                              {
                                flutterblue.stopScan();
                                Navigator.of(context).pushNamed('/blueads', arguments: snapshot.data);
                              },
                              onDoubleTap: ()
                              {
                                flutterblue.stopScan();
                                Navigator.of(context).pushNamed('/blueads', arguments: snapshot.data);
                              },
                              onLongPress: ()
                              {
                                flutterblue.stopScan();
                                Navigator.of(context).pushNamed('/blueads', arguments: snapshot.data);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
              } }
              ),),
            //dos streambuilders, 1º de si esta activado el bluetooth (por si lo quita en otro momento) y 2º si esta o no escaneando
            floatingActionButton: StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
                initialData: BluetoothState.unknown,
                builder:
                    (c, snapshot) {
                  final state = snapshot.data;
                  if (state == BluetoothState.on) {
                    if (blueadshow!=null) {
                      return ScanBackButton(FlutterBlue.instance, true);
                    }
                    else
                      return ScanBackButton(FlutterBlue.instance,true);
                  }
                  else {
                    if (blueadshow != null)
                      return ScanBackButton(FlutterBlue.instance, false);
                    else
                      return ScanBackButton(FlutterBlue.instance, false);
                  }
                }
            ),
        ),
      ),
    );
  }

  }
            /*
                  /*return StreamBuilder<bool>(
                    stream: FlutterBlue.instance.isScanning,
                    //initialData: false,
                    //boolean stream, se supone que al principio
                    builder: (c, snapshot) {
                      //esta scanning
                      if (snapshot.data) {
                        /*return Stack(
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
                        return ScanBackButton(FlutterBlue.instance,true);
                        /*return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(alignment: Alignment
                                  .bottomLeft, child: ScanBackButton(FlutterBlue.instance, true)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:ScanAgainButton(true)),
                          ],
                        );*/
                      }
                    },
                  );*/
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
          ),
      )));

  }}*/*/


//funcion que devuelva el id con el maximo rssi, el que esta más cerca.
String getmaxrssi(List <ScanResult> results) {
  List <int> _rssi = [];
  ScanResult def;
  for (ScanResult r in results) {
    _rssi.add(r.rssi);
    _rssi.reduce(max);
    if (r.rssi == _rssi.reduce(max))
      def = r;
  }
  return def.device.id.id;
}

String getminrssi(List <ScanResult> results) {
  List <int> _rssi = [];
  ScanResult def;
  for (ScanResult r in results) {
    _rssi.add(r.rssi);
    _rssi.reduce(max);
    if (r.rssi == _rssi.reduce(min))
      def = r;
  }
  return def.device.id.id;
}

