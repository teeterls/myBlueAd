import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:provider/provider.dart';

class CustomSnackBar extends SnackBar {
  //recibe un mensaje
 final String _msg;
  final BuildContext _context;
  CustomSnackBar(this._msg, this._context, {Key key, Color backgroundColor, Widget content, Duration duration, SnackBarAction action }):
      super(key: key,
        content: Text(_msg, style: TextStyle(color: Provider.of<ThemeModel>(_context, listen: false).mode==ThemeMode.dark ? Colors.pink : Colors.white),),
        backgroundColor: Provider.of<ThemeModel>(_context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(_context).primaryColor,
        duration: Duration(seconds:3),
        action: SnackBarAction(
          label: "Ok!",
          textColor: Colors.blueAccent,
          onPressed: () => ScaffoldMessenger.of(_context).hideCurrentSnackBar()
        )
      );
}
