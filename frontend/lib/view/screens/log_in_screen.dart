import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

//LOGIN USUARIO REGISTRADO
class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(),
            appBar: CustomAppBar( _scaffoldKey, context),
            floatingActionButton: CustomBackButton(),));
  }
}
