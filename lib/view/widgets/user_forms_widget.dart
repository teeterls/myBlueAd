import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import 'custom_snackbar.dart';
import 'home_forms_widget.dart';

import 'package:provider/provider.dart';
//se muestran todas las cajas para cambiar
//no hay validacion mas que email, user y contraseña, no se le obliga a rellenar ningun detalle personal.
//se necesita la contraseña
//TODO SIGNOUT AND SIGN IN??
//TODO COUNTRY, GENDER, MARITAL STATUS picker AY FOTO
//TODO VERIFY EMAIL

class AddProfileForm extends StatefulWidget {
  AddProfileForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required TextEditingController password,
    @required TextEditingController password2,
    @required TextEditingController username,
    @required TextEditingController name,
    @required TextEditingController surname,
    @required TextEditingController address,
    @required TextEditingController age,
    @required TextEditingController phone,
  }) : _formKey = formKey,_email = email, _password2= password2, _password = password, _username=username, _name=name, _surname=surname, _address=address, _age=age, _phone=phone;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final TextEditingController _password;
  final TextEditingController _password2;
  final TextEditingController _username;
  final TextEditingController _name;
  final TextEditingController _surname;
  final TextEditingController _address;
  final TextEditingController _age;
  final TextEditingController _phone;
  @override
  _AddProfileFormState createState() => _AddProfileFormState();
}

//email verification
class _AddProfileFormState extends State<AddProfileForm>  with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget._email.dispose();
    widget._name.dispose();
    widget._username.dispose();
    widget._surname.dispose();
    widget._password.dispose();
    widget._password2.dispose();
    widget._address.dispose();
    widget._age.dispose();
    widget._phone.dispose();
    super.dispose();
  }
//validate solo
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        Form(
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
                  child: Text("My profile", style: TextStyle(
                    fontFamily: "Verdana",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),),
                ),
                //TODO row espacio foto y username
                SizedBox(
                  height:40,
                ),
                Container(
                  width:200,
                  child: myFormField(controller: widget._username, icon: Icon(Icons.account_circle), label: "Username", validate: validateUsername, type: TextInputType.text)
                ),
                myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
                myFormField(controller: widget._password, icon: Icon(Icons.lock), label: "Password", validate: validatePwd, type: TextInputType.visiblePassword),
                myFormField(controller: widget._password2, icon: Icon(Icons.lock), label: "Repeat password", validate: validatePwd2, type: TextInputType.visiblePassword),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text("My personal details", style: TextStyle(
                    fontFamily: "Verdana",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),),
                ),
                //boton
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      child: GradientButton(
                        child: Icon(
                          Icons.person_add_alt_1_rounded),
                        callback: () async {
                          //validar formulario todos los campos
                          if (widget._formKey.currentState.validate()) {
                            widget._formKey.currentState.save();
                            //TODO METODO anonimo
                            String e = await Provider.of<UserState>(context, listen:false).register(widget._email.text,
                                widget._password.text, widget._username.text);
                            if (e=="Verify")
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Please verify your email account to add your profile.", context));
                            }
                            else if (e != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(
                                      "Adding new profile failed with: ${e}.", context));
                            }
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
      ),
    ]);
  }

  String validatePwd2 (String value)
  {
    if (value.isEmpty)
      return 'Please enter a password.';
    if (value!= widget._password.text)
      return 'Passwords do not match.';

  }

  //TODO TRAS VALIDATOR. VA A HABER UN NUEVO USUARIO Y SE LE ENVIA A USERHOME
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushNamed('/userhome');
    }
  }
}
