import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_backbutton.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/home_forms_widget.dart';

//se muestra primero login email-pwd
//TODO APPLE LOGIN
class SignLogInScreen extends StatefulWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor)
  final String _option;
  SignLogInScreen(this._option);
  @override
  _SignLogInScreenState createState() => _SignLogInScreenState();
}

class _SignLogInScreenState extends State<SignLogInScreen> {
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _password2;
  TextEditingController _username;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacios
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _password2 = TextEditingController(text: "");
    _username= TextEditingController(text:"");
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
    child:SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(_scaffoldkey, context),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: GestureDetector(
                onTap: ()=> hideKeyboard(context),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: widget._option=="Log in" ? LogInForm(formKey: _formKey, email: _email, password: _password) : RegisterForm(formKey: _formKey, email: _email, password: _password, password2: _password2, username: _username),
              ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: "Go back",
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios: Icons.arrow_back, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
            hoverColor: Colors.blue,
            splashColor: Colors.blue,
            backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.white: Colors.white54,
            onPressed: ()
            {
              Navigator.of(context).pop();
            }),
        ),
    ),
    );
  }

}


//desaparece keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}


