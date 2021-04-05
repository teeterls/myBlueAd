import 'dart:async';
import '../model/beacon.dart';
import 'firestore_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//instancia firestore
var db= FirebaseFirestore.instance;

//TODO FUTURO UID SEÑAL emparejamiento

//metodo map -> pasar una funcion que convierte los QuerySnapshots a List (o lo que sea)
Stream <List<Baliza>> getBeacons() {
  //togrouplist recibe un querysnapshot. mapeamos el stream de querysnapshots y se genera un stream de listgroups
  return db.collection(FirestorePath.beaconscollection()).orderBy('fecha_registro').snapshots().map(toBeaconList);
}

Stream <Baliza> getBeacon(String uid)
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

}


