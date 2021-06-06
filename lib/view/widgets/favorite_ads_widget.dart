import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/firestore_db_user.dart' as dbuser;
import 'package:myBlueAd/services/firestore_db_beacons.dart' as db;
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:myBlueAd/view/widgets/error.dart';
import 'package:http/http.dart';
import 'custom_snackbar.dart';
import 'loading.dart';
//tiene o no lista de favoritos? -> bbdd
//card con foto de fondo nombre y el corazon
//CARDS
//streambuilder  fav ads dentro del usuario.
class FavoriteAds extends StatefulWidget {
  @override
  _FavoriteAdsState createState() => _FavoriteAdsState();
}

class _FavoriteAdsState extends State<FavoriteAds> {
  @override
  Widget build(BuildContext context) {
    //db.getFavBeacons(["jewelry", "welcome", "shoes"]);
    //userstate Auth Provider
    final userstate = Provider.of<UserState>(context, listen: false);
    //print(userstate.user.uid);
    //print(db.getUserProfile(userstate.user.uid));
    if (userstate!=null)
      return StreamBuilder<Usuario>(
          stream: dbuser.getUserProfile(userstate.user.uid),
          builder: (context, AsyncSnapshot<Usuario> snapshot) {
            //si tengo un error se muestra en el widget aparte
            if (snapshot.hasError) {
              return Error(snapshot.error.toString());
            }
            //waiting
            if (!snapshot.hasData) {
              return Center(child: Loading());
            }
            //hay datos del perfil del usuario identificado con el uid al sign in/register
            //snapshot.data.favads.key zona -> lookup image db nuevo STREAMBUILDER
            //snapshot.data.favads.values url -> esto se utiliza asi
            //TODO STREAMBUILDER BEACON Y METODO OBTENER IMAGENES de la retail store con storage
            if (snapshot.data.favads.isNotEmpty)  {
              print(snapshot.data.favads.toString());
              return ShowFavBeacon(
                  List<String>.from(snapshot.data.favads.keys.toList()));
            }
          else
            return NoAdsYet();
          });
  }
}
class ShowFavBeacon extends StatefulWidget {
  //recibe las url y las zonas en mapa
  List  <String> _favbeacons;
  ShowFavBeacon(this._favbeacons);
  @override
  _ShowFavBeaconState createState() => _ShowFavBeaconState();
}

class _ShowFavBeaconState extends State<ShowFavBeacon> {
  //todo streambuilder de favicons
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <List<Baliza>>(
        stream: db.getFavBeacons(widget._favbeacons),
        builder: (context, AsyncSnapshot<List<Baliza>> snapshot) {
          //si tengo un error se muestra en el widget aparte
          if (snapshot.hasError) {
            return Error(snapshot.error.toString());
          }
          //waiting
          if (!snapshot.hasData) {
            return Center(child: Loading());
          }
          //hay datos del perfil del usuario identificado con el uid al sign in/register
          //snapshot.data.favads.key zona -> lookup image db nuevo STREAMBUILDER
          //snapshot.data.favads.values url -> esto se utiliza asi
          //TODO STREAMBUILDER BEACON Y METODO OBTENER IMAGENES de la retail store con storage
          return  FavBeaconList(snapshot.data);
        });
  }
}

class FavBeaconList extends StatelessWidget {
  final List<Baliza> _favs;
  FavBeaconList(this._favs);
  @override
  Widget build(BuildContext context) {
    //builder favs
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:16.0, right:16.0, top:16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Padding(
                 padding: const EdgeInsets.only(top:9.0),
                 child: Text("Your fav ads", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
                    ),),
               ),
                IconButton(
                  tooltip: "Delete all favs",
                    icon: Icon(Icons.delete_forever, size:26, color:Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
                    onPressed: ()
                    {
                        _showRemoveFavsDialog(context);
                    },
                  ),
              ]),
        ),
        Container(
                height: _favs.length*250.toDouble(),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    //scrollDirection: Axis.vertical,
                      itemCount: _favs.length,
                      itemBuilder: (context, index)
                      {
                        Baliza beacon = _favs[index];
                        //cada index es una baliza
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15,20,15,0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Card(
                              child: Container(
                                width: orientation == Orientation.portrait ? double.infinity : 150,
                                height: 220,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(beacon.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  color: Colors.black.withOpacity(0.35),
                                  child: ListTile(
                                    title: Text(
                                      beacon.zona[0].toUpperCase()+beacon.zona.substring(1),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize:16
                                        ),
                                    ),
                                    trailing: IconButton(
                                      tooltip: "Delete fav",
                                      icon: Icon(Icons.favorite, size: 32,color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
                                      onPressed: ()
                                      {
                                        dbuser.removeFavAd(Provider.of<UserState>(context, listen: false).user.uid, beacon.zona);
                                        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Fav ad deleted succesfully!", context));
                                      },
                                    ),

                                  )
                                ),
                              ),
                            ),
                          ),
                        );
                      }); }
                ),

        ),
      ],
    );
  }
  Future _showRemoveFavsDialog(BuildContext context) async {
    if (Platform.isAndroid)
    {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context),
      );

    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context),
      );
    }
  }

  Widget _buildAndroidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text( 'Do you want to delete all?', overflow: TextOverflow.ellipsis, style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor, fontSize: 20),maxLines: 2,),
          ]
      ),
      content:
      Text("Remember that all your fav ads will be permanently deleted."),
      actions: [
        TextButton.icon(
          onPressed: () async {
            dbuser.deleteFavAds(Provider.of<UserState>(context, listen: false).user.uid);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("All your fav ads were deleted!", context));
            //vuelta a pagina
            Navigator.of(context).pop();
          },
          onLongPress: () async {
            dbuser.deleteFavAds(Provider.of<UserState>(context, listen: false).user.uid);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("All your fav ads were deleted!", context));
            //vuelta a pagina
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.check, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Yes", style: TextStyle(
            color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
          )),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
          icon:Icon(Icons.cancel_outlined, color: Colors.red),
          label: Text("No", style: TextStyle(
              color: Colors.red
          )),
        ),
      ],
    );
  }

  Widget _buildiOSAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text( 'Do you want to delete all?', overflow: TextOverflow.ellipsis, style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor, fontSize: 20),maxLines: 2,),
          ]
      ),
      content:
      Text("Remember that all your fav ads will be permanently deleted."),
      actions: [
        TextButton.icon(
          onPressed: () async {
            dbuser.deleteFavAds(Provider.of<UserState>(context, listen: false).user.uid);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("All your fav ads were deleted!", context));
            //vuelta a pagina
            Navigator.of(context).pop();
          },
          onLongPress: () async {
            dbuser.deleteFavAds(Provider.of<UserState>(context, listen: false).user.uid);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("All your fav ads were deleted!", context));
            //vuelta a pagina
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.check, color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent),
          label: Text("Yes", style: TextStyle(
            color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Colors.blueAccent,
          )),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
          icon:Icon(Icons.cancel_outlined, color: Colors.red),
          label: Text("No", style: TextStyle(
              color: Colors.red
          )),
        ),
      ],
    );
  }
}

//clase que todavia no tiene anuncios.
class NoAdsYet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top:150, bottom: 200),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>
    [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
        child: Icon(Icons.favorite_outline_outlined, size: 50, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.grey[600] : Colors.grey[700]),
      ),
      SizedBox(height:20),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text("You have no fav ads yet", style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.grey[600] : Colors.grey[700],
              ),),
            ),
          ]),
     ],
    ));

  }
}





