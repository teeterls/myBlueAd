import 'package:flutter/material.dart';
import '../../services/user_state_auth.dart';
import '../screens/home_screen.dart';
import '../screens/user_home_screen.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

//clase que decide a que página ir según el estado de auth 
//posibilidades: home (donde signin y register) o userhome (ya hay un usuario sign in)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserState.instance(),
      child: Consumer <UserState>(
        builder: (context, user, _) {
          switch (user.status) {
            //primera vez
            case Status.Uninitialized:
              return HomeScreen();
              //no se ha autenticado
            case Status.Unauthenticated:
              return HomeScreen();
            //log in
            case Status.Authenticating:
              return Loading();
            case Status.Authenticated:
              //ok entra directamente en su perfil. esto es si hay alguna sesion abierta
              return UserHomeScreen();
          }
        },
      ),
    );
  }
}

