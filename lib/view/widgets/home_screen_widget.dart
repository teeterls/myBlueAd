import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//TODO CONNECTIVITY. tiene que estar online.
//logo y botones registro e iniciar sesion
class HomeScreenWidget extends StatelessWidget {

  Future <String> _checkConnectivity () async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return null;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return null;
      // I am connected to a wifi network.
    } else
      return "no";
  }
  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Stack(
    children: <Widget> [
      Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>
                [
                  Center(
                    child: Image.asset('assets/logo-completo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GradientButton(
                          //registrarse
                          child: Text('Log in'),
                          callback: () async
                           {
                            if (await _checkConnectivity()==null)
                            Navigator.of(context).pushNamed('/signlogin', arguments: "Log in");
                            },
                          gradient: Gradients.jShine,
                          shadowColor: Gradients.jShine.colors.last.withOpacity(
                              0.25),

                        ),
                        SizedBox(width: 10,),
                        GradientButton(
                          //entrar
                          child: Text('Sign in'),
                          callback: () {
                            Navigator.of(context).pushNamed('/signlogin', arguments: "Sign in");
                          },
                          gradient: Gradients.hotLinear,
                          shadowColor: Gradients.hotLinear.colors.last
                              .withOpacity(0.25),
                        ),
                      ],
                    ),
                  )
                ]
            ),
          ),],),
  );
  }
}