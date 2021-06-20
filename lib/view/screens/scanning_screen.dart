import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myBlueAd/view/widgets/bluetooth_modes_buttons.dart';
import 'package:myBlueAd/view/widgets/custom_appbar.dart';
import 'package:myBlueAd/view/widgets/custom_backbutton.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:myBlueAd/services/firebase_db_retailstores.dart' as db;
import 'dart:math';

//SCANNING SCREEN, en principio no le llega nada.
//STOP BOTTON

class ScanScreen extends StatefulWidget {

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterBlue flutterBlue = FlutterBlue.instance;

  //funcion que devuelva el id con el maximo rssi, el que esta más cerca.
  String _getmaxrssi(List <ScanResult> results) {
    List <int> _rssi = [];
    ScanResult def;
    if (results.isEmpty)
      return null;
    for (ScanResult r in results) {
      _rssi.add(r.rssi);
      _rssi.reduce(max);
      if (r.rssi== _rssi.reduce(max))
      def=r;
    }
    return def.device.id.id;
  }
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List <ScanResult> res=[];
    Future.delayed(Duration(seconds:0)).then((value)
    async  {
      flutterBlue.startScan(scanMode: ScanMode.lowPower);
      flutterBlue.scanResults.listen((results) {

        // do something with scan results
        for (ScanResult r in results) {
          print('${r.device.name} found! rssi: ${r.rssi} id ${r.device.id}');
        }
        print(_getmaxrssi(results));
        //db.setUID(_getmaxrssi(results));
        res=results;
      });
    });
    return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
      child: SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
       body: /*SingleChildScrollView(
      child: Center(
        child: Container(height:20, width:40, child: RaisedButton(child:Text("Stop"), onPressed: () => flutterBlue.stopScan(),))
      ),
    )*/ GestureDetector(
      //todo orientacion como card
    child: AlertDialog(
    title:
    Column(
    children: <Widget>[
    Container(
      height:20,
    child: Image.asset('assets/welcome.jpg'),
    ),
    const SizedBox(height: 15.0),
    Container(
    child: Text(
    'Verify',
    textAlign: TextAlign.center,
    style: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    ),
    ),
    )
    ],
    ),
    content:
    Text('You have successfully verified your mobile number',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black, fontSize: 15.0)),
//              gradient: LinearGradient(
//                colors: <Color>[
//                  Color(0xDD4a00e0),
//                  Color(0xFF8e2de2),
//                ],
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//              ),
    actions: <Widget>[]
    ),
    onTap: () async   {

      //con este value se hace streambuilder. falta otro navigator.
      //print(await db.nullUID());
      if (await db.nullUID())
        db.setUID(_getmaxrssi(res));
      else
        db.getBlueAd(_getmaxrssi(res)).then((value) => print( value.first.toString()));
      flutterBlue.stopScan();
    }
    ),
        //dos streambuilders, 1º de si esta activado el bluetooth (por si lo quita en otro momento) y 2º si esta o no escaneando
        floatingActionButton: StreamBuilder<BluetoothState>(
            stream: flutterBlue.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                    return StreamBuilder<bool>(
                    stream: flutterBlue.isScanning,
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
                                  .bottomLeft, child: ScanBackButton(flutterBlue, true)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:StopButton(flutterBlue, true)),
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
                                  .bottomLeft, child: ScanBackButton(flutterBlue, true)),
                            ),
                            Align(alignment: Alignment.bottomRight,
                                child:ScanAgainButton(flutterBlue, true)),
                          ],
                        );
                      }
                      },
                       );
                }
                else
                return StreamBuilder<bool>(
                stream: flutterBlue.isScanning,
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
                                .bottomLeft, child: ScanBackButton(flutterBlue, false)),
                          ),
                          Align(alignment: Alignment.bottomRight,
                              child:StopButton(flutterBlue, false)),
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
                                .bottomLeft, child: ScanBackButton(flutterBlue, false)),
                          ),
                          Align(alignment: Alignment.bottomRight,
                              child:ScanAgainButton(flutterBlue, false)),
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


