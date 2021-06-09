import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_db_user.dart' as db;
import '../model/user.dart';

//clase que se encarga de gestionar las sesiones y recoge los metodos de auth firebase
//4 tipos de estado
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

//claves API publicas TWITTER
final String TWITTER_API = "pCnsUEp51eF9qCqkhMYOte5h1";
final String TWITTER_SECRET = "ccZXLIy1s0mEExSDryKFgzz02jnVGkF0EoUZFZmRCrKpGtOb3P";

//changenotifier ->notify listeners del cambio en el estado. patron observer
class UserState with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  String _verificationId;

  //estado inicial
  Status _status = Status.Uninitialized;

  //listen for changes in auth status -> SINGLETON ONE AND ONLY FIREBASEAUTH INSTANCE
  UserState.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  //getters
  Status get status => _status;

  User get user => _user;
  Future <String> register(String email, String password, String username) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
     await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((currentUser) async
         {
           User us= currentUser.user;
           //username
           await us.updateDisplayName(username);
           Usuario _usuario = Usuario(us.uid,email: us.email,username: username);
           String e= await db.registerUser(us.uid, _usuario);
           if (e!=null)return e;
         });
      try
          {
            if (_user.emailVerified) {
             _status = Status.Authenticated;
              notifyListeners();
              return null;
            }

            else {
              _status = Status.Unauthenticated;
              notifyListeners();
              await _user.sendEmailVerification(
                  _getactionCodeSettings('emailverification'));
             return "Verify";
              }
          } on FirebaseAuthException catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        return e.code;
      }
      } on FirebaseAuthException catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        if (e.code== 'email-already-in-use')
        {

          return "This email account already exists.Sign in or reset your password if needed";
        }
        else
        return e.code;
      }
    }

  Future<String> signInEmailPwd(String email, String password) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((currentUser) async
          {
            User us= currentUser.user;
            Usuario _usuario = Usuario(us.uid, email: us.email);
            String e= await db.signUser(us.uid, _usuario);
            return e;
          });

    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code== 'user-not-found')
      {

        return "Email account not found. Log in";
      }
      else if (e.code=='wrong-password')
        {
          return "Wrong password for this email account. Try again or reset password";
        }
      else
        return e.code;
    }
  }
  Future <String> signinAnonymously() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      await _auth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  Future <String> signinAnonymtoUser(String email, String password, String username) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      //el actual
      await _auth.signOut();
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password).then((currentUser) async
        {
          User us= currentUser.user;
          //username
          await us.updateDisplayName(username);
          Usuario _usuario = Usuario(us.uid,email: us.email,username: username);
          String e= await db.registerUser(us.uid, _usuario);
          if (e!=null)return e;
        });
       await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }


  Future <String> signInWithLink(String email) async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      await _auth.sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: _getactionCodeSettings('signinlink'));
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }
  //TODO DIFERENTES OPCIONES DE LINK
  Future <String> getInitialLink(String email) async {
    print("aqui");
    String er=null;
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if( data?.link != null ) {
      print("aqui2");
           handleLink(data?.link, email);
    }
    print("aqui3");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print("uri");
          final Uri deepLink = dynamicLink?.link;
          print("prehandle");
          handleLink(deepLink, email);
        },
        onError: (OnLinkErrorException e) async {
      er=e.message;
    });
      return er;
  }

  Future <String> handleLink(Uri link, String email) async {
    print("handle");
    try {
      if (link != null) {
        print(link);
        print(email);
        print(link.toString());
        await _auth.signInWithEmailLink(
          email: email,
          emailLink: link.toString(),
        ).then((currentUser) async {
            User us= currentUser.user;
            Usuario _usuario = Usuario(us.uid, email: us.email);
           String e= await db.signUser(user.uid, _usuario);
           return e;
        });
      }
    } on FirebaseAuthException catch (e)
    {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

    //phone
    Future <String> signInWithPhone(String smscode) async {
    print(smscode);
      _status = Status.Authenticating;
      notifyListeners();
      try {
        //print(_verificationId);
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: smscode,
        );
        await _auth.signInWithCredential(credential);
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

      };
      PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        _verificationId = verificationId;
        print("verification"+_verificationId);
      };

      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 15),
          verificationFailed: verificationFailed,
          verificationCompleted: verificationCompleted,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      return null;

    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  //3rd party
  Future <String> signInWithGoogle() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    try {
      //ok, se crea user
      await _auth.signInWithCredential(await _credentialGoogle()).
      then((currentUser) async
      {
        User us= currentUser.user;
        Usuario _usuario = Usuario(us.uid, email: us.email);
       String e= await db.signUser(us.uid, _usuario);
        return e;
      });

    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code == 'account-exists-with-different-credential')
      {
        //devuelve string con error o no
        (_handledifferentCredentials (e.email, e.credential)).then((value) => value);
      }
      return e.code;
    }
  }

  Future <List <dynamic>>  signInWithFacebook() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    String e=null;
    try {
      final res= await FacebookLogin().logIn(
        permissions:
          [
            FacebookPermission.email,
            FacebookPermission.publicProfile,
          ]
      );

      //res status switch case -> ok or not? pueden ocurrir errores aqui
      switch(res.status)
      {
        case FacebookLoginStatus.success:
          //ok, cogemos el token.
        final FacebookAccessToken fbToken = res.accessToken;
        //authcredential
        final FacebookAuthCredential fbauthCredential = FacebookAuthProvider.credential(fbToken.token);
        await _auth.signInWithCredential(fbauthCredential).then((currentUser) async
        {
          User us= currentUser.user;
          Usuario _usuario = Usuario(us.uid, email: us.email);
          e= await db.signUser(us.uid, _usuario);

        });
          break;

        case FacebookLoginStatus.error:
          e="An error ocurred when trying to sign in with Facebook.";
          _status = Status.Unauthenticated;
          notifyListeners();

          break;

        case FacebookLoginStatus.cancel:
          e="User cancelled sign in with Facebook.";
          _status = Status.Unauthenticated;
          notifyListeners();
          break;

        default:
          e="An error ocurred when trying to sign in with Facebook.";
          _status = Status.Unauthenticated;
          notifyListeners();
          break;
      }

      return [e, null];

      //cualquier otro error en el lado de auth
    }on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      //manage different credentials 3rd party
      if (e.code == 'account-exists-with-different-credential')
        {
          //devuelve string con error o no
          return _handledifferentCredentials (e.email, e.credential);
        }
      //otro error
        else
      return [e.code, null];

    }
  }

  //metodo publico porque los datos de la API son publicos
  Future <List <dynamic>>  signInWithTwitter() async {
    //authenticating
    _status = Status.Authenticating;
    notifyListeners();
    String e=null;
    try {
      final TwitterLoginResult res = await TwitterLogin(consumerKey: TWITTER_API, consumerSecret: TWITTER_SECRET).authorize();
      switch (res.status) {
        case TwitterLoginStatus.loggedIn:
          await _auth.signInWithCredential(
              await _credentialTwitter(res.session)).then((currentUser) async
          {
            User us= currentUser.user;
            Usuario _usuario = Usuario(us.uid, email: us.email);
            e= await db.signUser(us.uid, _usuario);

          });
          break;
        case TwitterLoginStatus.cancelledByUser:
          e="cancel";
          _status = Status.Unauthenticated;
          notifyListeners();
          break;
        case TwitterLoginStatus.error:
          e=res.errorMessage;
          _status = Status.Unauthenticated;
          notifyListeners();
          break;
        default:
          e="error";
          _status = Status.Unauthenticated;
          notifyListeners();

      }
      return [e, null];
      //firebase error
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      //manage different credentials 3rd party
      if (e.code == 'account-exists-with-different-credential')
      {
        //devuelve List con error o no
        return _handledifferentCredentials (e.email, e.credential);
      }
      //otro error
      else
        return [e.code, null];
    }
  }

  //handle current credentials
  Future <List <dynamic>> _handledifferentCredentials (String email, AuthCredential credential) async
  {

    try {
      UserCredential usercredential;
      // Fetch a list of what sign-in methods exist for the conflicting user
      List<String> userSignInMethods = await _auth.fetchSignInMethodsForEmail(email);
      print(userSignInMethods);
      if (userSignInMethods.first == 'password')
      {
        //pending credential
        print(email);
        return [email, credential];

      }
      else if (userSignInMethods.first == 'facebook.com')
        // Sign the user in with the  current Facebook credential
         usercredential = await _auth.signInWithCredential(await (_credentialFacebook()));

      else if (userSignInMethods.first == 'google.com')
        // Sign the user in with current Google credential
        usercredential = await _auth.signInWithCredential(await (_credentialGoogle()));

      else if (userSignInMethods.first == 'twitter.com')
        usercredential = await _auth.signInWithCredential(await (_credentialTwitter((await TwitterLogin(consumerKey: TWITTER_API, consumerSecret: TWITTER_SECRET).authorize()).session)));

      // Link the pending credential with the existing account
      await usercredential.user.linkWithCredential(credential).then((currentUser) async
    {
    User us= currentUser.user;
    Usuario _usuario = Usuario(us.uid, email: us.email);
    await db.signUser(us.uid, _usuario);

    });
      return null;

    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return [e.code, null];
    }
  }

  Future <GoogleAuthCredential> _credentialGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return googleAuthCredential;
    } catch(e)
    {
      return null;
    }
  }

  Future <TwitterAuthCredential> _credentialTwitter(TwitterSession session) async {
    try {
      final TwitterAuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: session.token, secret: session.secret);
      return twitterAuthCredential;
    } catch (e)
    {
      return null;
    }
  }

  Future <FacebookAuthCredential> _credentialFacebook() async {
    try {
      String fbtoken= (await FacebookLogin().logIn(
          permissions:
          [
            FacebookPermission.email,
            FacebookPermission.publicProfile,
          ]
      )).accessToken.token;

      FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(fbtoken);
      return facebookAuthCredential;

    } catch (e)
    {
      return null;
    }
  }

  Future <String> emailPwdCredentials (String email, String password, AuthCredential credential) async {
    // Sign the user in to their account with the password
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Link the pending credential with the existing account
      await userCredential.user.linkWithCredential(credential).then((currentUser) async
    {
    User us= currentUser.user;
    Usuario _usuario = Usuario(us.uid, email: us.email);
    String e= await db.signUser(us.uid, _usuario);
    return e;
    });
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.code;
    }
  }

  //forgot password of a user, status se mantiene igual porque no llega a sign in todavia
  Future<bool> resetPasswordWithEmail(String email) async {
    try {
      _status=Status.Unauthenticated;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);//actionCodeSettings: _getactionCodeSettings('resetpwd'));
      return true;
    }  catch (e) {
      return false;
    }
  }

  //no tocamos el estado
  Future <String> resetPasswordUser (String email) async {
    try
        {
          await _auth.sendPasswordResetEmail(email: email);
          return null;
        } on FirebaseAuthException catch (e)
        {
          return e.code;
        }
  }


  Future <String> updateEmail(String email, String password, String newemail) async {
    try {
      await _auth.currentUser.updateEmail(newemail);
      _auth.signOut();
      //puede que de algun fallo.
      String er= await signInEmailPwd(newemail, password);
      return er;
    } on FirebaseAuthException catch (e)
    {
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

  Future <String> deleteUser() async  {
    try
    {
      /*_auth.signOut();
      _status = Status.Unauthenticated;
      notifyListeners();*/
      await _auth.currentUser.delete();
     String e= await db.deleteUser(user.uid);
      return e;

    } on FirebaseAuthException catch (e)
    {
      return e.code;
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

//TODO IOS
ActionCodeSettings _getactionCodeSettings(String url) => ActionCodeSettings(
      url:  'https://myblueadapp.page.link/' + url,
      handleCodeInApp: true,
      androidMinimumVersion: '21',
      //iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
      androidPackageName: 'com.mybluead.frontend');








