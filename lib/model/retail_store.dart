import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class RetailStore
{
  //String id;
  String _nombre;
  GeoFirePoint _firePoint;
RetailStore({String nombre, GeoFirePoint ubicacion}) : _nombre=nombre, _firePoint=ubicacion;

 RetailStore.fromFirestore(DocumentSnapshot doc) :
       _firePoint= Geoflutterfire().point(latitude: (doc.data()['ubicacion'] as GeoPoint).latitude, longitude: (doc.data()['ubicacion'] as GeoPoint).longitude),
        _nombre=doc.data()['nombre'];


        Map <String, dynamic> toFirestore() =>
      {
        'nombre': _nombre,
        'ubicacion' : _firePoint.geoPoint,
      };

  String get nombre => _nombre;
  GeoFirePoint get firePoint => _firePoint;

  set nombre(String nombre) => _nombre=nombre;
  set firePoint(GeoFirePoint value) => _firePoint = value;
 }
