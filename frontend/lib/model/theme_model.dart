
//modelo de tema para Material App heredando de ChangeNotifier
import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {

  ThemeMode _mode;

  //constructor
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  //getter
  ThemeMode get mode => _mode;

  //flutter avisa a los listeners de que el modelo a cambiado de un tema a otro
  toggleMode() async{
    //cambio de thememode de uno a otro
    //patron observer
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}