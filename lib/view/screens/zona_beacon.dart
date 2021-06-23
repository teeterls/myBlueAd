import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
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


//todo show bluead, recibe el bluead entero.
class ShowBlueAd extends StatefulWidget {
  ShowBlueAd(this._bluead);
  final BlueAd _bluead;

  @override
  _ShowBlueAdState createState() => _ShowBlueAdState();
}

class _ShowBlueAdState extends State<ShowBlueAd> {
//metodo de asset a file
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    File file =  File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
  _addFavAd(String uid, String url, String zona) async
  {
    //ya es favad
    if (await dbuser.isFavAd(uid, zona))
    {
    _btnControllerAd.success();
    ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar("Already a fav!", context));

    }
    //forzar lista para firestore, lo añade modo array.
    else if (await dbuser.setFavAd(uid, zona, url))
    {
      /*if (zona=="jewelry") {
        print ("aqui");
        File image = await getImageFileFromAssets('${zona}.jpg');
        await storage.uploadBeaconImage(image, zona);
        String url = await storage.downloadBeaconImage(zona);
        print(url);
      }*/

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

  final RoundedLoadingButtonController _btnControllerAd = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerDelete = RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WebViewController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    final uid= Provider.of<UserState>(context, listen: false).user.uid;
     return WillPopScope(
      //no deja ir para atras
        onWillPop: () async => false,
        child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                appBar: CustomAppBar(_scaffoldKey, context),
                drawer: CustomDrawer(),
                body:   SingleChildScrollView(
                              //todoSHOWBLUEAD
                              child:
                              Column(
                            children: <Widget>[
                            Container(
                              height: 500,
                              child:
                              WebView(
                              allowsInlineMediaPlayback: true,
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: widget._bluead.url,
                              gestureNavigationEnabled: true,
                              debuggingEnabled: true,
                              onWebViewCreated: (WebViewController webViewController) {
                                _controller = webViewController;
                              },
                              //avisar al controller
                            ),
                          ),

                        ],
            )),
                floatingActionButton: GoBack(),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                bottomNavigationBar:  (Provider.of<UserState>(context, listen: false).user.email!=null) ? Container(
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
                            _addFavAd(uid, widget._bluead.url, widget._bluead.zona);
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
                          onPressed: () async
                          {
                            if (await dbuser.isFavAd(uid, widget._bluead.zona))
                            {
                              dbuser.removeFavAd(uid, widget._bluead.zona);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar("The ${widget._bluead.zona} ad has been removed from your favs!", context));
                            }
                            else if (! (await dbuser.isFavAd(uid, widget._bluead.zona)))
                            {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar("Your preferences about ${widget._bluead.zona} section have been saved! ", context));
                            }
                            //se pone el boton a clear
                            _btnControllerDelete.error();

                          },
                        ),
                      ),
                    ],
                  ),
                ) : null,
            )));
  }
}

class Ad extends StatefulWidget {

  final String _option;

