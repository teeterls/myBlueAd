import 'package:flutter/material.dart';
import '../widgets/custom_backbutton.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

//TODO CONTENIDO ENTERO Y LO DE MOSTRAR PAGINA DE FACEBOOK (TENGO QUE CREARLA), Y PODER ENVIAR UN CORREO
class AboutUsScreen extends StatefulWidget {
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
            drawer: CustomDrawer(),
            appBar: CustomAppBar(_scaffoldKey, context),
          floatingActionButton: CustomBackButton(),
        ));
  }
}
