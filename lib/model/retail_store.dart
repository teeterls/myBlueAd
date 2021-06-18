import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
//se pueden registrar como tienda
import 'beacon.dart';
//TODO, pero no es relevante poque no la utilizamos
class RetailStore
{
  //String id;
  String _nombre;
  LocationData _ubicacion;
  GeoFirePoint _firePoint;
RetailStore({String nombre, LocationData ubicacion}) : _nombre=nombre, _ubicacion=ubicacion;

 RetailStore.fromFirestore(DocumentSnapshot doc) :
       _firePoint= Geoflutterfire().point(latitude: (doc.data()['ubicacion'] as GeoPoint).latitude, longitude: (doc.data()['ubicacion'] as GeoPoint).longitude),
        _nombre=doc.data()['nombre'];


        Map <String, dynamic> toFirestore() =>
      {
        'nombre': _nombre,
        'ubicacion' : _ubicacion,
      };

  LocationData get ubicacion=> _ubicacion;
  String get nombre => _nombre;

  set ubicacion(LocationData ubicacion) =>_ubicacion = ubicacion;
  set nombre(String nombre) => _nombre=nombre;
 }
