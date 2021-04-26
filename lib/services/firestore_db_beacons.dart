import 'dart:async';
import 'package:myBlueAd/model/user.dart';

import '../model/beacon.dart';
import 'firestore_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//instancia firestore
var db= FirebaseFirestore.instance;
/*
//metodo map -> pasar una funcion que convierte los QuerySnapshots a List (o lo que sea)
Stream <List<Baliza>> getBeacons() {
  //togrouplist recibe un querysnapshot. mapeamos el stream de querysnapshots y se genera un stream de listgroups
  return db.collection(FirestorePath.beaconscollection()).orderBy('fecha_registro').snapshots().map(toBeaconList);
}*/

Stream<List<Baliza>> getBeacon(String zona)
{
 return db.collection(FirestorePath.beaconscollection()).where('zona', isEqualTo: zona)
      .snapshots().map((doc) => toBeaconList(doc));
}

//se registra el beacon en firestore
Future<String> registerBeacon (Baliza beacon) async {
 try { //añadir documento con ADD, pero tiene que recibir Map <String, dynamic>, por eso convertimos el usuario con el metodo toFirestore
  //add devuelve Future<DocumentReference>, podriamos escuchar cuando se graba
  //directorio completo
  await db.collection(FirestorePath.beaconscollection()).add(beacon.toFirestore());
  return null;
 }catch (e)
 {
  return e;
 }
}
/*Stream <Baliza> getBeacon(String zona=
{
   return db.collection(FirestorePath.beaconscollection()).where('zona', isEqualTo: zona)
      .snapshots().map((doc) => toBeacon(doc.docs.first));
}*/

//TODO FUTURO UID SEÑAL emparejamiento -> ya nos dan el uid
/*Stream <Baliza> getBeacon(String uid)
{
  return db.doc(FirestorePath.beacon(uid)).snapshots().map(toBeacon);
}

//se registra el beacon en firestore
Future<String> registerBeacon (String uid, Baliza beacon) async {
  try { //añadir documento con ADD, pero tiene que recibir Map <String, dynamic>, por eso convertimos el usuario con el metodo toFirestore
    //add devuelve Future<DocumentReference>, podriamos escuchar cuando se graba
    //directorio completo
    await db.doc(FirestorePath.beacon(uid)).set(beacon.toFirestore());
    return null;
  }catch (e)
  {
    return e;
  }
}

Future <String> updateBeacon (String uid, Baliza beacon) async {
  try
      {
        //TODO
      } catch (e)
  {
    return e;
  }

}


Future <String> deleteBeacon(String uid) async
{
  try
  {
    await db.doc(FirestorePath.beacon(uid)).delete();
    return null;
  } catch (e)
  {
    return e.toString();
  }

}*/


