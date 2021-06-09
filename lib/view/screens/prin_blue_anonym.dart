import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'package:myBlueAd/view/widgets/home_forms_widget.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';

class PrinBlueAnonym extends StatefulWidget {
  @override
  _PrinBlueAnonymState createState() => _PrinBlueAnonymState();
}

class _PrinBlueAnonymState extends State<PrinBlueAnonym> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final Duration initialDelay = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>
        [
          DelayedDisplay(
            delay: initialDelay,
            child: Text(
              "Welcome,", textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blueAccent,
              ),
            ),
          ),
          userstate.user.phoneNumber != null ?
          DelayedDisplay(
            delay: Duration(seconds: initialDelay.inSeconds + 1),
            child: Text(
              "${userstate.user.phoneNumber}!",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blueAccent,
              ),
            ),
          ) : Container(height: 0, width: 0),
          SizedBox(height: 120),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DelayedDisplay(
                    delay: Duration(
                        seconds: initialDelay.inSeconds + 2),
                    child: Image.asset(
                        "assets/logo_store.png", width: 80)
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DelayedDisplay(
                    delay: Duration(seconds: initialDelay
                        .inSeconds + 2),
                    child: Text(
                      "myBlueStore",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ]
          ),
          SizedBox(
            height: 30.0,
          ),
          DelayedDisplay(
            delay: Duration(seconds: initialDelay.inSeconds + 3),
            child: Center(
              child: Text("Waiting for blue ads...",
                style: TextStyle(fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),),
            ),
          ),
          //todo cambiar que este esperando hasta que le llegue uid
          DelayedDisplay(
            delay: Duration(seconds: initialDelay.inSeconds + 3),
            child: Center(
              child: Lottie.asset(
                  'assets/2727-qimtronics.json', width: 200, height: 180),
            ),
          ),
          //SizedBox(height: 30),
        ],),
    );
  }
}

class RegisterAnonym extends StatefulWidget {
  @override
  _RegisterAnonymState createState() => _RegisterAnonymState();
}

class _RegisterAnonymState extends State<RegisterAnonym> {
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
    return GestureDetector(
      onTap: ()=> hideKeyboard(context),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: RegisterAnonymForm(formKey: _formKey, email: _email, password: _password, password2: _password2, username: _username),
      ),
    );
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}

class RegisterAnonymForm extends StatefulWidget {
  RegisterAnonymForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required TextEditingController password,
    @required TextEditingController password2,
    @required TextEditingController username,

  }) : _formKey = formKey,_email = email, _password = password, _password2 = password2, _username=username;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final TextEditingController _password;
  final TextEditingController _password2;
  final TextEditingController _username;

  @override
  _RegisterAnonymFormState createState() => _RegisterAnonymFormState();
}
//ad widgetbinding observer
class _RegisterAnonymFormState extends State<RegisterAnonymForm> with WidgetsBindingObserver {
  bool _check=false;
  bool _visible=false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget._email.dispose();
    widget._username.dispose();
    widget._password2.dispose();
    widget._password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget._formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: Text("Become a blue user", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
                ),),
              ),
              myFormField(controller: widget._username, icon: Icon(Icons.account_circle), label: "Username", validate: validateUsername, type: TextInputType.text),
              myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
              myFormField(controller: widget._password, icon: Icon(Icons.lock), label: "Password", validate: validatePwd, type: TextInputType.visiblePassword),
              myFormField(controller: widget._password2, icon: Icon(Icons.lock), label: "Repeat password", validate: validatePwd2, type: TextInputType.visiblePassword),
              //registrandose
              if (Provider.of<UserState>(context, listen:false).status == Status.Authenticating)
                Center(child: CircularProgressIndicator()) else
              //no hay ningun usuario logeado todavia, por lo que no le muestra directamente su pagina
                if (Provider.of<UserState>(context, listen:false).status== Status.Unauthenticated || Provider.of<UserState>(context, listen:false).user.email==null)
                  Row(
                    children:<Widget>
                    [Checkbox
                        (
                        value: _check,
                        activeColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent: Theme.of(context).primaryColor,
                        onChanged: (value)
                        {
                          setState(() {
                            _check=value;
                          });
                        },
                      ),
                      Text("I agree with terms and conditions", style: TextStyle( fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent: Theme.of(context).primaryColor,
                      ),),
                    ],
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(
                    Icons.login,),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate() && _check==true) {
                      setState(() {
                        _visible=false;
                      });
                      String e = await Provider.of<UserState>(context, listen:false).signinAnonymtoUser(widget._email.text,
                          widget._password.text, widget._username.text);
                      if (e != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Log in failed with: ${e}.", context));
                      }
                      else {
                        widget._formKey.currentState.save();
                          Navigator.of(context).pushNamed("/userhome");
                      }
                    } else if (!_check)
                      setState(() {
                        _visible=true;
                      });
                  },
                  gradient: Gradients.jShine,
                  shadowColor: Gradients.jShine.colors.last.withOpacity(
                      0.25),
                ),
              ),
              Visibility(
                visible: _visible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text("To continue you must agree with terms and conditions.", style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent: Theme.of(context).primaryColor,
                  ),),
                ),
              )
            ],
          ),)
        ,),
    );
  }
  String validatePwd2 (String value)
  {
    if (value.isEmpty)
      return 'Please enter a password.';
    if (value!= widget._password.text)
      return 'Passwords do not match.';

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushNamed('/userhome');
    }
  }
}
