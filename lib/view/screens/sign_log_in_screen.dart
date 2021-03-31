import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(_scaffoldkey, context),
        body: SingleChildScrollView(
          child: GestureDetector(
              onTap: ()=> hideKeyboard(context),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: widget._option=="Sign in" ? SignInForm(formKey: _formKey, email: _email, password: _password) : RegisterForm(formKey: _formKey, email: _email, password: _password, password2: _password2, username: _username),
            ),
                ),
        ),
        floatingActionButton: CustomBackButton(),
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


