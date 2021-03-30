import 'package:flutter/material.dart';
import 'package:frontend/view/screens/user_signin_action_screen.dart';
import 'package:frontend/view/screens/home_screen.dart';
import 'package:frontend/view/screens/sign_log_in_screen.dart';
import 'package:frontend/view/screens/user_home_screen.dart';
import 'package:frontend/view/widgets/error.dart';
import 'package:frontend/view/widgets/drawer_options_widget.dart';
import 'package:frontend/view/widgets/auth_landing_screen.dart';
import 'package:frontend/view/widgets/signin_phone_link_widget.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        //pagina main que es la que redirige segun el estado
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/home':
      //pagina inicio app
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/signlogin':
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SignLogInScreen(options));
      case '/draweroptions':
      //obtenemos la opcion para el drawer pasado por la ruta
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DrawerOptionsWidget(options));
            //pagina USUARIO (anonimo o no)
      case '/userhome':
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
      case '/credentials':
        //se le envia el provider y el email en conflicto de credentials
        var credentials = settings.arguments as List;
        return MaterialPageRoute(builder: (_) => PwdCredentials(credentials));
      case '/signinoptions':
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SignInPhoneLink(options));
      case '/useraction':
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UserActionScreen(options));
     /* case '/changepwd':
        var email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ChangePwd(email));*/
        //error default
      default:
        return MaterialPageRoute(builder: (_) {
          return Error('No route founded for ${settings.name}');
        });
    }
  }
}