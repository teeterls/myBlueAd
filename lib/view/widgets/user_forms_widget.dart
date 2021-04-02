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
//se muestran todas las cajas para cambiar
//no hay validacion mas que email, user y contraseña, no se le obliga a rellenar ningun detalle personal.
//se necesita la contraseña
//TODO FOTO
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
    @required TextEditingController city,
  }) : _formKey = formKey,_email = email, _password2= password2, _password = password, _username=username, _name=name, _surname=surname, _address=address, _age=age, _phone=phone, _city=city;

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
  final TextEditingController _city;
  @override
  _AddProfileFormState createState() => _AddProfileFormState();
}

//email verification
class _AddProfileFormState extends State<AddProfileForm>  with WidgetsBindingObserver {
  //csc picker
  String _countryValue ="";
  String _stateValue ="";
  String _cityValue ="";
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

  bool _check;
  bool _visible;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _check=false;
    _visible=false;
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
    widget._city.dispose();
    super.dispose();
  }

//validate solo
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height:40,
                    ),
                    Container(
                        width:230,
                        child: myFormField(controller: widget._username, icon: Icon(Icons.account_circle), label: "Username", validate: shortvalidateUsername, type: TextInputType.text)
                    ),
                    //TODO row espacio foto y username
                  ],
                ),
                myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
                myFormField(controller: widget._password, icon: Icon(Icons.lock), label: "Password", validate: shortvalidatePwd, type: TextInputType.visiblePassword),
                myFormField(controller: widget._password2, icon: Icon(Icons.lock), label: "Repeat password", validate: validatePwd2, type: TextInputType.visiblePassword),
                  Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                  child: Text("My personal details", style: TextStyle(
                    fontFamily: "Verdana",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),),
                ),
                //no importa si estan vacías, se guarda info vacia
                //row name surname
                myFormField(controller: widget._name, icon: Icon(Icons.info), label: "Name", validate: validateName, type: TextInputType.text),
                myFormField(controller: widget._surname, icon: Icon(Icons.info), label: "Surname", validate: validateSurname, type: TextInputType.text),
                Row
                  (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                    [
                    Expanded(flex: 5,child: myFormField(controller: widget._age, icon: Icon(Icons.accessibility_new_sharp), label: "Age", validate: validateAge, type: TextInputType.number)),
                    Expanded(flex: 6,child: myFormField(controller: widget._phone, icon: Icon(Icons.phone), label: "Phone", validate: shortvalidatePhone, type: TextInputType.phone)),
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
                          flex:5,
                          child: DropdownButton<String>(
                                value: _genderValue,
                                //elevation: 5,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Provider
                                    .of<ThemeModel>(context, listen: false)
                                    .mode == ThemeMode.dark ? Colors.tealAccent : Colors.black),
                                items: _gender.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Gender",
                                  style: TextStyle(
                                      color: Provider
                                          .of<ThemeModel>(context, listen: false)
                                          .mode == ThemeMode.dark ? Colors.tealAccent : Colors.black,
                                      fontSize: 16,
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
                            flex:6,
                            child: DropdownButton<String>(
                              value: _mstatusValue,
                              //elevation: 5,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Provider
                                  .of<ThemeModel>(context, listen: false)
                                  .mode == ThemeMode.dark ? Colors.tealAccent : Colors.black),
                              items: _maritalstatus.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Marital status",
                                style: TextStyle(
                                    color: Provider
                                        .of<ThemeModel>(context, listen: false)
                                        .mode == ThemeMode.dark ? Colors.tealAccent : Colors.black,
                                    fontSize: 16,
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
                //CSC picker y text
                Column(
                  children: [
                    CSCPicker(
                      ///Enable disable state dropdown
                      showStates: true,

                      /// Enable disable city drop down -> no hay todas las ciudades
                      showCities: false,

                      ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only)
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white,
                          border: Border.all(color: Provider
                              .of<ThemeModel>(context, listen: false)
                              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                              .of(context)
                              .primaryColor, width:1)
                          ),
                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.grey.shade300, width: 1)),

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: TextStyle(color: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                          .of(context)
                          .primaryColor, fontSize: 17, fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(color: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.white : Colors.black,fontSize: 14, fontWeight: FontWeight.bold),

                      onCountryChanged: (value) {
                        setState(() {
                          _countryValue = value;
                        });
                      },
                      onStateChanged:(value) {
                        setState(() {
                          _stateValue = value;
                        });
                      },
                      onCityChanged:(value) {
                        setState(() {
                          _cityValue = value;
                        });
                      },
                    ),
                  ],
                ),
                //TODO de momento solo postal code spanish
                //row city y postal code
                Row
                  (
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>
                    [
                      //ciudad otro textfield row con address
                      Expanded(flex: 5,child: myFormField(controller: widget._city, icon: Icon(Icons.apartment_outlined), label: "City", validate: validateCity, type: TextInputType.text)),
                      Expanded(flex: 6,child: myFormField(controller: widget._address, icon: Icon(Icons.home), label: "Postal code", validate: validatePostalCode, type: TextInputType.number)),
                    ]
                ),
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
                //boton
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      child: GradientButton(
                        child: Icon(
                          Icons.person_add_alt_1_rounded),
                        callback: () async {
                          //validar formulario todos los campos
                          if (widget._formKey.currentState.validate() && _check==true) {
                           print(_stateValue);
                           print(_countryValue);
                           print(_genderValue);
                           print(_mstatusValue);
                            setState(() {
                              _visible=false;
                            });
                            widget._formKey.currentState.save();
                            //metodo registrarse nuevo -> falla? existe una cuenta ya con ese usuario
                            String e = await Provider.of<UserState>(context, listen:false).register(widget._email.text,
                                widget._password.text, widget._username.text);
                            String err = await addProfile();
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
                            String e= await addProfile();
                               if (e != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(
                                        "Adding new profile failed with: ${e}.", context));
                              }

                              widget._formKey.currentState.save();
                              Navigator.of(context).pushNamed("/userhome");
                            } }
                          else if (!_check)
                            {
                                setState(() {
                                  _visible=true;
                                });
                            }
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
                ),

              ],
            ),)
          ,),
      );
  }

