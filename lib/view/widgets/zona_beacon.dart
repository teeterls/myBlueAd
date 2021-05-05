import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/view/widgets/custom_appbar.dart';
import 'package:myBlueAd/view/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'custom_backbutton.dart';
import 'error.dart';
import 'package:animated_button/animated_button.dart';
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
  final RoundedLoadingButtonController _btnControllerAd = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerDelete = RoundedLoadingButtonController();

  //TODO CAMBIAR A METODOS DONDE SE GUARDEM LOS FAVADS REALMENTE
  //TODO FUTURE CONTROL VIEWER en controller paa los botones
  void _addFavAd() async {
    Timer(Duration(seconds: 3), () {
      _btnControllerAd.success();
    });
  }
  void _deleteAd() async {
    Timer(Duration(seconds: 3), () {
      _btnControllerDelete.error();
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
          //todo cambiar con botonbar
          return WillPopScope(
            //no deja ir para atras
              onWillPop: () async => false,
              child: SafeArea(
                  child: Scaffold(
                      key: _scaffoldKey,
                      appBar: CustomAppBar(_scaffoldKey, context),
                      drawer: CustomDrawer(),
                      body:   SingleChildScrollView(child: ShowBeacon(snapshot.data)),
              floatingActionButton: CustomBackButton(),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    bottomNavigationBar: Container(
                      height:60,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:5.0),
                            child: RoundedLoadingButton(
                              color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue: Theme.of(context).primaryColor,
                             successColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue:Theme.of(context).primaryColor,
                              width:80,
                              child: Icon(Icons.favorite, color: Colors.white,),
                              controller: _btnControllerAd,
                              onPressed: _addFavAd,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:5.0),
                            child: RoundedLoadingButton(
                              color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue: Theme.of(context).primaryColor,
                              width:80,
                              child: Icon(Icons.delete, color: Colors.white,),
                              controller: _btnControllerDelete,
                              onPressed: _deleteAd,
                            ),
                          ),
                        ],
                      ),
                    )
                    )));
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
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    print(widget._be.first.url);
   // var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return  Column(
          children: <Widget>[
            Container(
              height: 500,
              child:
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget._be.first.url,
                //gestureNavigationEnabled: true,
                //avisar al controller
            ),
            ), /*Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RoundedLoadingButton(
                    width:80,
                    child: Text('Tap me!', style: TextStyle(color: Colors.white)),
                    controller: _btnControllerAd,
                    onPressed: _addFavAd,
                  ),
                  RoundedLoadingButton(
                    width:80,
                    child: Text('Tap me!', style: TextStyle(color: Colors.white)),
                    controller: _btnControllerDelete,
                    onPressed: _deleteAd,
                  )
                ],
              ), *//*Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GradientButton(
                    //registrarse
                    child: Icon(Icons.favorite),
                    callback: () {
                      Navigator.of(context).pushNamed('/signlogin', arguments: "Log in");
                    },
                    gradient: Gradients.jShine,
                    shadowColor: Gradients.jShine.colors.last.withOpacity(
                        0.25),

                  ),
                  SizedBox(width: 10,),
                  GradientButton(
                    //entrar
                    child: Text('Sign in'),
                    callback: () {
                      Navigator.of(context).pushNamed('/signlogin', arguments: "Sign in");
                    },
                    gradient: Gradients.hotLinear,
                    shadowColor: Gradients.hotLinear.colors.last
                        .withOpacity(0.25),
                  ),
                ],
              ),*/
            //Text(widget._be.first.zona)],
        ],
    );
  }



}

