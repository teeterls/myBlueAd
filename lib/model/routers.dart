import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myBlueAd/model/beacon.dart';
import 'package:myBlueAd/model/bluead.dart';
import 'package:myBlueAd/view/screens/scanning_screen.dart';
import 'package:myBlueAd/view/screens/show_update_profile.dart';
import 'package:myBlueAd/view/screens/zona_beacon_demo.dart';
import 'package:myBlueAd/view/screens/zona_blueads_demo.dart';
import 'package:myBlueAd/view/widgets/user_profile_widget.dart';
import 'package:myBlueAd/view/screens/zona_beacon.dart';
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
     /* case '/ads':
        var zona= settings.arguments as String;
        return MaterialPageRoute(builder: (_) => Ad(zona));
      case '/showbeacon':
        var beacon= settings.arguments as Baliza;
        return MaterialPageRoute(builder: (_) => ShowFavBeacon(beacon));
      case '/adsdemo':
        var zonas=settings.arguments as List<String>;
        return MaterialPageRoute(builder: (_) => AdsDemo(zonas));*/
      case '/scan':
        return MaterialPageRoute(builder: (_) => ScanScreen());
      case '/blueads':
        var bluead=settings.arguments as BlueAd;
        return MaterialPageRoute(builder: (_) => ShowBlueAd(bluead));
      case '/blueadsdemo':
        return MaterialPageRoute(builder: (_) => BlueAdsDemo());
      case '/viewblueads':
        var bluead=settings.arguments as BlueAd;
        return MaterialPageRoute(builder: (_) => OnlyViewBlueAd(bluead));
      default:
        return MaterialPageRoute(builder: (_) {
          return Error('No route founded for ${settings.name}');
        });
    }
  }
}