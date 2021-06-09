import 'dart:async';
import 'package:myBlueAd/model/beacon.dart';

import '../model/user.dart';
import 'firebase_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//metodos Firestore añadir y borrar datos
//instancia Cloud Firestore
var db = FirebaseFirestore.instance;


/*//metodo map -> pasar una funcion que convierte los QuerySnapshots a List (o lo que sea)
Stream <List<Usuario>> getUsers() {
  //togrouplist recibe un querysnapshot. mapeamos el stream de querysnapshots y se genera un stream de listgroups
  //return db.collection(FirestorePath.userscollection()).orderBy('firstaccess').snapshots().map(toUserList);
  return db.collection(FirestorePath.userscollection()).orderBy('firstaccess').snapshots().map(toUserList);
}
*/


Stream <Usuario> getUserProfile(String userId)
{
  return db.doc(FirestorePath.user(userId)).snapshots().map(toUser);
}
//funcion sendmessage a Firestore, que recibe id y el mensaje
//tarda por eso future
Future<String> registerUser (String userId, Usuario usuario) async {
 try { //añadir documento con ADD, pero tiene que recibir Map <String, dynamic>, por eso convertimos el usuario con el metodo toFirestore
   //add devuelve Future<DocumentReference>, podriamos escuchar cuando se graba
   //directorio completo
   await db.doc(FirestorePath.user(userId)).set(usuario.toFirestore());
     db.doc(FirestorePath.user(userId)).update(
         {"favads": {}
         });
   return null;
 }catch (e)
  {
    return e;
  }
}

Future <String> setPhotoURL (String uid,String url) async {
  try  {
    db.doc(FirestorePath.user(uid)).update({"photoURL": url});

  } catch (e)
  {
    return e.toString();
  }
}

Future<void> deletePhotoURL(String uid) async {
  db.doc(FirestorePath.user(uid)).update({"photoURL": FieldValue.delete()});
}

/*Future <bool> favPrueba (String uid, String beacon, String zona) async
{
  //List <String> _ref = [beacon];
  try {
    db.doc(FirestorePath.user(uid)).update({"favprueba2.${zona}": beacon});
    /*db.doc(FirestorePath.user(uid)).update({"favprueba": FieldValue.arrayUnion(_ref)});
    //db.doc(FirestorePath.user(uid)).update({"x.dos": FieldValue.delete()});
    /*db.doc(FirestorePath.user(uid)).update(
       {"favads": FieldValue.arrayUnion(adurl)});*/*/
    return true;
  } on FirebaseException catch (e) {
    return false;
  }
}*/


//se añaden de uno en uno, cada vez que le da al botón de fav, pero se une una lista
Future <bool> setFavAd (String uid, String zona, String adurl) async {
 try {
   db.doc(FirestorePath.user(uid)).update({"favads.${zona}": adurl});
   //db.doc(FirestorePath.user(uid)).update({"x.dos": FieldValue.delete()});
   /*db.doc(FirestorePath.user(uid)).update(
       {"favads": FieldValue.arrayUnion(adurl)});*/
   return true;
 } on FirebaseException catch (e) {
   return false;
 }
}

Future <void> removeFavAd(String uid, String zona) async {
  db.doc(FirestorePath.user(uid)).update({"favads.${zona}": FieldValue.delete()});
}
Future <void> deleteFavAds(String uid) async {
  db.doc(FirestorePath.user(uid)).update({"favads" : {}});
}

//metodo is favad
//primero hay que ver si tiene alguno
Future <bool> isFavAd (String uid, String zona) async {
  bool _result;
 await db.doc('users/$uid').get().then((doc)
  {
    if (doc.data()["favads"]!=null)
    {
    //print (doc.data()["favads"]["${zona}"]);
     if ( (doc.data () ["favads"]["${zona}"])!=null)
    _result=true;
    else if ((doc.data()["favads"]["${zona}"])==null)
    _result = false;
  } else
    _result=false;
  });
 return _result;
}
Future <String> updateUser (String userId, Usuario usuario) async {
  try {
    //comprobar todos los campos que se han podido crear/modificar en el form DEL PERFIL. email cambios no, sign in

      db.doc(FirestorePath.user(userId)).update({"username": usuario.username});

      db.doc(FirestorePath.user(userId)).update({"name": usuario.name});

      db.doc(FirestorePath.user(userId)).update({"surname": usuario.surname});

      db.doc(FirestorePath.user(userId)).update({"gender": usuario.gender});

      db.doc(FirestorePath.user(userId)).update({"maritalstatus": usuario.maritalstatus});

      db.doc(FirestorePath.user(userId)).update({"country": usuario.country});

      db.doc(FirestorePath.user(userId)).update({"state": usuario.state});

      db.doc(FirestorePath.user(userId)).update({"city": usuario.city});

      db.doc(FirestorePath.user(userId)).update({"address": usuario.address});

      db.doc(FirestorePath.user(userId)).update({"age": usuario.age});

      db.doc(FirestorePath.user(userId)).update({"phone": usuario.phone});
    return null;

  }  catch (e)
  {
    return e.toString();
  }
}

//email y userId -> 3rd party, link, email-pwd.
Future <String> signUser (String userId, Usuario usuario) async {
  //update documento la fecha solamente si existe el documento, hay que comprobarlo previamente
  try {
    var userRef = await db.doc(FirestorePath.user(userId));

    await userRef.get().then((userdoc) async
    {
      //no existe, se crea uno nuevo
      if (!userdoc.exists) {
        await db.doc(FirestorePath.user(userId)).set(usuario.toFirestore());
        //update solamente la fecha
      } else {
        db.doc(FirestorePath.user(userId)).update(
            {"lastaccess": usuario.lastaccess});
        //cambios email al sign in de nuevo
        if (usuario.email != null)
          db.doc(FirestorePath.user(userId)).update(
              {"email": usuario.email});
        if (usuario.favads!=null)
        db.doc(FirestorePath.user(userId)).update(
            {"favads": usuario.favads});
        if (usuario.favads==null)
          db.doc(FirestorePath.user(userId)).update(
              {"favads": {}
          });

      }
    });
    return null;
  } catch (e)
  {
    return e.toString();
  }
}


Future <String> deleteUser(String userId) async
{
  try
  {
    await db.doc(FirestorePath.user(userId)).delete();
    return null;
  } catch (e)
  {
    return e.toString();
  }

}
