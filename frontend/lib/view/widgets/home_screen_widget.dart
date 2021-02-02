import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

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
                          child: Text('Log in'),
                          callback: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          gradient: Gradients.jShine,
                          shadowColor: Gradients.jShine.colors.last.withOpacity(
                              0.25),

                        ),
                        SizedBox(width: 10,),
                        GradientButton(
                          child: Text('Sign up'),
                          callback: () {
                            Navigator.of(context).pushNamed('/signup');
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