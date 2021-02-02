import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:provider/provider.dart';
class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      hoverColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
      splashColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
      onPressed: () =>Navigator.of(context).pop()
    );
  }
}