  Ad(this._option);
  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {


  final RoundedLoadingButtonController _btnControllerAd = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerDelete = RoundedLoadingButtonController();

  //metodo de asset a file
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
      File file =  File('${(await getTemporaryDirectory()).path}/$path');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
  }
  //le pasan zona y  url
  _addFavAd(String uid, String zona, String adurl, String idbeacon) async {
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

      //TODO PASAR DE ASSET A FILE
     File image = await getImageFileFromAssets('${zona}.jpg');
      //print(image.path);
      //TODO PRIMERO AÑADE LA FOTO AL STORAGE
    await storage.uploadBeaconImage(image, zona);
      String url = await storage.downloadBeaconImage(zona);
      //print(url);
          //DESPUES AÑADE LA FOTO A LA BBDD
       await db.setBeaconURL(idbeacon, url);
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
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<Baliza>(
            stream: db.getBeacon(widget._option),
            builder: (context, AsyncSnapshot<Baliza> snapshot) {
              //si tengo un error se muestra en el widget aparte
              if (snapshot.hasError) {
                return Error(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }
              //hay datos del perfil del usuario identificado con el uid al sign in/register
              if (Provider.of<UserState>(context, listen: false).user.email!=null)
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
                            floatingActionButton: CustomFavBackButton(),
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
                                            .uid, snapshot.data.zona,snapshot.data.url, snapshot.data.uid);
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
                                      onPressed: () async
                                      {
                                        if (await dbuser.isFavAd(Provider
                                            .of<UserState>(context, listen: false)
                                            .user
                                            .uid, widget._option))
                                        {
                                          dbuser.removeFavAd(Provider
                                              .of<UserState>(context, listen: false)
                                              .user
                                              .uid, widget._option);
                                          Navigator.of(context).pushNamed('/userhome');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              CustomSnackBar("The ${widget._option} ad has been removed from your favs!", context));

                                        }
                                        else if (! (await dbuser.isFavAd(Provider
                                            .of<UserState>(context, listen: false)
                                            .user
                                            .uid, widget._option)))
                                        {
                                          Navigator.of(context).pushNamed('/userhome');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              CustomSnackBar("Your preferences about ${widget._option} section have been saved! ", context));

                                        }
                                        //se pone el boton a clear
                                        _btnControllerDelete.error();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )));
              //usuario anonimo o phone. no hay perfil creado.
              else
                return WillPopScope(
                  //no deja ir para atras
                    onWillPop: () async => false,
                    child: SafeArea(
                        child: Scaffold(
                            key: _scaffoldKey,
                            appBar: CustomAppBar(_scaffoldKey, context),
                            drawer: CustomDrawer(),
                            body:   SingleChildScrollView(
                                child: ShowBeacon(snapshot.data)),
                            floatingActionButton: CustomFavBackButton())));
            }
        );

  }
}
//show beacon, despues de activar bluetooth y cuando es favorito. recibe baliza
class ShowBeacon extends StatefulWidget {

  Baliza _beacon;
  ShowBeacon(this._beacon);
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
             WebView(
               allowsInlineMediaPlayback: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget._beacon.url,
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

//pagina showfavbeacon. childshowbeacon. recibe baliza
class ShowFavBeacon extends StatefulWidget {
  ShowFavBeacon(this._beacon);
  Baliza _beacon;
  @override
  _ShowFavBeaconState createState() => _ShowFavBeaconState();
}

class _ShowFavBeaconState extends State<ShowFavBeacon>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnControllerDelete = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return  OrientationBuilder(
        builder: (context, orientation) {
      return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
    child: SafeArea(
    child: Scaffold(
    key: _scaffoldKey,
    appBar: CustomAppBar(_scaffoldKey, context),
    drawer: CustomDrawer(),
    body:   SingleChildScrollView(
      child: ShowBeacon(widget._beacon)),
    floatingActionButton: CustomFavBackButton(),
      bottomNavigationBar:  ButtonBar(
          mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: orientation == Orientation.portrait ?  const EdgeInsets.only(bottom: 24.0) : const EdgeInsets.only(bottom:1.0),
                child: Container(
                  width:50,
                  child: RoundedLoadingButton(
                  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue: Theme.of(context).primaryColor,
                  width:80,
                  child: Icon(Icons.thumb_down_alt,color: Colors.white,),
                  controller: _btnControllerDelete,
                  onPressed: () async
                  {

                      dbuser.removeFavAd(Provider
                          .of<UserState>(context, listen: false)
                          .user
                          .uid, widget._beacon.zona);
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar("The ${widget._beacon.zona} ad has been removed from your favs!", context));
                    //se pone el boton a clear
                    _btnControllerDelete.error();
                    Navigator.of(context).pop();
                  },
                ),),
              ),
              ],
        ),)
      ),);
  }
    );
  }
}

class GoBack extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      child: Icon(Platform.isIOS ? Icons.arrow_back_ios: Icons.arrow_back, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
      hoverColor: Colors.blue,
      splashColor: Colors.blue,
      backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.white: Colors.white54,
    );
  }
}


