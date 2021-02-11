import 'package:flutter/material.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:frontend/view/widgets/forms_widget.dart';
import 'package:provider/provider.dart';

//se muestra primero login email-pwd
//TODO APPLE LOGIN
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _email;
  TextEditingController _password;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacios
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }
  //TODO VALIDATIONS FORM
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
              child: SignInForm(formKey: _formKey, email: _email, password: _password, userstate: userstate),
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

//TODO VALIDATOR

