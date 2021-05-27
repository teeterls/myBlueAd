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
import 'custom_backbutton.dart';
import 'error.dart';
//bbdd
import '../../services/firestore_db_beacons.dart' as db;
import '../../services/firestore_db_user.dart' as dbuser;
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

  //le pasan urly url
  _addFavAd(String uid, String zona, String adurl) async {
    //ya es favad
    if (await dbuser.isFavAd(Provider
        .of<UserState>(context, listen: false)
        .user
        .uid, widget._option))
      {
          _btnControllerAd.success();
          ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar("Already a fav!", context));

      }
    //forzar lista para firestore, lo añade modo array.
    else if (await dbuser.setFavAd(uid, zona, adurl))
    {

      _btnControllerAd.success();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar("Added to your favs!", context));
  }
      else {
      _btnControllerAd.error();
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar("An error ocurred. Try again", context));
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _visible=true;
  @override
  Widget build(BuildContext context) {

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
          return WillPopScope(
            //no deja ir para atras
              onWillPop: () async => false,
              child: SafeArea(
                  child: Scaffold(
                      key: _scaffoldKey,
                      appBar: CustomAppBar(_scaffoldKey, context),
                      drawer: CustomDrawer(),
                      body:   SingleChildScrollView(/*child: Visibility(
                              visible: _visible,
                              */child: ShowBeacon(snapshot.data)),
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
                             successColor: Colors.green,
                              disabledColor: Colors.blue,
                              width:80,
                              child: Icon(Icons.thumb_up_alt, color: Colors.white,),
                              controller: _btnControllerAd,
                              onPressed: () async {
                                _addFavAd(Provider
                                    .of<UserState>(context, listen: false)
                                    .user
                                    .uid, snapshot.data.first.zona,snapshot.data.first.url);
                              },//
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: RoundedLoadingButton(
          color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue: Theme.of(context).primaryColor,
          width:80,
          child: Icon(Icons.thumb_down_alt,color: Colors.white,),
          controller: _btnControllerDelete,
          onPressed: ()
            {
              Navigator.of(context).pop(widget._option);
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Your preferences have been saved!", context));
            },
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
  WebViewController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    //print(widget._be.first.url);
    return  Column(
          children: <Widget>[
            Container(
              height: 500,
              child:
                  //TODO WEBVIEW MAS COMPLETO.
             WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget._be.first.url,
                  gestureNavigationEnabled: true,
                  debuggingEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                  },
                  //avisar al controller
            ),
              ),

        ],
    );
  }



}

