import 'dart:async';
import 'package:meta/meta.dart';
import '../model/user.dart';
import 'firestore_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//metodos Firestore añadir y borrar datos
//instancia Cloud Firestore
var db = FirebaseFirestore.instance;

//TODO ERROR HANDLE String
//metodo map -> pasar una funcion que convierte los QuerySnapshots a List (o lo que sea)
Stream <List<Usuario>> getUsers() {
  //togrouplist recibe un querysnapshot. mapeamos el stream de querysnapshots y se genera un stream de listgroups
  return db.collection(FirestoreUserPath.userscollection()).orderBy('firstaccess').snapshots().map(toUserList);
}

//TODO get info User -> cogemos userId cuando se auth funciona??
Stream <Usuario> getUserProfile(String userId)
{
  return db.doc(FirestoreUserPath.user(userId)).snapshots().map(toUser);
}
//funcion sendmessage a Firestore, que recibe id y el mensaje
//tarda por eso future
Future<void> registerUser (String userId, Usuario usuario) async {
  //añadir documento con ADD, pero tiene que recibir Map <String, dynamic>, por eso convertimos el usuario con el metodo toFirestore
  //add devuelve Future<DocumentReference>, podriamos escuchar cuando se graba
  //directorio completo
  await db.doc(FirestoreUserPath.user(userId)).set(usuario.toFirestore());
}

//email y userId -> 3rd party, link, email-pwd.
Future <void> signUser (String userId, Usuario usuario) async {
  //update documento la fecha solamente si existe el documento, hay que comprobarlo previamente
  var userRef = await db.doc(FirestoreUserPath.user(userId));

  await userRef.get().then((userdoc) async
  {
    //no existe, se crea uno nuevo (pero sin username)
    if (!userdoc.exists) {
      await db.doc(FirestoreUserPath.user(userId)).set(usuario.toFirestore());
      //update solamente la fecha
    } else {
      db.doc(FirestoreUserPath.user(userId)).update({"lastaccess": usuario.lastaccess});
    }
  });
}


//TODO delete account
Future <void> deleteUser(String userId) async
{
  await FirebaseFirestore.instance.doc(FirestoreUserPath.user(userId)).delete();
}
