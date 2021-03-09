import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:provider/provider.dart';
import 'package:frontend/view/widgets/error.dart';

import 'custom_drawer.dart';
//TODO CONTENIDO SEGUN TIPO DE PAGINA -> SWITCH-CASE

class HomeOptionsWidget extends StatelessWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor)
  final String _option;
  HomeOptionsWidget(this._option);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    switch (_option) {
      case "security":
        {
          return SafeArea(
                child: Scaffold(
                    key: _scaffoldKey,
                    drawer: CustomDrawer(),
                appBar: CustomAppBar(_scaffoldKey, context),
                floatingActionButton: CustomBackButton(),
                  //TODO
                  body: Container(),
                ));
        }
        break;

      case "faq":
        {
          return SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  drawer: CustomDrawer(),
          appBar: CustomAppBar(
              _scaffoldKey, context),
       floatingActionButton: CustomBackButton(),
              //TODO
              body: Container(),));
        }
        break;
      default:
        return Error("Something happened, return to homepage.");
        break;
    }
  }
}

