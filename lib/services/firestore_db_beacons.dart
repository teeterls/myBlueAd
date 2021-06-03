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

//TODO CAMBIAR, NO SE COGERÁ AL FINAL POR ZONA
//DEVUELVE UNA LISTA DE BEACONS con la zona, en el futuro podria haber varios beacons por zona.
Stream<List<Baliza>> getBeacon(String zona)
{
 return db.collection(FirestorePath.beaconscollection()).where('zona', isEqualTo: zona)
      .snapshots().map((doc) => toBeaconList(doc));
}

//TODO GETIMAGEBEACON de storage RETAIL STORE adsimage si recibe la url. recibe la url

//TODO SETIMAGEBEACON DEL RETAILSTORE cuando se añade la zona

//TODO GETFAVBEACONS RECIBE el map de favads. lista de beacons. filtrar por zona porque igual hay mas beacons por zona.
List<Baliza> getFavBeacons(List zonas)
{
 List<Baliza> _lista;
 zonas.forEach((zona) {
  db.collection(FirestorePath.beaconscollection()).where('zona', isEqualTo: zona)
      .snapshots().map((doc)
      {
        toBeaconList(doc).forEach((element) { _lista.add(element);
       });
      });
  });
 print(_lista);
 return _lista;
 }

 //return db.collection(FirestorePath.beaconscollection()).where('zona', isEqualTo: zona)
    // .snapshots().map((doc) => toBeaconList(doc));


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


