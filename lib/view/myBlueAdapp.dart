import 'package:flutter/material.dart';
import '../model/routers.dart';
import '../model/theme_model.dart';

import 'package:provider/provider.dart';


class myBlueAdApp extends StatelessWidget {

  final String _title = "myBlueAd";
  bool isswitch= false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder:(context, theme ,_) =>MaterialApp(
          debugShowCheckedModeBanner: false,
          title:_title,
          theme: ThemeData(
              primaryColor: Colors.pink[500],
              visualDensity: VisualDensity.adaptivePlatformDensity
          ), // Provide light theme.
          darkTheme: ThemeData.dark(), // Provide dark theme.
          themeMode:  theme.mode,
          initialRoute: '/',
          //generador de rutas
          onGenerateRoute: Routers.generateRoute,

        ),
      ),
    );
  }
}

