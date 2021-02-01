import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:provider/provider.dart';

import 'custom_drawer.dart';
//TODO CONTENIDO SEGUN TIPO DE PAGINA -> SWITCH-CASE

class HomeOptionsWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //obtenemos el argumento pasado por la ruta nombrada
    final String _option = ModalRoute
        .of(context)
        .settings
        .arguments;
    switch (_option) {
      case "security":
        {
          return SafeArea(
                child: Scaffold(
                    key: _scaffoldKey,
                    drawer: CustomDrawer(),
                appBar: CustomAppBar(_scaffoldKey, context),
                floatingActionButton: CustomBackButton(),
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
       floatingActionButton: CustomBackButton(),));
        }
        break;
    }
  }
}

