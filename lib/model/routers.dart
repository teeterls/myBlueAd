import 'package:flutter/material.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/view/screens/bluead_screen.dart';
import 'package:myBlueAd/view/screens/scanning_screen.dart';
import 'package:myBlueAd/view/screens/blueads_demo.dart';
import '../view/screens/user_signin_action_screen.dart';
import '../view/screens/home_screen.dart';
import '../view/screens/sign_log_in_screen.dart';
import '../view/screens/user_home_screen.dart';
import '../view/widgets/error.dart';
import '../view/widgets/drawer_options_widget.dart';
import '../view/widgets/auth_landing_screen.dart';
import '../view/widgets/signin_phone_link_widget.dart';

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
        //pagina registro o acceso
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SignLogInScreen(options));
      case '/draweroptions':
      //pagina opcion drawer lateral
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DrawerOptionsWidget(options));
        //pagina principal usuario
      case '/userhome':
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
        //gestion conflicto credenciales auth 3rd party. se pasa el proveedor y el email
      case '/credentials':
        var credentials = settings.arguments as List;
        return MaterialPageRoute(builder: (_) => PwdCredentials(credentials));
      case '/signinoptions':
        //pagina acceso con link o telefono
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SignInPhoneLink(options));
      case '/useraction':
        //pagina cambio cuenta
        var options = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UserActionScreen(options));
      case '/scan':
        //pagina scanning
        return MaterialPageRoute(builder: (_) => ScanScreen());
      case '/blueads':
        //pagina visualizacion BlueAd encontrado
        var bluead=settings.arguments as BlueAd;
        return MaterialPageRoute(builder: (_) => ShowBlueAd(bluead));
      case '/blueadsdemo':
        //pagina demo
        return MaterialPageRoute(builder: (_) => BlueAdsDemo());
      default:
        //error
        return MaterialPageRoute(builder: (_) {
          return Error('No route founded for ${settings.name}');
        });
    }
  }
}