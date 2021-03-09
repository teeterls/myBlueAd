import 'package:flutter/material.dart';

import 'package:frontend/view/widgets/error.dart';
//options -> 3rd party sign in: fac
class  SigninSocial extends StatelessWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor)
  final String _option;

  SigninSocial(this._option);

  //case
  @override
  Widget build(BuildContext context) {
    switch (_option) {
      case ("facebook"):
        return Container(
          child: Text("fb")
        );
      case ("twitter"):
        return Container(
          child: Text("tw")
        );
      default:
        return Error("Something happened, return to homepage.");
        break;
    }
  }
}
