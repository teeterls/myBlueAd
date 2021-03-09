
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/sign_in_buttons_widget.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

import 'package:sms_autofill/sms_autofill.dart';

import 'custom_snackbar.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required TextEditingController password,
    @required TextEditingController password2,
    @required TextEditingController username,
    @required this.userstate,
  }) : _formKey = formKey,_email = email, _password = password, _password2 = password2, _username=username;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final TextEditingController _password;
  final TextEditingController _password2;
  final TextEditingController _username;
  final UserState userstate;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
              myFormField(controller: widget._username, icon: Icon(Icons.account_circle), label: "Username", validate: _validateUsername, type: TextInputType.text),
              myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: _validateEmail, type: TextInputType.emailAddress),
             myFormField(controller: widget._password, icon: Icon(Icons.lock), label: "Password", validate: _validatePwd, type: TextInputType.visiblePassword),
              myFormField(controller: widget._password2, icon: Icon(Icons.lock), label: "Repeat password", validate: _validatePwd2, type: TextInputType.visiblePassword),
              //registrandose
              if (widget.userstate.status == Status.Authenticating)
                Center(child: CircularProgressIndicator()) else
              //no hay ningun usuario logeado todavia, por lo que no le muestra directamente su pagina
                if (widget.userstate.status== Status.Unauthenticated)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                    child: GradientButton(
                      child: Icon(
                          Icons.login,),
                      callback: () async {
                        //validar formulario todos los campos
                        if (widget._formKey.currentState.validate()) {
                          String e = await widget.userstate.register(widget._email.text,
                              widget._password.text);
                          if (e != null)
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                    "Log in failed with: ${e}.", context));
                          else {
                          widget._formKey.currentState.save();
                         Navigator.of(context).pushNamed("/userhome");
                          } }

                        },
                      gradient: Gradients.jShine,
                      shadowColor: Gradients.jShine.colors.last.withOpacity(
                          0.25),
                    ),
                  ),
            ],
          ),)
        ,),
    );
  }

  String _validatePwd2 (String value)
  {
    if (value.isEmpty)
      return 'Please enter a password.';
    if (value!= widget._password.text)
      return 'Passwords do not match.';

  }
}
class SignInForm extends StatefulWidget {
  SignInForm({
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget._formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: _validateEmail, type: TextInputType.emailAddress),
              myFormField(controller: widget._password, icon: Icon(Icons.lock), label: "Password", validate: _validatePwd, type: TextInputType.visiblePassword),
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
                          String e= await widget.userstate.signInEmailPwd(widget._email.text, widget._password.text);
                            if (e!=null)
                              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in failed with: ${e}.", context));
                        else {
                              //ok
                              widget._formKey.currentState.save();
                              Navigator.of(context).pushNamed("/userhome");
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
                  onPressed: () async {
                    String e= await widget.userstate.signInWithGoogle();
                    if (e!=null)
                      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in failed with: ${e}.", context));
                    else {
                      //ok
                      Navigator.of(context).pushNamed("/userhome");
                    }
                  },
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
                        String e= await widget.userstate.signinAnonymously();
                        if (e!=null)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Sign in anonymously failed: ${e}", context));
                          }
                        Navigator.of(context).pushNamed('/userhome');
                    },
                    child: Text(
                        "Sign in without an account",
                        style: TextStyle(fontSize:12, color: Colors.blue, decoration: TextDecoration.underline)),
                  ),
                  //reset pwd
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
   ResetPwdForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
  }) : _formKey = formKey, _email = email;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;

  @override
  _ResetPwdFormState createState() => _ResetPwdFormState();
}

