import 'package:flutter/material.dart';
import 'package:frontend/model/user_state.dart';
import 'package:provider/provider.dart';
//screen donde el usuario (que exista registrado) realizara cambios
//TODO para ver que cambio hacer, utiliza el provider user state. RECIBE EL ESTADO DEL USER. se ha autenticado ya o no?
//dos opciones, se ha autenticado -> cambio en el perfil, o no se ha autenticado -> cambio de contraseña

class ChangesScreen extends StatefulWidget {
  @override
  _ChangesScreenState createState() => _ChangesScreenState();
}

class _ChangesScreenState extends State<ChangesScreen> {
  @override
  Widget build(BuildContext context) {
    //userstate para controlar estados
    final userstate = Provider.of<UserState>(context);
    return SafeArea(
      //distinguir que cambio se va a hacer
      child:  (userstate.status== Status.Unauthenticated) ? Text('pwd') : Text('email'),
    );
  }
}
