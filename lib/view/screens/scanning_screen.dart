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
   BlueAd blueadshow;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Start scanning
    //FlutterBlue flutterBlue= FlutterBlue.instance;
    //flutterBlue.startScan();

// Listen to scan results
  /*flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });*/

// Stop scanning
    //FlutterBlue.instance.stopScan();
    // PROVIDER BLUADS, recuperamos los blueads
    final List<BlueAd> blueads = Provider.of<List<BlueAd>>(context);
    List <String> macs=[];
    List <String> bluemacs=[];
   
    //BlueAd blueadshow;
    String maxmac=null;
    blueads.forEach((bluead) {
      macs.add(bluead.uid);
    });

    //devuelve el bluead que coincide, si son mas de uno(en este caso como maximo 2 calcula getmaxrssi
    BlueAd macBlueAd(List<ScanResult> results) {
      List<String> bluemacs=[];
      print(bluemacs);
      for (ScanResult r in results) {
        if (macs.contains(r.device.id.id))
        {
          if (!bluemacs.contains(r.device.id.id))
            bluemacs.add(r.device.id.id);
        }
      }
      //print(bluemacs);
      return blueads.firstWhere((bluead) => bluead.uid==bluemacs[0],  orElse: () => null);
      /*if (macs.contains(result.device.id.id)) {
        return blueads.firstWhere((bluead) => bluead.uid==result.device.id.id,  orElse: () => null);
      }
      else
        return null;*/
    }
      //ninguno
      /*if (blueres.length<1)
        return null;
      //uno, se devuelve ese
      if (blueres.length==1)
        return blueads.firstWhere((bluead) => bluead.uid==blueres[0].device.id.id,  orElse: () => null);

      else
        {
          print(getmaxrssi(blueres));
          return blueads.firstWhere((bluead) => bluead.uid==getmaxrssi(blueres),  orElse: () => null);
        }

    }*/

    //else
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
                //flutterblue.stopScan();
                if (!snapshot.hasData)
                  //waiting
                  return ScanLoading();
                if (snapshot.hasError)
                  return ErrorScanning("An error ocurred while scanning, please try again");
                else {
                  snapshot.data.forEach((r) {
                    print('${r.device.name} found! rssi: ${r.rssi} mac: ${r.device.id.id}');
                    if (macs.contains(r.device.id.id)) {
                      if (!bluemacs.contains(r.device.id.id))
                        bluemacs.add(r.device.id.id);
                      if (bluemacs.length>1) {
                        maxmac = getmaxrssi(snapshot.data);
                        print("Mac in bbdd with max rssi:"+ maxmac);
                      }
                      else {
                        maxmac = bluemacs[0];
                        print("Mac in bbdd:"+ maxmac);
                      }
                    }
                    else
                      print("Mac not in bbdd" + r.device.id.id);
                  });
                  print("Total macs in bbdd:" + macs.toString());
                  print("Total macs in bbdd founded:"+ bluemacs.toString());
                  if (maxmac!=null) {
                    blueadshow = blueads.firstWhere((bluead) =>
                    bluead.uid ==
                        maxmac, orElse: () => null);
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



                 /* if (bluemacs.isEmpty)
                    return Text("null");
                  else
                  {


                    print(getmaxrssi(res));
                    blueadshow= blueads.firstWhere((bluead) => bluead.uid==getmaxrssi(res),  orElse: () => null);
                    return Text(blueadshow.zona);
                  }*/
                  //return Text(snapshot.data.toString());
                //}
                /*else
                  {
                    print(snapshot.data);
                      snapshot.data.forEach((r) {
                        print(r.device.id.id);
                        if (macs.contains(r.device.id.id)) {
                          if (!bluemacs.contains(r.device.id.id))
                            bluemacs.add(r.device.id.id);
                          res.add(r);
                        }
                      });
                      print(bluemacs);
                      blueads.forEach((element) {print(element.zona);});
                      if (bluemacs.length==1) {
                        blueadshow = blueads.firstWhere((bluead) => bluead.uid ==
                            bluemacs[0], orElse: () => null);
                        return Text(blueadshow.zona);
                      }
                      if (bluemacs.isEmpty)
                        return Text("null");
                      else
                      {
                        print(getmaxrssi(res));
                        blueadshow= blueads.firstWhere((bluead) => bluead.uid==getmaxrssi(res),  orElse: () => null);
                      return Text(blueadshow.zona);
                      }



                    //return Text(snapshot.data.toString());

                    //no es el de la bbdd

                      //return ErrorScanning("An error ocurred while scanning, please try again");
                   // else
                      /*return   Center(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 70),
                                child: DelayedDisplay(
                                  delay: initialDelay,
                                  child: Text("You are in ${b.zona} section.", textAlign: TextAlign.start,style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top:10, bottom:25.0),
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
                                  Navigator.of(context).pushNamed('/blueads', arguments: b);
                                },
                                onDoubleTap: ()
                                {
                                  flutterblue.stopScan();
                                  Navigator.of(context).pushNamed('/blueads', arguments: b);
                                },
                                onLongPress: ()
                                {
                                  flutterblue.stopScan();
                                  Navigator.of(context).pushNamed('/blueads', arguments: b);
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
                                        image: NetworkImage(b.image),
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
                                           b.zona[0].toUpperCase()+b.zona.substring(1),
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
                                            ScaffoldMessenger.of(context).blueadshowSnackBar(CustomSnackBar("New blue ads will appear next time you scan :)", context));
                                          },
                                        ),
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
                      );*/
                    //print("max"+getmaxrssi(snapshot.data));
                    /*if (getmaxrssi(snapshot.data)==null)
                      return Loading();
                    else
                   Future.delayed(Duration(seconds:4)).then((value)
                        {
                          FlutterBlue.instance.stopScan();
                          print(getmaxrssi(snapshot.data));
                        });*/

                    /*return  StreamBuilder<BlueAd>(
                stream: db.getBlueAd(getmaxrssi(snapshot.data)),
                builder: (context, AsyncSnapshot<BlueAd> snapshot) {
                  /*if (snapshot.hasError) {
                    flutterblue.stopScan();
                    return ErrorScanning("Can't find this blue ad, please try again");
                  }*/
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
                                          ScaffoldMessenger.of(context).blueadshowSnackBar(CustomSnackBar("New blue ads will appear next time you scan :)", context));
                                        },
                                      ),
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
                  );
                    }
                  );*/

              }*/
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

