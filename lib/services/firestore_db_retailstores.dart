import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/firebase_path.dart';
import 'firebase_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//instancia firestore
var db= FirebaseFirestore.instance;

//metodo algun uid distinto de null, el primer escaneo. se mira en la bbdd todos los anuncios para ver si hay algun uid!=null
Future<bool> nullUID() async {
  try {
   return await db.collection(FirestorePath.retailstores()).get().then(
            (doc) async
        {
          //obtenemos el id del primer doc, porque solo tenemos una tienda.
          //si no hay ninguno que no sea null, son todos null :)
          return await db.collection(FirestorePath.blueads(doc.docs.first.id)).where(
              "uid", isNull: true).get().then(
                  (doc)
              {
                //tenemos dos beacons y cinco documentos
                if (doc.docs.length>3)
                  return true;
                else
                  return false;
              });
        });
  } catch (e) {
    return e;
  }
}

//set uid random de las balizas
Future <String> setUID (String uid) async {
  List id=[];
  try 
      {
        await db.collection(FirestorePath.retailstores()).get().then(
                (doc)  async
            {
              //obtenemos el id del primer doc, porque solo tenemos una tienda.
              await db.collection(FirestorePath.blueads(doc.docs.first.id)).get().then((
                  query) async {
                query.docs.forEach((doc) {
                 // se guardan los ids de los documentos
                  id.add(doc.id);
                });
                //id random, no sabemos cual sera.
                id.shuffle();
                //update atributo uid con el valor de un id random
                await db.doc(FirestorePath.bluead(doc.docs.first.id, id[0])).update({'uid' : uid});
              });
            });
        return null;
      } catch (e)
  {
    return e.toString();
  }
}

//reset uid random cuando deja de escanear. //query
Future <String> resetUID (String uid) async {
  //print(uid);
  List id=[];
  String actual;
  try
  {
    await db.collection(FirestorePath.retailstores()).get().then(
            (doc)  async
        {
          //obtenemos el id del primer doc, porque solo tenemos una tienda.
          await db.collection(FirestorePath.blueads(doc.docs.first.id)).where('uid', isEqualTo: uid).get().then(
                  (doc)
              {
                print(doc.docs.first.reference.toString());
                doc.docs.first.reference.update({"uid":null});
                actual=doc.docs.first.reference.id;
              });
          });
    //despues de borrar hace set a otro nuevo
    //TODO OTRO METODO NO SETUID, que compare actual con los random que va a poner
    await norepeatUID(uid, actual);
    //TODO
    return null;
  } catch (e)
  {
    return e.toString();
  }
}

//reset que no repita el mismo uid
Future <String> norepeatUID (String uid, String actual) async {
  //print(actual);
  List id=[];
  try
  {
    await db.collection(FirestorePath.retailstores()).get().then(
            (doc)  async
        {
          //obtenemos el id del primer doc, porque solo tenemos una tienda.
          await db.collection(FirestorePath.blueads(doc.docs.first.id)).get().then((
              query) async {
            query.docs.forEach((doc) {
              // print(id);
              id.add(doc.id);
            });
            //id random, no sabemos cual sera.
            id.shuffle();
            if (actual!=id[0])
            await db.doc(FirestorePath.bluead(doc.docs.first.id, id[0])).update({'uid' : uid});
            else
              await db.doc(FirestorePath.bluead(doc.docs.first.id, id[1])).update({'uid' : uid});
          });
        });
    return null;
  } catch (e)
  {
    return e.toString();
  }
}

Stream<BlueAd> getBlueAd(String uid)
{
  try {

          //obtenemos el id del primer doc, porque solo tenemos una tienda.
         return db.collection(FirestorePath.blueadscollection()).where(
              'uid', isEqualTo: uid)
              .snapshots().map((doc) {
            //print(toBlueAdList(doc).last.expiration);
            return toBlueAdList(doc).first;
          });

  } catch (e)
  {
    return e;
  }
}

//metodo map -> pasar una funcion que convierte los QuerySnapshots a List (o lo que sea)
Stream <List<BlueAd>> getBlueAds() {
  return db.collection(FirestorePath.blueadscollection()).orderBy('fecharegistro').snapshots().map(toBlueAdList);
}




//registerBlueAd
Future <String> registerBlueAd(BlueAd ad) async
    {
      try {
        ad.uid = null;
        await db.collection(FirestorePath.retailstores()).get().then(
                (doc) async
            {
              //obtenemos el id del primer doc, porque solo tenemos una tienda.
              try {
                await db.collection(FirestorePath.blueads(doc.docs.first.id))
                    .add(ad.toFirestore());
                return null;
              } catch (e) {
                return e;
              }
            });
      }
        catch (e)
      {
        return e;
      }
   }

   //metodo para obtener los BlueAdsfavoritos
Stream <List<BlueAd>> getFavBlueAds(List <String> urls)
{
  return db.collection(FirestorePath.blueadscollection()).where('url', whereIn: urls).snapshots().map((doc) => toBlueAdList(doc));
}
