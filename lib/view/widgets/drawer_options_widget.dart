import 'package:flutter/material.dart';
import 'package:myBlueAd/view/widgets/settings_widget.dart';
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
            body: _drawerOptionWidget(_option),
          ),
    );
  }
}

Widget _drawerOptionWidget (String option)
{
  switch (option)
  {
    case "About":
      return Text("about");
      break;

    case "Security":
      return Text("security");
      break;

    case "Faq":
      return Text("faq");
      break;

    case "Help":
      return Text("help");
      break;

      //usuario registrado
    case "Settings":
      return UserSettings();
      break;

    default:
      return Error("Something happened, return to homepage.");

  }

}

