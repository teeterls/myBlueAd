import 'package:flutter/material.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/firestore_db_user.dart' as dbuser;
import 'package:myBlueAd/services/firestore_db_beacons.dart' as db;
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:myBlueAd/view/widgets/error.dart';

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
    //final userstate = Provider.of<UserState>(context, listen: false);
    //print(userstate.user.uid);
    //print(db.getUserProfile(userstate.user.uid));
    //f (userstate!=null)
      return StreamBuilder<Usuario>(
          stream: dbuser.getUserProfile(Provider.of<UserState>(context, listen: false).user.uid),
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
            return  Text("hola");//ShowFavBeacon(snapshot.data.favads.keys.toList());
          });
  }
}
/*class ShowFavBeacon extends StatefulWidget {
  //recibe las url y las zonas en mapa
  List  _favbeacons;
  ShowFavBeacon(this._favbeacons);
  @override
  _ShowFavBeaconState createState() => _ShowFavBeaconState();
}

class _ShowFavBeaconState extends State<ShowFavBeacon> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Baliza>>(
        stream: db.getFavBeacons(widget._favbeacons),
    builder: (context, AsyncSnapshot<List<Baliza>> snapshot) {
    //si tengo un error se muestra en el widget aparte
    if (snapshot.hasError) {
    return Error(snapshot.error.toString());
    }
    if (!snapshot.hasData) {
    return Center(child: Loading());
    }
    //hay datos del perfil del usuario identificado con el uid al sign in/register
    return  Text(snapshot.data.toString());
  }
    );
}
}*/


