import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import '../../model/user.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import 'custom_snackbar.dart';
import 'home_forms_widget.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../../services/firestore_db.dart' as db;

//todo photo image picker

class UserProfileForm extends StatefulWidget {
  UserProfileForm({
    @required GlobalKey<FormState> formKey,
    @required Usuario usuario,
    @required TextEditingController email,
    @required TextEditingController username,
    @required TextEditingController name,
    @required TextEditingController surname,
    @required TextEditingController address,
    @required TextEditingController age,
    @required TextEditingController phone,
    @required TextEditingController city,
    @required TextEditingController country,
    @required TextEditingController state,
  }): _formKey=formKey, _usuario=usuario, _email=email, _username=username, _name=name, _surname=surname, _address=address, _age=age, _phone=phone, _country=country, _city=city, _state=state;

  final GlobalKey<FormState> _formKey;
  final Usuario _usuario;
  final TextEditingController _email;
  final TextEditingController _username;
  final TextEditingController _name;
  final TextEditingController _surname;
  final TextEditingController _address;
  final TextEditingController _age;
  final TextEditingController _phone;
  final TextEditingController _city;
  final TextEditingController _country;
  final TextEditingController _state;

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> with WidgetsBindingObserver {
  String _countryValue = "";
  String _stateValue = "";
  String _cityValue = "";
  String _genderValue;
  String _mstatusValue;

  List <String> _gender =
  [
    "Male",
    "Female",
    "Other"
  ];
  List <String> _maritalstatus =
  [
    "Single",
    "Married",
    "Widowed",
    "Divorced",
    "Separated",
    "Registered partnership",
    "Other"
  ];

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
    widget._address.dispose();
    widget._age.dispose();
    widget._phone.dispose();
    widget._city.dispose();
    widget._state.dispose();
    widget._country.dispose();
    super.dispose();
  }

  //todo
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget._formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
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
              //TODO ESPACIO FOTO Y URL

              Center(
                child: SizedBox(child: Text("FOTO"),
                  height: 60,
                ),
              ),
              myUpdateFormField(controller: widget._username,
                  icon: Icon(Icons.account_circle),
                  label: "Username",
                  validate: shortvalidateUsername,
                  type: TextInputType.text),
              EmailFormField(settings: false, controller: widget._email,
                  icon: Icon(Icons.mail),
                  label: "Email",
                  ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                child: Text("My personal details", style: TextStyle(
                  fontFamily: "Verdana",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,),),),
              myUpdateFormField(controller: widget._name,
                  icon: Icon(Icons.info),
                  label: "Name",
                  validate: validateName,
                  type: TextInputType.text),
              myUpdateFormField(controller: widget._surname,
                  icon: Icon(Icons.info),
                  label: "Surname",
                  validate: validateSurname,
                  type: TextInputType.text),
              Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    Expanded(flex: 6,
                        child: myUpdateFormField(controller: widget._age,
                            icon: Icon(Icons.accessibility_new_sharp),
                            label: "Age",
                            validate: validateAge,
                            type: TextInputType.number)),
                    Expanded(flex: 6,
                        child: myUpdateFormField(controller: widget._phone,
                            icon: Icon(Icons.phone),
                            label: "Phone",
                            validate: shortvalidatePhone,
                            type: TextInputType.phone)),
                  ]),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row
                  (
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>
                    [
                      Expanded(
                        flex: 5,
                        child: DropdownButton<String>(
                          //el genero es una de las opciones
                          value:  _genderValue,
                          //elevation: 5,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Provider
                              .of<ThemeModel>(context, listen: false)
                              .mode == ThemeMode.dark ? Colors.white : Colors
                              .black),
                          items: _gender.map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(widget._usuario.gender != null ? widget
                              ._usuario.gender :
                            "Gender",
                            style: TextStyle(
                                color: Provider
                                    .of<ThemeModel>(context, listen: false)
                                    .mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _genderValue = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: DropdownButton<String>(
                          value: _mstatusValue,
                          //elevation: 5,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Provider
                              .of<ThemeModel>(context, listen: false)
                              .mode == ThemeMode.dark ? Colors.white : Colors
                              .black),
                          items: _maritalstatus.map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(widget._usuario.maritalstatus != null ? widget
                              ._usuario.maritalstatus :
                          "Marital status",
                            style: TextStyle(
                                color: Provider
                                    .of<ThemeModel>(context, listen: false)
                                    .mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _mstatusValue = value;
                            });
                          },
                        ),
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                child: Text("My address", style: TextStyle(
                  fontFamily: "Verdana",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,),),),
              Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    Expanded(flex: 6,
                        child: CSCFormField(controller: widget._country,
                            icon: Icon(Icons.flag),
                            label: "Country",
                            validate: validateCountry,
                            type: TextInputType.text)),
                    Expanded(flex: 6,
                        child: CSCFormField(controller: widget._state,
                            icon: Icon(Icons.location_on),
                            label: "State",
                            validate: validateState,
                            type: TextInputType.text)),
                  ]),
              SizedBox(height: 20),
              //CSC picker y text
              CSCPicker(
                showStates: true,
                //no hay todas las ciudads
                showCities: false,

                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                    border: Border.all(color: Provider
                        .of<ThemeModel>(context, listen: false)
                        .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                        .of(context)
                        .primaryColor, width: 1)
                ),

                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),

                selectedItemStyle: TextStyle(color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),

                dropdownHeadingStyle: TextStyle(color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                    .of(context)
                    .primaryColor, fontSize: 17, fontWeight: FontWeight.bold),

                dropdownItemStyle: TextStyle(color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),

                onCountryChanged: (value) {
                  setState(() {
                    _countryValue = value;
                    widget._country.text = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    _stateValue = value;
                    widget._state.text = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    _cityValue = value;
                  });
                },
              ),
              //TODO de momento solo postal code spanish
              //row city y postal code
              Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    //ciudad otro textfield row con address
                    Expanded(flex: 6,
                        child: myUpdateFormField(controller: widget._city,
                            icon: Icon(Icons.apartment_outlined),
                            label: "City",
                            validate: validateCity,
                            type: TextInputType.text)),
                    Expanded(flex: 6,
                        child: myUpdateFormField(controller: widget._address,
                            icon: Icon(Icons.home),
                            label: "Postal code",
                            validate: validatePostalCode,
                            type: TextInputType.number)),
                  ]
              ),
              //boton
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(
                      Icons.person_add_alt_1_rounded),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate()) {
                      print(_stateValue);
                      print(_countryValue);
                      print(_genderValue);
                      print(_mstatusValue);
                      widget._formKey.currentState.save();
                      //todo metodo update
                      /*String e = await Provider.of<UserState>(context, listen:false).register(widget._email.text,
                           widget._password.text, widget._username.text);
                       String err = await addProfile();


                         widget._formKey.currentState.save();
                         //customsnackbar;
                       }
                       */
                    }
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
}
Future <void> updateProfile() async
{


}


