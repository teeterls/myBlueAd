import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';

//LOGIN USUARIO REGISTRADO
class LogInScreen extends StatefulWidget {
  final ThemeModel _model;

  //constructor
  LogInScreen(this._model);
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(widget._model),
            appBar: CustomAppBar(widget._model, _scaffoldKey, context),
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
}
