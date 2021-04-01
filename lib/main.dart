
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/view/myBlueAdapp.dart';
import '/view/widgets/error.dart';
import '/view/widgets/loading.dart';
import 'package:provider/provider.dart';

import '/model/theme_model.dart';

import '/services/user_state_auth.dart';

void main() {
  //widgets de flutter inicializado
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider <ThemeModel> (
      create: (_) => ThemeModel(),
      ),
      ChangeNotifierProvider <UserState> (
        //singleton
        create: (_) => UserState.instance(),
      ),
    ],
      child: InitializeApp(),
  ),);
}

//app que inicializa FlutterFire de forma async para la conexion con Firebase
class InitializeApp extends StatefulWidget {
  @override
  _InitializeAppState createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  String _msg;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set _nitialized state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set _error state to true if Firebase initialization fails
      setState(() {
        _error = true;
        //error trace
        _msg=e.toString();
      });
    }
  }

  //initial state
  @override
  void initState() {
    //async function? -> error de conexion o ok
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      //recibe el mensaje de error
      return Error(_msg);
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }

    //ok initialized -> App
    return myBlueAdApp();
  }
}
