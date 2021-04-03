import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Platform.isIOS ? Icons.arrow_back_ios: Icons.arrow_back, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
        hoverColor: Colors.blue,
        splashColor: Colors.blue,
        backgroundColor: Colors.white54,
      onPressed: () =>Navigator.of(context).pop()
    );
  }
}
