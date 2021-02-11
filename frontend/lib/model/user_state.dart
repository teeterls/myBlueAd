import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//TODO USER NODE.JS LOGICA DE USUARIOS TODO. enviar al server
//clase que se encarga de gestionar las sesiones y recoge los metodos de auth firebase
//4 tipos de estado
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

//changenotifier ->notify listeners. patron observer
class UserState with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  //inicialmente
  Status _status = Status.Uninitialized;

  //listen for changes in auth status
  UserState.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;

  //TODO REGISTER + SIGN IN CON EMAIL VERIFICATION!!! (lo + seguro a la hora de registrarse)
  //TODO ERROR CON EL TEXTO
  Future <bool> register (String username, String email, String password) async {
    try {
      //authenticating
      _status= Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _user.updateProfile(displayName: username);
      return true;
    } on FirebaseAuthException catch (e)
    {
      //TODO ERROR CON EL TEXTO
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //TODO DISTINTOS SIGNIN
  Future<bool> signInEmailPwd(String email, String password) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();

    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future <bool> signinAnonymously() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      //no hay usuario
      _auth.signInAnonymously();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }

  }

  //sign out
  Future signOut() async {
     await _auth.signOut();
    //unauthenticated
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  //forgot password of a user, status se mantiene igual porque no llega a sign in todavia
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e)
    {
      return false;
    }
  }

  //metodo avisar listeners
  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      //wrong
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      //ok
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}