class _ResetPwdFormState extends State<ResetPwdForm> {
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
                SizedBox(
                  height: 50,
                ),
                Text("Reset password with your email", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
                ),),
                myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: _validateEmail, type: TextInputType.emailAddress),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      child: GradientButton(
                        child: Icon(Icons.vpn_key),
                        callback: () async {
                          //validar formulario todos los campos
                          if (widget._formKey.currentState.validate()) {
                            print(widget._email.text);
                            if (!await Provider.of<UserState>(context, listen:false).resetPassword(widget._email.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Reset password failed, enter a valid user email", context));
                            }
                            else {
                              widget._formKey.currentState.save();
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

////TODO link

class SignInLinkForm extends StatefulWidget {
  //solamente necesita el email
  SignInLinkForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
  }) : _formKey = formKey, _email = email;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  @override
  _SignInLinkFormState createState() => _SignInLinkFormState();
}

class _SignInLinkFormState extends State<SignInLinkForm>  with WidgetsBindingObserver  {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget._email.dispose();
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
                SizedBox(
                  height: 50,
                ),
                Text("Sign in with an email link", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
                ),),
              myFormField(controller: widget._email, icon: Icon(Icons.email), label: "Email", validate: _validateEmail, type: TextInputType.emailAddress),
             Center(
        child:   Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: GradientButton(
            child: Icon(Icons.send),
            callback: () async {
              //validar formulario todos los campos
              if (widget._formKey.currentState.validate()) {
                String e = await Provider.of<UserState>(context, listen: false).signInWithLink(widget._email.text);
                if (e!=null)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                          "Sending email with sign in link failed, enter a valid user email ${e}", context));
                }
                else {
                  widget._formKey.currentState.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                          "Email sent to ${widget._email.text} with the link to sign in.",
                          context));
                }
              }
            },
            gradient: Gradients.jShine,
            shadowColor: Gradients.jShine.colors.last.withOpacity(
                0.25),
          ),
        ),
      )]))),
    );
  }
}
//phone

class SignInPhoneForm extends StatefulWidget {
  SignInPhoneForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController phone,
    @required TextEditingController smsCode,
  }) : _formKey = formKey, _phone = phone, _smsCode=smsCode;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _phone;
  final TextEditingController _smsCode;
  @override
  _SignInPhoneFormState createState() => _SignInPhoneFormState();
}

class _SignInPhoneFormState extends State<SignInPhoneForm> {
  //devuelve su numero de telefono actual
  final SmsAutoFill _autoFill = SmsAutoFill();

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
              SizedBox(
                height: 50,
              ),
              Text("Sign in with your phone number", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
              myFormField(controller: widget._phone, icon: Icon(Icons.phone), label: "Phone", validate: _validatePhone, type: TextInputType.phone),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GradientButton(
                        increaseWidthBy: 15.0,
                        increaseHeightBy: 10.0,
                        //get phone number
                        child: Text('Get number'),
                        callback: () async
                        {
                          //autofill numero de telefono del dispositivo
                         widget._phone.text = await _autoFill.hint;
                        },

                        gradient: Gradients.jShine,
                        shadowColor: Gradients.jShine.colors.last.withOpacity(0.25),

                      ),
                      SizedBox(width: 10),
                      GradientButton(
                        increaseWidthBy: 15.0,
                        increaseHeightBy: 10.0,
                        //verify phone number
                        child: Center(child: Text('Verify number')),
                        callback: () async {
                        //validar formulario todos los campos
                        if (widget._formKey.currentState.validate()) {
                          String e = await Provider.of<UserState>(context, listen:false).verifyPhoneNumber(widget._phone.text);
                          if (e != null)
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                    "Number verification failed with: ${e}.", context));
                          //SE HA ENVIADO EL CODIGO
                          else {
                            widget._formKey.currentState.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                    "SMS with verification code sent to ${widget
                                        ._phone.text}", context));
                          }
                        }
                        },
                        gradient: Gradients.hotLinear,
                        shadowColor: Gradients.hotLinear.colors.last
                            .withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ),
              myFormField(controller: widget._smsCode, icon: Icon(Icons.sms), label: "Verification code", validate: _validateSMSCode, type: TextInputType.number),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(Icons.login),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate()) {
                      //TODO SIGN in PHONE
                      String e = await Provider.of<UserState>(context, listen:false).signInWithPhone(widget._smsCode.text);
                      if (e != null)
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Number verification failed with: ${e}.", context));
                    //SE HA ENVIADO EL CODIGO
                    else {
                      widget._formKey.currentState.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                              "Sign in with ${widget._phone.text} phone number",
                              context));
                      //ok
                      Navigator.of(context).pushNamed("/userhome");
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


//myfield para user, email, pwd, lo que sea.
//recibe controller, icono, label, validator, key type
class myFormField extends StatefulWidget {
  const myFormField({
    Key key,
    @required TextEditingController controller,
    @required Icon icon,
    @required String label,
    @required String Function(String) validate,
    @required TextInputType type,
  }) : _type=type, _label=label, _validate=validate, _controller=controller, _icon=icon, super(key: key);

  final TextEditingController _controller;
  final Icon _icon;
  final String _label;
  final String Function(String) _validate;
  final TextInputType _type;

  @override
  _myFormFieldState createState() => _myFormFieldState();
}

