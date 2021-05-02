import 'dart:io';
import 'package:myBlueAd/services/firestore_path.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';


//instancia storage
var storage= FirebaseStorage.instance;

//metodo meter en cloudstorage img picker del usuario -> diferenciarlo de alguna manera (con el uid)
Future <String> uploadUserImage (File image, String uid) async
{
  try {
    await storage.ref(StoragePath.profileimg(uid)).putFile(image);
    //TODO metodo añadir photoURL a firestore
   /* UploadTask uploadTask = userstorage.putFile(file);
    String url;
    uploadTask.whenComplete(() async {
      url = await userstorage.getDownloadURL();
    }).catchError((onError) {
      return onError.toString();
    });*/
  }  on FirebaseException catch (e)
  {
    return e.code;
  }
}

//metodo download de cloudstorage img para el perfil

Future<String> downloadUserImage(String uid) async {
  String downloadURL = await storage.ref(StoragePath.profileimg(uid))
      .getDownloadURL();
  return downloadURL;

  // Within your widgets:
  // Image.network(downloadURL);
}

Future <void> deleteUserImage(String uid) async {
  await storage.ref(StoragePath.profileimg(uid)).delete();
}