import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

//TODO LOGICA PAGINA DE INICIO USUARIO CUANDO ENTRA
//TODO BOTON RUEDA SETTINGS PARA CAMBIAR PERFIL O BORRARLO -> delete auth
//TODO REAUTHENTICATING USER
//TODO DISTINGUIR SI ES ANONIMO O NO PARA NO MOSTRARLE LO MISMO -> se puede hacer con displayname o con email indistintamente
class UserHomeScreen extends StatelessWidget {
  final User _user;
  UserHomeScreen(this._user);
  @override
  Widget build(BuildContext context) {
    //anonimo
    return SafeArea(
        child:Column(
      children: <Widget> [
        (_user.email!=null)? Text(' Welcome ${_user.displayName} ${_user.email}') : Text("hola") ,
        TextButton(
          child: Text('sign out'),
            onPressed: () {
            //anonimo o no
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(_user.email!=null ?'${_user.email} has succesfully signed out' : 'Signed out succesfully', context));/*SnackBar(
              duration: Duration(seconds: 1),
              content: Text(_user.email + ' has successfully signed out.'),),);*/
              Provider.of<UserState>(context, listen:false).signOut();
              Navigator.of(context).pushNamed('/');
                 }
        )
      ],
    ),);

  }
}
