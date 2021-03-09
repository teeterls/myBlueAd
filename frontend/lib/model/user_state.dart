import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:google_sign_in/google_sign_in.dart';
//TODO USER NODE.JS LOGICA DE USUARIOS TODO. enviar al server
//clase que se encarga de gestionar las sesiones y recoge los metodos de auth firebase
//4 tipos de estado
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

//changenotifier ->notify listeners. patron observer
class UserState with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  String _verificationId;

  //inicialmente
  Status _status = Status.Uninitialized;

  //listen for changes in auth status
  UserState.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;

  User get user => _user;

  //TODO REGISTER + SIGN IN CON EMAIL VERIFICATION!!! (lo + seguro a la hora de registrarse)
  //TODO OTHER CREDENTIALS AUTH CORREGIR EMAIL ALREADY IN USE
  Future <String> register(String email,
      String password) async {
    try {
      //authenticating
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      /*try {
        //recibe el nombre del usuario

         await _user.sendEmailVerification();
        if (_user.emailVerified) {
          _user.reload();
          return null;
        }
        else
          return "Verify your account";
      } on FirebaseAuthException catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        return e.code;
      }
      */
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }


  //TODO DISTINTOS SIGNIN, cogemos e
  Future<String> signInEmailPwd(String email, String password) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return null;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  Future <String> signinAnonymously() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      //no hay usuario
      await _auth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  Future <String> signInWithLink(String email) async {
    try {
      await _auth.sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
              url:
              'https://mybluead-tfg.firebaseapp.com',
              handleCodeInApp: true,
              androidMinimumVersion: '12',
              //iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
              androidPackageName: 'com.mybluead.frontend'));
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  void handleLink(Uri link) async {
    if (link != null) {
      print('not null');
      final User user = (await _auth.signInWithEmailLink(
        email: 'teeterls12@gmail.com',
        emailLink: link.toString(),
      ))
          .user;
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await Future.delayed(Duration(seconds: 3));
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    final queryParams = deepLink.queryParameters;
    if (queryParams.length > 0) {
      var userName = queryParams['userId'];
    }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink)
    async {
      var deepLink = dynamicLink?.link;
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

    Future <String> signInWithPhone(String smscode) async {
      _status = Status.Authenticating;
      notifyListeners();
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: smscode,
        );
        final User user = (await _auth.signInWithCredential(credential)).user;
        return null;
      } on FirebaseAuthException catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        return e.code;
      }
    }


 Future <String> verifyPhoneNumber(String phone) async {
    try {
      PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
      };

      PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
      return authException.code;
      };
      PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        _verificationId = verificationId;
      };

      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 5),
          verificationFailed: verificationFailed,
          verificationCompleted: verificationCompleted,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future <String> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      //ok, se crea user
      final user = userCredential.user;
      return null;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  Future <String> signInWithFacebook() async {
    try {

    }on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  Future <String> signInWithTwitter() async {
    try {

    }on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
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
    } catch (e) {
      return false;
    }
  }

  //metodo avisar listeners cambios FirebaseAuth
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