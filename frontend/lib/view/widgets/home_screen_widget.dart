import 'package:flutter/material.dart';
import 'package:frontend/model/user_state_auth.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

import 'custom_snackbar.dart';

//logo y botones registro e iniciar sesion
class HomeScreenWidget extends StatelessWidget {

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
                          callback: () {
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
                  //TODO PIE CON LO DE ACEPTAR LA POLITICA DE PRIVACIDAD ,
                ]
            ),
          ),],),
  );
  }
}