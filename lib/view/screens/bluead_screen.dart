import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
                floatingActionButton: StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
    initialData: BluetoothState.unknown,
    builder: (c, snapshot) {
    final state = snapshot.data;
    if (state == BluetoothState.on) {
    return GoBack(true);
    }else
      return GoBack(false);
    }),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    bottomNavigationBar: Provider.of<UserState>(context, listen: false).user.email!=null ?
    Container(
    height:60,
    child: ButtonBar(
    alignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.only(bottom:5.0),
    child: RoundedLoadingButton(
    color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.lightBlue: Theme.
    of(context).primaryColor,
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
                ) : Container(height:0, width:0)
            )));
  }
}


class GoBack extends StatelessWidget {
  GoBack(this._enabled);
  final bool _enabled;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_enabled)
          FlutterBlue.instance.startScan(allowDuplicates: true);
        Navigator.of(context).pop();
      },
      tooltip: "Go back",
      child: Icon(
        Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        color: Provider
            .of<ThemeModel>(context, listen: false)
            .mode == ThemeMode.dark ? Colors.teal : Theme
            .of(context)
            .primaryColor,),
      hoverColor: Colors.blue,
      splashColor: Colors.blue,
      backgroundColor: Provider
          .of<ThemeModel>(context, listen: false)
          .mode == ThemeMode.dark ? Colors.white : Colors.white54,
    );
    /*return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return FloatingActionButton(
              onPressed: () {
                FlutterBlue.instance.startScan(allowDuplicates: true);
                Navigator.of(context).pop();
              },
              tooltip: "Go back",
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.teal : Theme
                    .of(context)
                    .primaryColor,),
              hoverColor: Colors.blue,
              splashColor: Colors.blue,
              backgroundColor: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.white : Colors.white54,
            );
          } else
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: "Go back",
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.teal : Theme
                    .of(context)
                    .primaryColor,),
              hoverColor: Colors.blue,
              splashColor: Colors.blue,
              backgroundColor: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.white : Colors.white54,
            );
        }
    );*/
  }
}
