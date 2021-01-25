import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';

//TODO CONTENIDO ENTERO Y LO DE MOSTRAR PAGINA DE FACEBOOK (TENGO QUE CREARLA), Y PODER ENVIAR UN CORREO
class AboutUsScreen extends StatefulWidget {
  final ThemeModel _model;

  //constructor
  AboutUsScreen(this._model);
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(widget._model),
            appBar: AppBar(
              title: Text('About us pantalla'),
            ),
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
