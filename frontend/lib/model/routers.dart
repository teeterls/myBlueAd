import 'package:flutter/material.dart';
import 'package:frontend/view/screens/about_screen.dart';
import 'package:frontend/view/screens/home_screen.dart';
import 'package:frontend/view/screens/log_in_screen.dart';
import 'package:frontend/view/screens/sign_up_screen.dart';
import 'package:frontend/view/screens/user_home_screen.dart';
import 'package:frontend/view/widgets/error.dart';
import 'package:frontend/view/widgets/home_options_widget.dart';
import 'package:frontend/view/widgets/main_screen_widget.dart';
class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        //pagina main
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/home':
      //pagina inicio app
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/homeoptions':
      //obtenemos el argumento pasado por la ruta
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HomeOptionsWidget(options));
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutUsScreen());
      case '/userhome':
        //user auth pasado por la ruta
        var user = settings.arguments;
        return MaterialPageRoute(builder: (_) => UserHomeScreen(user));
        //error
      default:
        return MaterialPageRoute(builder: (_) {
          return Error('No route founded for ${settings.name}');
        });
    }
  }
}