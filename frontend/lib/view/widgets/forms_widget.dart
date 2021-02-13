import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/sign_in_buttons_widget.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

import 'custom_snackbar.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required TextEditingController password,
    @required this.userstate,
  }) : _formKey = formKey, _email = email, _password = password;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final TextEditingController _password;
  final UserState userstate;


  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              EmailField(email: widget._email),
              PwdField(password: widget._password, pwd: "Password"),
              if (widget.userstate.status == Status.Authenticating)
                Center(child: CircularProgressIndicator()) else
              //no hay ningun usuario logeado todavia, por lo que no le muestra directamente su pagina
                if (widget.userstate.status== Status.Unauthenticated)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                    child: GradientButton(
                      child: Icon(Icons.login),
                      callback: () async {
                        //validar formulario todos los campos
                        if (widget._formKey.currentState.validate()) {
                            if (!await widget.userstate.signInEmailPwd(widget._email.text, widget._password.text))
                              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in failed", context));
                        else
                          //ok
                         Navigator.of(context).pushNamed("/userhome");
                        }
                      },
                      gradient: Gradients.jShine,
                      shadowColor: Gradients.jShine.colors.last.withOpacity(
                          0.25),
                    ),
                  ),
              SizedBox(
                height:50,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SigninButtons(),
              ),
              Center(
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height:10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  TextButton(
                    //anonimo
                    onPressed:() async {
                      try {
                        await widget.userstate.signinAnonymously();
                        Navigator.of(context).pushNamed('/userhome', arguments: widget.userstate.user);
                      } catch(e)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in anonymously failed", context));
                      }
                    },
                    child: Text(
                        "Sign in without an account",
                        style: TextStyle(fontSize:12, color: Colors.blue, decoration: TextDecoration.underline)),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pushNamed('/changes').then((result)
                            {
                            setState(() {
                          if (result!=null) {
                            widget._email.text = result;
                          }
                        });
                      });
                            }catch(e)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Reset password failed", context));
                      }
                    },
                    child: Text(
                        "I forgot my password",
                        style: TextStyle(fontSize:12, color: Colors.blue, decoration: TextDecoration.underline)),
                  ), ],),
            ],
          ),)
        ,),
    );
  }
}

class ResetPwdForm extends StatefulWidget {
  const ResetPwdForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required this.userstate,
  }) : _formKey = formKey, _email = email;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final UserState userstate;

  @override
  _ResetPwdFormState createState() => _ResetPwdFormState();
}

class _ResetPwdFormState extends State<ResetPwdForm> {
  bool _visible;

  @override
  void initState() {
    _visible=false;
    super.initState();
  }
  //visible sign in or not with state change
  void _signinvisible (bool visibility)
  {
    setState(() {
      _visible=visibility;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget._formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text("Reset password with your email", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
                ),),
                EmailField(email: widget._email),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      child: GradientButton(
                        child: Icon(Icons.vpn_key),
                        callback: () async {
                          //validar formulario todos los campos
                          if (widget._formKey.currentState.validate()) {
                            print(widget._email.text);
                            if (!await widget.userstate.resetPassword(widget._email.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Reset password failed", context));
                              _signinvisible(false);
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Email sent to ${widget._email.text} to reset your password",
                                      context));
                              Navigator.of(context).pop(widget._email.text);
                            }
                          }
                        },
                        gradient: Gradients.jShine,
                        shadowColor: Gradients.jShine.colors.last.withOpacity(
                            0.25),
                      ),
                    ),
              ],
            ),),
      ),
    );
  }
}

//emailfield
class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
    @required TextEditingController email,
  }) : _email = email, super(key: key);


  final TextEditingController _email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
        controller: _email,
        validator: (value) => (value.isEmpty) ? "Please enter an email" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: "Email",
          suffixIcon: IconButton(
            iconSize: 20.0,
            onPressed: () => _email.clear(),
            icon: Icon(Icons.clear),
          ),
        ),
      ),);
  }
}

//pwd field
class PwdField extends StatelessWidget {
  const PwdField({
    Key key,
    @required TextEditingController password, @required String pwd
  }) : _password = password, _pwd = pwd, super(key: key);

  final TextEditingController _password;
  final String _pwd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        obscureText: true,
        cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
        controller: _password,
        validator: (value) =>
        (value.isEmpty) ? "Please enter a password" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: _pwd,
          suffixIcon: IconButton(
            iconSize: 20.0,
            onPressed: () => _password.clear(),
            icon: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}


//TODO VALIDATOR DE TODOS LOS CAMPOS POSIBLES
// email

//password

//username

//mobile