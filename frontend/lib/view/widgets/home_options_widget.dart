import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';

import 'custom_drawer.dart';
//TODO CONTENIDO SEGUN TIPO DE PAGINA -> SWITCH-CASE

class HomeOptionsWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ThemeModel _model;

  //constructor
  HomeOptionsWidget(this._model);
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
                    drawer: CustomDrawer(_model),
                appBar: CustomAppBar(_model, _scaffoldKey, context),
                body: Center(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                      child: Text('Volver a home'),
                      onPressed: ()
                      {
                      //volver directamente
                      Navigator.of(context).pop();
                      },

                       )
                )));
        }
        break;

      case "faq":
        {
          return SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  drawer: CustomDrawer(_model),
          appBar: CustomAppBar( _model,
              _scaffoldKey, context),
        body: Center(
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
        child: Text('Volver a home'),
        onPressed: ()
        {
        //volver directamente
        Navigator.of(context).pop();
        },

        )
              )));
        }
        break;
    }
  }
}

