import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/model/user_state.dart';
import 'package:provider/provider.dart';

//TODO LOGICA PAGINA DE INICIO USUARIO CUANDO ENTRA
class UserHomeScreen extends StatelessWidget {
  final User _user;
  UserHomeScreen(this._user);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
    Text('${_user.displayName} ${_user.email}'),
        TextButton(
          child: Text('sign out'),
            onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 1),
              content: Text(_user.email + ' has successfully signed out.'),),);
              Provider.of<UserState>(context, listen:false).signOut();
              Navigator.of(context).pushNamed('/');
                 }
        )
      ],
    );

  }
}
