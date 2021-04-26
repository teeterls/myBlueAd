import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/firestore_path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'custom_backbutton.dart';
import 'error.dart';

//bbdd
import '../../services/firestore_db_beacons.dart' as db;
import 'loading.dart';

class Ad extends StatefulWidget {
  final String _option;

  Ad(this._option);
  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {
  @override
  Widget build(BuildContext context) {
    /*return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirestorePath.beaconscollection()).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) return new Text("no");
          return Scaffold(body:ListView(children: getBeacons(snapshot)));
        });
  }

  getBeacons(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.data()["zona"])))
        .toList();
        }*/
    return StreamBuilder<List<Baliza>>(
        stream: db.getBeacon(widget._option),
        builder: (context, AsyncSnapshot<List<Baliza>> snapshot) {
          //si tengo un error se muestra en el widget aparte
          if (snapshot.hasError) {
            return Error(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return Center(child: Loading());
          }
          //hay datos del perfil del usuario identificado con el uid al sign in/register
          //
          return SafeArea(child: Scaffold(
              body: ShowBeacon(snapshot.data),
              floatingActionButton: CustomBackButton()));
        }
    );
  }
}

class ShowBeacon extends StatefulWidget {
  List<Baliza> _be;
  ShowBeacon(this._be);
  @override
  _ShowBeaconState createState() => _ShowBeaconState();
}

class _ShowBeaconState extends State<ShowBeacon> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget> [
          Container(
            height: 600,
            child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget._be.first.url,
        ),
          ), Text("hola")],
    );
  }
}