class _myFormFieldState extends State<myFormField> {
  bool _obscureText;

  @override
  void initState() {
    _obscureText=true;
    super.initState();
  }


  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        keyboardType: widget._type,
        obscureText: widget._label=="Password" || widget._label=="New password" || widget._label=="Repeat password" ? _obscureText : false,
        cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
        controller: widget._controller,
        validator: widget._validate,
        decoration: InputDecoration(
          errorMaxLines: 10,
          errorStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor,
            fontSize: 13,
          ),
          prefixIcon: widget._icon,
          labelText: widget._label,
          suffixIcon: widget._label=="Password" || widget._label=="New password" || widget._label=="Repeat password" ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
          mainAxisSize: MainAxisSize.min, // added line
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: ()=> widget._controller.clear(),
            ),
            IconButton(
              icon: _obscureText ? Icon(
                  Icons.visibility) : Icon (Icons.visibility_off),
              onPressed:() =>_toggleObscureText(),
            ),
          ],
        ) :  IconButton(
            icon: Icon(Icons.clear),
            onPressed: ()=> widget._controller.clear(),
          ),
      ),
    ),);
  }
}


//TODO VALIDATOR DE TODOS LOS CAMPOS POSIBLES
// email -> format correcto
String _validateEmail(String value) {
  if (value.isEmpty)
    return 'Please enter an email.';
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Please enter a valid email.\nAccepted format: "example@mail.com".';
  else
    return null;
}

//password -> MIN 1 uppercase, 1 lowercase, 1 number, 1 special character
String _validatePwd(String value)
{
  if (value.isEmpty)
    return 'Please enter a password.';
  /*
Require the string to be 8 - 32 characters long
Allow the string to be contain A-Z, a-z, 0-9, and !@#$%^&*()_[\]{},.<>+=- characters
Require at least one character from any three of the following cases
English uppercase alphabet characters A–Z
English lowercase alphabet characters a–z
Base 10 digits 0–9
Non-alphanumeric characters ?!@#$%&*()_[]{}.<>+=-

 */
 Pattern pattern= r'^(?:(?=.*?[A-Z])(?:(?=.*?[0-9])(?=.*?[-!@#$%&*()_[\]{}.?<>+=])|(?=.*?[a-z])(?:(?=.*?[0-9])|(?=.*?[-!@#$%&*()_[\]{}.?<>+=])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%^&*()_[\]{},.?<>+=]))[A-Za-zñÑ0-9!@#$%&*()_[\]{}?.<>+=-]{8,32}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Too weak password.\n''Password must be between 8 and 32 characters long.\n'
        'Required at least one character of any three of the following cases:\n'
        'Upper case characters [A-Z]\n'
        'Lower case characters [a-z]\n'
        'Digit numbers [0-9]\n'
        'Special characters except  ~^,;:"`¨´|/¬¿¡ºª·€ \n'
        'No white spaces allowed\n\n'
        'Example: Blue123@!';
  else
    return null;
}


//username -> min  longitud 5 letras y numeros
String _validateUsername(String value) {
  if (value.isEmpty)
    return 'Please enter a username.';

Pattern pattern = r'^[a-zA-Z0-9._]{6,30}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid username.\nUsername must be between 6 and 30 characters long.\n'
    'Only allowed:\n'
        'Upper case characters [A-Z]\n'
        'Lower case characters [a-z]\n'
        'Digit numbers [0-9]\n'
    'Period (.) and underscore (_)\n'
    'No white spaces allowed\n\n'
        'Example: blue_123';
    return null;
}
//TODO PHONE INTERNACIONAL
//phone -> max 15 digitos UIT estandar con prefijo internacional. no entramos en mas detalle porque eso lo hará firebase.
String _validatePhone(String value) {
  if (value.isEmpty)
    return 'Please enter a phone number.';
  //numero español
  Pattern pattern= r'^(\+34|0034|34)?[ -]*(6|7)[ -]*([0-9][ -]*){8}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid phone number. Only digit numbers accepted.';
  if (value.length >15)
    return 'At most 15 digits long.';
  else
    return null;
}

//SMS verification code -> max 6 digitos en Firebase
String _validateSMSCode(String value) {
  if (value.isEmpty)
    return 'Please enter a verification code.';
  //solo numeros
  Pattern pattern= r'^([0-9])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid verificacion code. Only digit numbers accepted';
  if (value.length <6)
    return 'Verification code 6 digits long.';
  if (value.length >6)
    return 'At most 6 digits long.';
  else
    return null;
}
