import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//TODO FOTO -> String url
class Usuario
{
  String _phone, _email, _photoURL, _username, _name, _surname, _gender, _country, _city, _state, _maritalstatus, _address, _uid;
  int _age;
  DateTime _lastaccess;

  //constructor -> obligatorios uid, first access, email y username una vez validados.
  Usuario(this._uid, {String email, String username, String photo, String name, String surname, String gender, String country, String address, String uid, int age, String phone, String city, String status}) :
       _email= email, _username=username, _photoURL = photo, _name = name, _surname= surname, _gender=gender, _country=country, _address=address, _age=age, _phone=phone, _city=city, _maritalstatus=status, _lastaccess = DateTime.now();

  //constructor Firebase -> obtener doc user determinado de coleccion users
  Usuario.fromFirestore(DocumentSnapshot doc)
      : //_uid=doc.id,
        _email=doc.data()['email'],
        _username=doc.data()['username'],
        _name=doc.data()['name'],
        _surname=doc.data()['surname'],
        _gender=doc.data()['gender'],
        _country=doc.data()['country'],
        _address=doc.data()['address'],
        _age=doc.data()['age'],
        _phone=doc.data()['phone'],
        _lastaccess= (doc.data()['lastaccess'] as Timestamp).toDate(),
        _city=doc.data()['city'],
        _maritalstatus= doc.data()['maritalstatus'],
        _state= doc.data()['state'];
  //constructor Firebase -> subir doc user determinado a coleccion users
  Map<String, dynamic> toFirestore() =>
      {
        //'uid': _uid,
        'email': _email,
        'username': _username,
        'name': _name,
        'surname': _surname,
        'gender': _gender,
        'maritalstatus': _maritalstatus,
        'country': _country,
        'state': _state,
        'city': _city,
        'address': _address,
        'age': _age,
        'phone': _phone,
        'lastaccess': _lastaccess,
      };

  //TODO UPDATE y otros signin?? ->  reescribe el documento con los nuevos valores. no añade uno nuevo porque al estar autenticado no cambia uid.

  //getters
  String get email => _email;
  String get photoURL => _photoURL;
  String get username => _username;
  String get name => _name;
  String get surname => _surname;
  String get gender => _gender;
  String get country => _country;
  String get address => _address;
  String get city => _city;
  String get uid => _uid;
  int get age => _age;
  String get phone => _phone;
  DateTime get lastaccess => _lastaccess;
  get maritalstatus => _maritalstatus;
  get state => _state;


  //setters
  void set email(String email) => _email=email;
  void set photoURL(String photoURL)=> _photoURL=photoURL;
  void set username(String username) => _username=username;
  void set name(String name) => _name=name;
  void set surname(String surname) => _surname=surname;
  void set gender(String gender) => _gender=gender;
  void set country(String country) =>_country=country;
  void set address(String address) =>_address=address;
  void set uid (String uid)=> _uid=uid;
  void set age (int age) => _age=age;
  void set phonenumber (String phone) => _phone=phone;
  void set lastaccess(DateTime time) => _lastaccess=time;
  void set city (String city ) => _city=city;
  void set maritalstatus (String m) => _maritalstatus=m;
  void set state (String st) => _state=st;
}

//mapear stream de querysnapshots a stream de List<User>
List<Usuario> toUserList(QuerySnapshot query)
{
  //List<DocumentSnapshot> docs= query.docs;
  //iterate, para cada documento almacenado se crea un objeto mensaje
  //lista forzada, porque map devuelve un iterable, no una lista
  return query.docs.map((doc) => Usuario.fromFirestore(doc)).toList();
}

Usuario toUser(DocumentSnapshot doc)
{
  //List<DocumentSnapshot> docs= query.docs;
  //iterate, para cada documento almacenado se crea un objeto mensaje
  //lista forzada, porque map devuelve un iterable, no una lista
  return Usuario.fromFirestore(doc);
}