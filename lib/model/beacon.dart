import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//geopoint?
//
class Baliza {
  String _uid;
  DateTime _fecharegistro;
  DateTime _expiration;

  //lat y long
 // double _latitude;
 // double _longitude;
  String _zona;
  String _url;
  String _image;

//map posicion -> geopoint y sala
//htmls  -> storage

  //todo uid señal identificador
  Baliza({String zona, String url, String image, DateTime expiration}) : _fecharegistro= DateTime.now(), _zona=zona, _url=url, _image=image, _expiration=expiration;

//constructor firebase -> obtener doc concreto de coleccion
  Baliza.fromFirestore(DocumentSnapshot doc) :
        _fecharegistro=(doc.data()['fecharegistro'] as Timestamp).toDate(),
        _zona=doc.data()['zona'],
        _url=doc.data()['url'],
        _image=doc.data()['image'],
        _expiration= (doc.data()['expiration'] as Timestamp).toDate();
        Map <String, dynamic> toFirestore() =>
      {
        'fecharegistro': _fecharegistro,
        'zona' : _zona,
        'url' : _url,
        'expiration': _expiration,
        'image' : _image
      };

  DateTime get fecharegistro => _fecharegistro;
  String get uid => _uid;
  String get zona => _zona;
  String get image => _image;
  DateTime get expiration => _expiration;
  String get url => _url;

  set url(String value) =>_url = value;
  set expiration(DateTime value) => _expiration = value;
  set zona(String zona) => _zona=zona;
  set uid(String uid)  => _uid=uid;
  set fecharegistro(DateTime fecha) => _fecharegistro = fecha;
  set image(String value) => _image = value;
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

