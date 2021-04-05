import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/model/user.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/custom_snackbar.dart';
import 'package:myBlueAd/view/widgets/user_forms_widget.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

//TODO IMAGEPICKER
//row
//TODO BOTON RECUPERAR CONTRASEÑA
//TODO BOTON DELETE ACOUNT
//TODO MYFORMFIELDNUEVO QUE SE PUEDA DISABLE
//TODO VISIBLE COUNTRY PICKER Y BOTON
//TODO INITIAL VALUE DROPDOWNS
class ShowUpdateProfile extends StatefulWidget {
  Usuario _usuario;
  ShowUpdateProfile(this._usuario);
  @override
  _ShowUpdateProfileState createState() => _ShowUpdateProfileState();
}

class _ShowUpdateProfileState extends State<ShowUpdateProfile> {
  //keys
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _email;
  TextEditingController _username;
  TextEditingController _name;
  TextEditingController _surname;
  TextEditingController _address;
  TextEditingController _age;
  TextEditingController _phone;
  TextEditingController _city;
  TextEditingController _country;
  TextEditingController _state;

  @override
  void initState() {
    super.initState();
    //no vacio, se ha autenticado con el email
    _email = TextEditingController(text: widget._usuario.email);
    //puede que estén o no vacíos, hay que comprobarlo.
    _username= TextEditingController(text: widget._usuario.username==null ? "" : widget._usuario.username);
    _name= TextEditingController(text: widget._usuario.name==null? "" : widget._usuario.name);
    _surname= TextEditingController(text:widget._usuario.surname==null ?"" : widget._usuario.surname);
    _address= TextEditingController(text:widget._usuario.address==null ? "" : widget._usuario.address);
    _age= TextEditingController(text: widget._usuario.age==null ? "" : (widget._usuario.age).toString());
    _city= TextEditingController(text: widget._usuario.city==null ? "" : widget._usuario.city);
    _country= TextEditingController(text: widget._usuario.country==null ? "" : widget._usuario.country);
    _state= TextEditingController(text: widget._usuario.state==null ? "" : widget._usuario.state);
     _phone= TextEditingController(text: widget._usuario.phone==null? "" : (widget._usuario.phone).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: ()=> hideKeyboard(context),
          child: Card(
              elevation: 0,
              color: Colors.transparent,
              child:  UserProfileForm(formKey: _formKey,  usuario: widget._usuario, email: _email, username: _username, name: _name, surname: _surname, phone: _phone, address: _address, age: _age, state: _state, city: _city, country: _country,)
              ),
          ),
        ),
      );
    //
  }
}

//desaparece keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}

