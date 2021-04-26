import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//geopoint?
//
class Baliza {
  String _uid;
  DateTime _fecharegistro;

  //lat y long
 // double _latitude;
 // double _longitude;
  String _zona;
  String _url;

//map posicion -> geopoint y sala
//htmls  -> storage

  //todo uid señal identificador
  Baliza({String zona, String url}) : _fecharegistro= DateTime.now(), _zona=zona, _url=url;

//constructor firebase -> obtener doc concreto de coleccion
  Baliza.fromFirestore(DocumentSnapshot doc) :
        _fecharegistro=(doc.data()['fecharegistro'] as Timestamp).toDate(),
        _zona=doc.data()['zona'],
        _url=doc.data()['url'];
        Map <String, dynamic> toFirestore() =>
      {
        'fecharegistro': _fecharegistro,
        'zona' : _zona,
        'url' : _url,
      };

  DateTime get fecharegistro => _fecharegistro;
  String get uid => _uid;
  String get zona => _zona;

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  set zona(String zona) => _zona=zona;
  set uid(String uid)  => _uid=uid;
  set fecharegistro(DateTime fecha) => _fecharegistro = fecha;

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

