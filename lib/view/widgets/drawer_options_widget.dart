
import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/view/widgets/settings_widget.dart';
import 'package:provider/provider.dart';
import 'custom_appbar.dart';
import 'custom_backbutton.dart';
import 'error.dart';

import 'custom_drawer.dart';

class DrawerOptionsWidget extends StatelessWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor)
  final String _option;

  DrawerOptionsWidget(this._option);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(),
            appBar: CustomAppBar(_scaffoldKey, context),
            floatingActionButton: CustomBackButton(),
            body: Scrollbar(child: SingleChildScrollView(child: _drawerOptionWidget(_option, context))),
          ),
    );
  }
}

Widget _drawerOptionWidget (String option, BuildContext context)
{
  switch (option)
  {
    case "About":
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
      Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 25.0),
  child: Text("About", style: TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
  ),),
  ), ]
      );
      break;

    case "Security":
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 25.0),
              child: Text("Security", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
            ), ]
      );
      break;

    case "Faq":
       return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 25.0),
              child: Text("FAQ", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
            ), ]
      );
      break;

      //no anonimo
    case "Help":
     return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 25.0),
              child: Text("Help", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
            ), ]
      );
      break;

      //usuario registrado
    case "Settings":
      return UserSettings();
      break;

    default:
      return Error("Something happened, return to homepage.");

  }
}

//ambos
class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

//not user
class SecuritySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//not user
class FaqSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//user
class HelpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}