Future <String> addProfile () async
  {
    print (_countryValue);
    print(_stateValue);
    try {
      String uid = Provider
          .of<UserState>(context, listen: false)
          .user
          .uid;
      //comprobamos todos los campos y creamos usuario
      Usuario _usuario = Usuario(
          uid, email: widget._email.text, username: widget._username.text);
      if (widget._name.text != "")
        _usuario.name = widget._name.text;
      else
        _usuario.name=null;
      if (widget._surname.text != "")
        _usuario.surname=widget._surname.text;
      else
        _usuario.surname=null;
      if (_genderValue!= "")
      _usuario.gender=_genderValue;
      else
        _usuario.gender=null;
    if (_mstatusValue!="")
      _usuario.maritalstatus=_mstatusValue;
    else
      _usuario.maritalstatus=null;
  //parsear movil y age
  if (Provider.of<UserState>(context, listen:false).user.phoneNumber!="")
  _usuario.phonenumber= int.parse(Provider.of<UserState>(context, listen:false).user.phoneNumber);
  else
    _usuario.phonenumber=null;
  if (widget._age.text!="")
  _usuario.age=int.parse(widget._age.text);
  else
    _usuario.age=null;
  if (_countryValue!="")
  _usuario.country=_countryValue;
  else
    _usuario.country=null;
  if (_stateValue!="")
  _usuario.state=_stateValue;
  else
    _usuario.state=null;
  if (widget._city.text!="")
  _usuario.city=widget._city.text;
  else
    _usuario.city=null;
  //TODO ADDRESS COMPLETA
  if (widget._address.text!="")
  _usuario.address=widget._address.text;
  else
    _usuario.address=null;
  print(uid);
  print(_usuario);
  //metodo bbdd
  String e = await db.registerUser(uid, _usuario);
  //si todo esta ok es null
  return e;
  } catch (e)
    {
      return e.toString();
    }
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

//open dialogo
/*class CSCButton extends StatefulWidget {
  @override
  _CSCButtonState createState() => _CSCButtonState();
}

class _CSCButtonState extends State<CSCButton> {
  String countryValue ="";
  String stateValue ="";
  String cityValue ="";
  List <String> _location;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: () {
      _showProfileLocationDialog(context);
    }, icon: Icon(Icons.), label: Text("Add location"));
  }

  Future _showProfileLocationDialog(BuildContext context) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context),
      );
    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context),
      );
    }
  }

  Widget _buildAndroidAlertDialog(BuildContext context) {
    List <String> _locationValues;
    return AlertDialog(
      scrollable:true,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text('Search your location', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
            Icon(Icons.add_location, color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor),
          ]
      ),
      content:Column(children: <Widget> [
        CSCPicker(
          ///Enable disable state dropdown
          showStates: true,

          /// Enable disable city drop down -> no estan todas las ciudades
          showCities: true,

          ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only)
          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
          dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1)),

          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.grey.shade300, width: 1)),

          ///selected item style [OPTIONAL PARAMETER]
          selectedItemStyle: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),

          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
          dropdownHeadingStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),

          ///DropdownDialog Item style [OPTIONAL PARAMETER]
          dropdownItemStyle: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.bold),

          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
            });
          },
          onStateChanged:(value) {
            setState(() {
              stateValue = value;
            });
          },
          onCityChanged:(value) {
            setState(() {
              cityValue = value;
            });
          },
        ),
        Text("$countryValue\n$stateValue\n$cityValue")
        ]),
      actions: [
        TextButton.icon(
          onPressed: () {
            _locationValues= [countryValue, stateValue, cityValue];
            Navigator.of(context).pop(_locationValues);
          },
          onLongPress: () {
            _locationValues= [countryValue, stateValue, cityValue];
            Navigator.of(context).pop(_locationValues);
          },
          icon: Icon(Icons.cancel_outlined, color: Colors.blueAccent),
          label: Text("Close", style: TextStyle(
              color: Colors.blueAccent
          )),
        ),
      ],
    );
  }

  Widget _buildiOSAlertDialog(BuildContext context) {
    String _countryValue ="";
    String _stateValue ="";
    String _cityValue ="";
    return CupertinoAlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text('Search your location', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
            Icon(Icons.add_location, color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor),

          ]
      ),
      content: CSCPicker(
        ///Enable disable state dropdown
        showStates: true,

        /// Enable disable city drop down
        showCities: true,

        ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only)
        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

        onCountryChanged: (value) {
          setState(() {
            _countryValue = value;
          });
        },
        onStateChanged:(value) {
          setState(() {
           _stateValue = value;
          });
        },
        onCityChanged:(value) {
          setState(() {
            _cityValue = value;
          });
        },
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.cancel_outlined, color: Colors.blueAccent),
          label: Text("Close", style: TextStyle(
              color: Colors.blueAccent
          )),
        ),
      ],
    );
  }
}*/

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
  Pattern pattern= r'^([a-zA-Z])*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Invalid city (only letters)';
  if (value.length>30)
    return 'City too long.';
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
