
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import '../screens/sign_log_in_screen.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'custom_snackbar.dart';
import 'home_forms_widget.dart';
import 'custom_appbar.dart';
import 'custom_backbutton.dart';
import 'custom_drawer.dart';
class SignInPhoneLink extends StatefulWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor) -> phone o link
  final String _option;
  SignInPhoneLink(this._option);

  @override
  _SignInPhoneLinkState createState() => _SignInPhoneLinkState();
}

class _SignInPhoneLinkState extends State<SignInPhoneLink> {

  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneNumberController;
  TextEditingController _smsController;
  TextEditingController _emailController;


  @override
  void initState() {
    super.initState();
    //vacios
    _phoneNumberController = TextEditingController(text: "");
    _smsController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
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
                child: widget._option=="Phone" ? SignInPhoneForm(formKey: _formKey, phone: _phoneNumberController, smsCode: _smsController) : SignInLinkForm(formKey: _formKey, email: _emailController),
              ),
            ),
            ),
          floatingActionButton: CustomBackButton(),
        ),
      ),
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
  String _verificationId;

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
              myFormField(controller: widget._phone, icon: Icon(Icons.phone), label: "Phone (+34)", validate: validatePhone, type: TextInputType.phone),
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
                            String e = await Provider.of<UserState>(context, listen:false).verifyPhoneNumber(widget._phone.text);
                            print(e);
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
                        },
                        gradient: Gradients.hotLinear,
                        shadowColor: Gradients.hotLinear.colors.last
                            .withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ),
              myFormField(controller: widget._smsCode, icon: Icon(Icons.sms), label: "Verification code", validate: validateSMSCode, type: TextInputType.number),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(Icons.login),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate()) {
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

//Observer to detect when the system puts the app in the background or returns the app to the foreground
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
                    myFormField(controller: widget._email, icon: Icon(Icons.email), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      //TODO METODO handle deep links
      String e = await Provider.of<UserState>(context, listen: false).getInitialLink(widget._email.text);
      if (e != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
                "Sending email with the link to sign in failed, enter a valid user email ${e}",
                context));
      }
      else {
        //ok
        Navigator.of(context).pushNamed('/userhome');
      }
    }
  }
}


//TODO PHONE INTERNACIONAL
//phone -> max 15 digitos UIT estandar con prefijo internacional. no entramos en mas detalle porque eso lo hará firebase.
String validatePhone(String value) {
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
String validateSMSCode(String value) {
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

