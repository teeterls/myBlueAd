import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//geopoint?
class Baliza {
  String _uid;
  DateTime _fecharegistro;

  //lat y long
  double _latitude;
  double _longitude;
  String _zona;

//map posicion -> geopoint y sala
//htmls  -> storage

  //todo uid señal identificador
  Baliza(this._uid, {DateTime fecha}) : _fecharegistro=fecha;

//constructor firebase -> obtener doc concreto de coleccion
  Baliza.fromFirestore(DocumentSnapshot doc) :
        _fecharegistro=(doc.data()['fecha_registro'] as Timestamp).toDate();

  Map <String, dynamic> toFirestore() =>
      {
        'fecha_registro': _fecharegistro,
      };

  DateTime get fecharegistro => _fecharegistro;
  String get uid => _uid;

  set uid(String uid)  => _uid=uid;
  set fecharegistro(DateTime fecha) => _fecharegistro = fecha; //getters
//detters
}

//mapear stream de querysnapshots a stream de List<User>
  List<Baliza> toBeaconList(QuerySnapshot query)
  {
    //List<DocumentSnapshot> docs= query.docs;
    //iterate, para cada documento almacenado se crea un objeto mensaje
    //lista forzada, porque map devuelve un iterable, no una lista
    return query.docs.map((doc) => Baliza.fromFirestore(doc)).toList();
  }

  Baliza toBeacon(DocumentSnapshot doc)
  {

    return Baliza.fromFirestore(doc);
  }

