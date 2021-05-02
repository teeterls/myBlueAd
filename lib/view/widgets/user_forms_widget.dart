import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import '../../model/user.dart';
import '../../model/theme_model.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;
//bbdd
import '../../services/firestore_db_user.dart' as db;
import '../../services/firebase_storage.dart' as storage;
import 'custom_snackbar.dart';

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
    @required String url
  }): _formKey=formKey, _usuario=usuario, _email=email, _username=username, _name=name, _surname=surname, _address=address, _age=age, _phone=phone, _country=country, _city=city, _state=state, _url=url;

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
  final String _url;

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> with WidgetsBindingObserver {
  //img picker
  final ImagePicker _picker = ImagePicker();
  PickedFile _image;
  String _error;
  bool _picked;


  String _countryValue = "";
  String _stateValue = "";
  String _cityValue = "";
  String _genderValue;
  String _mstatusValue;

  List <String> _gender =
  [
    "Male",
    "Female",
    "Other",
    "No answer"
  ];
  List <String> _maritalstatus =
  [
    "Single",
    "Married",
    "Widowed",
    "Divorced",
    "Separated",
    "Registered partnership",
    "Other",
    "No answer"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _picked=false;
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
  Widget build(BuildContext context){
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
              Center(
                child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.tealAccent: Theme.of(context).primaryColor,
                      child: widget._url!=null && _picked==false ?  ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          widget._url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        )) : _picked==true && _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(_image.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
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
              SizedBox(height:20),
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
                      widget._formKey.currentState.save();
                      String e= await _updateProfile();
                      //todo metodo upload picker si la imagen en distinta de null
                      if (_image!=null)
                        {
                          //Provider.of<UserState>(context, listen:false).user.updateProfile(photoURL: _image.path);
                          String uid= Provider.of<UserState>(context, listen:false).user.uid;
                            await storage.uploadUserImage(File(_image.path),uid);
                         await db.setPhotoURL(uid, await storage.downloadUserImage(uid));
                        }
                      else if (_image==null && _picked==true)
                        {
                          //todo metodos delete en firestore y storage
                          String uid= Provider.of<UserState>(context, listen:false).user.uid;
                          await storage.deleteUserImage(uid);
                          await db.deletePhotoURL(uid);
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  "Delete profile photo succesfully", context));
                        }
                      if (e!=null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  "Update profile failed with: ${e}", context));
                        }
                      else
                        //se le envia a algun sitio?
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  "Your user profile has been updated succesfully :)", context));
                        }

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

  _imgFromCamera() async {

    PickedFile image = await _picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _picked=true;
      _image = image;
    });
  }

  _imgFromGallery() async {
    PickedFile image = await  _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _picked=true;
      _image = image;
    });
  }

  _deleteImg() {
    setState(() {
      _picked=true;
      _image=null;
    });
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
        setState(() {
          _image = response.file;
        });
      }
    else {
      _error = response.exception.code;
    }
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child:  Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                   ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                   ListTile(
                      leading: new Icon(Icons.delete, color: Colors.red,),
                      title: new Text('Delete photo', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      onTap: () {
                        _deleteImg();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        }
    );
  }

  Future <String> _updateProfile() async
  {
    try
        {
          String uid= Provider.of<UserState>(context, listen:false).user.uid;
          Usuario usuario= Usuario(uid, email: widget._email.text);
          //comprobar todos los campos-> "" es vacio VIP
          if (widget._username.text!="")
            usuario.username= widget._username.text;
          else
            usuario.username=null;

          if (widget._name.text!="")
            usuario.name= widget._name.text;
          else
            usuario.name=null;

          if (widget._surname.text!="")
            usuario.surname= widget._surname.text;
          else
            usuario.surname=null;

          if (widget._age.text!="")
            usuario.age= int.parse(widget._age.text);
          else
            usuario.age=null;

          if (widget._phone.text!="")
            usuario.phonenumber= int.parse(widget._phone.text);
          else
            usuario.phonenumber=null;

          if (widget._city.text!="")
            usuario.city= widget._city.text;
          else
            usuario.city=null;

          if (widget._address.text!="")
            usuario.address= widget._address.text;
          else
            usuario.address=null;

          //countryvalue -> se copia en el formfield
          if (widget._country.text!="")
            usuario.country= widget._country.text;
          else
            usuario.country=null;

          //statevalue -> se copia en el formfield
          if (widget._state.text!="")
            usuario.state= widget._state.text;
          else
            usuario.state=null;

          //gendervalue distinto al hint
          if (_genderValue!="Gender" || _genderValue!="No answer" )
            usuario.gender=_genderValue;
          else
            usuario.gender=null;

          //mstatusvalue distinto al hint
            if (_mstatusValue!="Marital status" || _mstatusValue!="No answer")
              usuario.maritalstatus=_mstatusValue;
            else
              usuario.maritalstatus=null;

            String e= await db.updateUser(uid, usuario);
            return e;

        } catch (e)
    {
      return e.toString();
    }
  }

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



