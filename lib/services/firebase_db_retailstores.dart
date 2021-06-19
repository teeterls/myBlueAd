import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/services/firebase_path.dart';
import 'firebase_path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//instancia firestore
var db= FirebaseFirestore.instance;

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
Future <String> getBlueAd() async
{

}

//no se tiene por que usa pero un ejemplo. inicialmente poner uid a null y luego setuid.
Future <String> registerBlueAd() async
    {

    }