//no es posible cambiarlo desde aqui, hay que ir a settings. tampoco se valida.
class EmailFormField extends StatefulWidget {
  const EmailFormField({
    @required bool settings,
    @required TextEditingController controller,
    @required Icon icon,
    @required String label,
  }): _controller=controller, _icon=icon, _label=label, _settings=settings;

  final TextEditingController _controller;
  final Icon _icon;
  final String _label;
  final bool _settings;
  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  @override
  Widget build(BuildContext context) {
    if (!widget._settings)
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex:9,
              child: TextFormField(
                //no se puede editar
                enabled: false,
                  //nos muestra el email del usuario autenticado
                  controller: widget._controller,
                  decoration: InputDecoration(
                    prefixIcon: widget._icon,
                    labelText: widget._label,
                    labelStyle: TextStyle(
                      fontSize:14,
                    ),
                  )
              ),
            ),
            Container(
              width:30,
              child: IconButton(
                  tooltip: "Go to settings",
                  onPressed: () =>Navigator.of(context).pushNamed('/draweroptions', arguments: 'Settings'),
                  icon: Icon(Icons.settings, color: Provider
                      .of<ThemeModel>(context, listen: false)
                      .mode == ThemeMode.dark
                      ? Colors.tealAccent
                      : Theme.of(context).primaryColor),
            ),),
          ]),
    );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
                  //no se puede editar
                    enabled: false,
                    //nos muestra el email del usuario autenticado
                    controller: widget._controller,
                    decoration: InputDecoration(
                      prefixIcon: widget._icon,
                      labelText: widget._label,
                      labelStyle: TextStyle(
                        fontSize:14,
                      ),
                    )
                ),
      );
  }
}

class CSCFormField extends StatefulWidget {
  const CSCFormField({
    @required TextEditingController controller,
    @required Icon icon,
    @required String label,
    @required String Function(String) validate,
    @required TextInputType type,
}): _controller=controller, _icon=icon, _label=label, _validate=validate,_type=type;

  final TextEditingController _controller;
  final Icon _icon;
  final String _label;
  final String Function(String) _validate;
  final TextInputType _type;
  @override
  _CSCFormFieldState createState() => _CSCFormFieldState();
}

class _CSCFormFieldState extends State<CSCFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:TextFormField(
                  keyboardType: widget._type,
                  cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
                  controller: widget._controller,
                  validator: widget._validate,
                  decoration: InputDecoration(
                    errorMaxLines: 10,
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
                      fontSize: 13,
                    ),
                    prefixIcon: widget._icon,
                    labelText: widget._label,
                    labelStyle: TextStyle(
                      fontSize:14,
                    ),
                    suffixIcon:
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed:() =>widget._controller.clear(),
                    ),
                  ),
              ),
            );
  }
}

