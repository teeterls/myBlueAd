import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/button_builder.dart';
//se muestra primero login email-pwd
//TODO secciones para distintas opciones de login: anonimo, por numero de telf, link correo, google, facebook
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    //userstate para controlar estados
    final userstate = Provider.of<UserState>(context);
    return Scaffold(
      key: _scaffoldkey,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(_scaffoldkey, context),
      body: GestureDetector(
          onTap: () =>hideKeyboard(context),
           child:Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
                  controller: _email,
                  validator: (value) => (value.isEmpty) ? "Please Enter Email" : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                     ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
                  controller: _password,
                  validator: (value) =>
                  (value.isEmpty) ? "Please Enter Password" : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                      ),
                ),
              ),
              userstate.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
              //no hay ningun usuario logeado
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GradientButton(
                  child: Icon(Icons.login),
                  callback: () async {
                      if (_formKey.currentState.validate()) {
                        if (!await userstate.signIn(
                            _email.text, _password.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Something went wrong"),
                            duration: Duration(seconds: 1),
                          ));
                          Navigator.of(context).pushNamed('/');
                        }
                        //userhomepage con el usuario que ha se ha autenticado,
                        Navigator.of(context).pushNamed('/userhome', arguments: userstate.user);
                      }
                  },
                  gradient: Gradients.jShine,
                  shadowColor: Gradients.jShine.colors.last.withOpacity(
                      0.25),

                ),/*Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.red,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (!await userstate.signIn(
                            _email.text, _password.text))
                          _scaffoldkey.currentState.showSnackBar(SnackBar(
                            content: Text("Something is wrong"),
                          ));
                        //userhomepage con el usuario que ha se ha autenticado,
                        Navigator.of(context).pushNamed('/userhome', arguments: userstate.user);
                      }
                    },
                    child: Text(
                      "Sign In",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),*/
              ),
              //TODO secciones de distintos signin
              Row(
                children: <Widget>
                    [

                ],),
            ],
          ),
        ),
      ),),
      floatingActionButton: CustomBackButton(),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
//LOGIN USUARIO REGISTRADO
/*class LogInScreen extends StatefulWidget {
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
}*/

//desaparece keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}
