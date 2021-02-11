import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/sign_in_buttons_widget.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

import 'custom_snackbar.dart';

class SignInForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
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
                ),),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
                  controller: _password,
                  validator: (value) =>
                  (value.isEmpty) ? "Please enter a password" : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      iconSize: 20.0,
                      onPressed: () => _password.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              if (userstate.status == Status.Authenticating)
                Center(child: CircularProgressIndicator()) else
              //no hay ningun usuario logeado todavia, por lo que no le muestra directamente su pagina
                if (userstate.status== Status.Unauthenticated)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                    child: GradientButton(
                      child: Icon(Icons.login),
                      callback: () async {
                        //validar formulario todos los campos
                        if (_formKey.currentState.validate()) {
                          try
                          {
                            await userstate.signInEmailPwd(_email.text, _password.text);
                            try
                            {
                              //verificacion email 2FA la primera vez que accede
                              await userstate.user.sendEmailVerification();
                              if (userstate.user.emailVerified)
                                //userhomepage con el usuario que ha se ha autenticado,
                                Navigator.of(context).pushNamed('/userhome', arguments: userstate.user);
                            }catch (e)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Email verification failed", context));
                              Navigator.of(context).pushNamed('/');
                            }
                          } catch (e)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in failed", context));
                            Navigator.of(context).pushNamed('/');
                          }

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
                        await userstate.signinAnonymously();
                        Navigator.of(context).pushNamed('/userhome', arguments: userstate.user);
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
                    //TODO I FORGOT MY PASSWORD in
                    onPressed: () async {
                      try {

                      } catch(e)
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




//TODO VALIDATOR