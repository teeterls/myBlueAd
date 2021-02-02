import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//TODO USER NODE.JS LOGICA DE USUARIOS TODO
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

  //metodos firebase Register y SignIn -> si han ido ok
  Future<bool> register (String username, String email, String password) async {
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
  Future<bool> signIn(String email, String password) async {
    try {
      //authenticating
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //_user.updateProfile(displayName:'teresa');
      //print(_user.displayName);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    //unauthenticated
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
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