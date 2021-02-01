import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/screens/about_screen.dart';
import 'package:frontend/view/widgets/home_options_widget.dart';
import 'package:provider/provider.dart';

import 'package:frontend/view/screens/home_screen.dart';
import 'package:frontend/view/screens/log_in_screen.dart';
import 'package:frontend/view/screens/sign_up_screen.dart';

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
          //named routes concentradas
          routes: {
            '/': (_) => HomeScreen(),
            '/login': (_) => LogInScreen(),
            '/signup' :(_) => SignUpScreen(),
            '/homeoptions': (_) => HomeOptionsWidget(),
            '/about': (_) => AboutUsScreen(),
          }

      ),
        ),
    );
  }
}


