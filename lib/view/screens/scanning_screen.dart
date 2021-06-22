import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
          body: SingleChildScrollView(
          child: StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (c, snapshot)
            {
              print(snapshot.data);
              //vacio
              if (snapshot.data.toString()=="[]")
                return Loading();
              if (!snapshot.hasData)
                return Loading();
              if (snapshot.hasError)
                return ErrorContainer("error");
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
             return Column(
            children: [Text(snapshot.data.toString())],
                );
            }
            }
            ),
            ),
            //TODO STREAMBUILDER CON RESULTADO GETMAXRSSI. parar o no parar? si le da click stopscan

            /*)StreamBuilder<BlueAd>(
              stream: db.getBlueAd(def.device.id.id),
              builder: (context, AsyncSnapshot<BlueAd> snapshot) {
                if (snapshot.hasError) {
                  flutterblue.stopScan();
                  return ErrorScanning("Can't find this blue ad, please try again");
                }
                if (!snapshot.hasData) {
                  return Center(child: Loading());
                }
                return GestureDetector(
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
                                snapshot.data.url,
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
                      FlutterBlue.instance.stopScan();
                      //TODO NUEVA PAGINA PARA FAVS PORQUE NO HACE FALTA OTRO STREAMBUILDER. le pasamos el anuncio entero blueAd
                    }
                );
              }
          ),*/
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

