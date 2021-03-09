import 'package:flutter/material.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:frontend/view/widgets/home_forms_widget.dart';
import 'package:provider/provider.dart';

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
    //userstate para controlar estados
    final userstate = Provider.of<UserState>(context);
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
              child: widget._option=="Sign in" ? SignInForm(formKey: _formKey, email: _email, password: _password, userstate: userstate) : RegisterForm(formKey: _formKey, email: _email, password: _password, password2: _password2,userstate: userstate, username: _username),
            ),
                ),
        ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }
}


//desaparece keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}