//recibe controller, icono, label, validator, key type
//enable o not enable?
class myUpdateFormField extends StatefulWidget {
  const myUpdateFormField({
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
  _myUpdateFormFieldState createState() => _myUpdateFormFieldState();
}

class _myUpdateFormFieldState extends State<myUpdateFormField> {
  bool _enable;

  @override
  void initState() {
    _enable=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex:9,
              child: TextFormField(
          enabled: _enable,
                keyboardType: widget._type,
                cursorColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
                controller: widget._controller,
                validator: widget._validate,
                decoration: InputDecoration(
                  errorMaxLines: 10,
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
                    fontSize: 13,
                  ),
                  prefixIcon: widget._icon,
                  labelText: widget._label,
                  labelStyle: TextStyle(
                    fontSize:14,
                  ),
                  suffixIcon:
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed:() =>widget._controller.clear(),
                      ),
                  )
                ),
            ),
            Container(
              width:30,
              child: IconButton(
                tooltip: _enable==true? "Edit off" : "Edit field",
                  onPressed: ()
                {
                  setState(() {
                    _enable = !_enable;
                  });
                }, icon: Icon(_enable==true? Icons.edit_off : Icons.edit, color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark
                  ? Colors.tealAccent
                  : Theme.of(context).primaryColor)),
            ),
        ]),
    );
  }
}

//metodos validaciones
//username -> min  longitud 5 letras y numeros
String shortvalidateUsername(String value) {
  if (value.isEmpty)
    return 'Please enter a username.';

  Pattern pattern = r'^[a-zA-Z0-9._]{6,15}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid username (6 to 15 characters).\n'
        'Example: blue_123';
  return null;
}

//password -> MIN 1 uppercase, 1 lowercase, 1 number, 1 special character
String shortvalidatePwd(String value)
{
  if (value.isEmpty)
    return 'Please enter a password.';
  Pattern pattern= r'^(?:(?=.*?[A-Z])(?:(?=.*?[0-9])(?=.*?[-!@#$%&*()_[\]{}.?<>+=])|(?=.*?[a-z])(?:(?=.*?[0-9])|(?=.*?[-!@#$%&*()_[\]{}.?<>+=])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%^&*()_[\]{},.?<>+=]))[A-Za-zñÑ0-9!@#$%&*()_[\]{}?.<>+=-]{8,32}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Too weak password (8 to 32 characters long).\n'
        'Combine [A-Z], [a-z], [0-9] and special characters\n'
        'Example: Blue123@!';
  else
    return null;
}

String validateAge (String value)
{
  //solo numeros
  Pattern pattern= r'^([0-9])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid age (only numbers)';
  //tiene que ser digito
  if (value.isNotEmpty)
    {
      var  age= int.parse(value);
      if (age<18)
        {
          return 'Only +18 accepted.';
        }
      else
        return null;

    }
  else
    return null;
}

String validateName (String value)
{
  Pattern pattern= r'^([a-zA-Z])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid name (only letters)';
  if (value.length>15)
    return 'Name too long.';
  else
    return null;
}

String validateSurname (String value)
{
  Pattern pattern= r'^([a-zA-Z])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid surname (only letters)';
  if (value.length>30)
    return 'Surname too long.';
  else
    return null;
}

String validateCity (String value)
{
  Pattern pattern= r'^([a-zA-Z\s])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid city (only letters)';
  if (value.length>20)
    return 'City too long.';
  else
    return null;
}

String validateCountry (String value)
{
  Pattern pattern= r'^([a-zA-Z\s])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid country (only letters)';
  if (value.length>20)
    return 'Country too long.';
  else
    return null;
}

String validateState (String value)
{
  Pattern pattern= r'^([a-zA-Z\s])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid state (only letters)';
  if (value.length>20)
    return 'State too long.';
  else
    return null;
}

String validatePostalCode (String value)
{
  if (value.isNotEmpty) {
    Pattern pattern = r'^(?:0[1-9]|[1-4]\d|5[0-2])\d{3}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid postal code (only 5 numbers)';
    else
      return null;
  }
  else
    return null;
}

String shortvalidatePhone (String value)
{
  if (value.isNotEmpty) {
    Pattern pattern = r'^(\+34|0034|34)?[ -]*(6|7)[ -]*([0-9][ -]*){8}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid phone number. Only digit numbers accepted.';
    if (value.length > 15)
      return 'At most 15 digits long.';
    else
      return null;
  }
  else
    return null;
}



