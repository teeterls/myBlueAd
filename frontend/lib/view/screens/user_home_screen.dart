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
//TODO DISTINGUIR SI ES ANONIMO O NO PARA NO MOSTRARLE LO MISMO -> hacer mejor con email
class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //userstate para controlar estados
    final userstate = Provider.of<UserState>(context);
    //print(userstate.user.email);
    //anonimo
    return SafeArea(
        child:Column(
      children: <Widget> [
        (userstate.user.email!=null) ? Text(' Welcome ${userstate.user.displayName} ${userstate.user.email}') : Text("hola anonimo") ,
        TextButton(
          child: Text('sign out'),
            onPressed: () {
            //anonimo o no
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(userstate.user.email!=null ?'${userstate.user.email} has succesfully signed out' : 'Signed out succesfully', context));
              Provider.of<UserState>(context, listen:false).signOut();
              Navigator.of(context).pushNamed('/');
                 }
        )
      ],
    ),);

  }
}
