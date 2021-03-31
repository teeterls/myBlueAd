//TODO CUSTOMAPPBAR SHAREPREFERENCE IDIOMA Y THEME
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import 'package:provider/provider.dart';

import 'custom_switch.dart';

class CustomAppBar extends AppBar
{
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final BuildContext _context;
  //constructor

  CustomAppBar(this._scaffoldKey, this._context, {Key key, Widget leading, Widget flexibleSpace, List <Widget> actions}) :
        super (key:key,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              //abre el drawer que sea
                onTap: () => _scaffoldKey.currentState.openDrawer(),
                child: Image.asset("assets/logo.png")),

          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.indigo,
                      Theme
                          .of(_context)
                          .primaryColor,
                    ])
            ),
          ),
          actions: <Widget>[
    CustomSwitch(Provider.of<ThemeModel>(_context, listen: false))
  ]);
}