import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/model/beacon.dart';
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
                if (doc.docs.length==5)
                  return true;
                else
                  return false;
              });
        });
  } catch (e) {
    return e;
  }
}

//set uid random cuando se empareja la primera vez
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
                 // print(id);
                  id.add(doc.id);
                });
                //id random, no sabemos cual sera.
                id.shuffle();
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
  List id=[];
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
              });
          });
    //despues de borrar hace set a otro nuevo
    return await setUID(uid);
  } catch (e)
  {
    return e.toString();
  }
}
//TODO SE FILTRA POR UID del beacon
Future<Stream<BlueAd>> getBlueAd(String uid) async
{
  try {
    //print(uid);
    return db.collection(FirestorePath.retailstores()).get().then(
            (doc) {
          //obtenemos el id del primer doc, porque solo tenemos una tienda.
         return db.collection(FirestorePath.blueads(doc.docs.first.id)).where(
              'uid', isEqualTo: uid)
              .snapshots().map((doc) {
            print(toBlueAdList(doc).first.expiration);
            return toBlueAdList(doc).first;
          });
        });
  } catch (e)
  {
    return e;
  }
}

//no se usa pero seria como ejemplo. inicialmente uid a null, luego se haria el set.

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
