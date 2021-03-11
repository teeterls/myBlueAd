import 'package:flutter/material.dart';
import 'package:frontend/model/user_state_auth.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_snackbar.dart';
import 'package:frontend/view/widgets/user_custom_drawer.dart';
import 'package:provider/provider.dart';

//TODO LOGICA PAGINA DE INICIO USUARIO CUANDO ENTRA
//TODO BOTON RUEDA SETTINGS PARA CAMBIAR PERFIL O BORRARLO -> delete auth
//TODO REAUTHENTICATING USER
//TODO DISTINGUIR SI ES ANONIMO O NO PARA NO MOSTRARLE LO MISMO -> hacer mejor con email
class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //userstate para controlar estados TODO CAMBIAR ESTO
    final userstate = Provider.of<UserState>(context);
    return SafeArea(
        child: Scaffold(
          drawer: UserCustomDrawer(),
         body: Column(
      children: <Widget> [
        //TODO WIDGET USER
          (userstate.user.email!=null) ? Text(' Welcome ${userstate.user.email}') : Text("hola anonimo") ,
          TextButton(
            child: Text('sign out'),
              onPressed: () {
              //anonimo o no
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(userstate.user.email!=null ?'${userstate.user.email} has succesfully signed out' : userstate.user.phoneNumber!=null ?'${userstate.user.phoneNumber} has succesfully signed out': 'Signed out succesfully', context));
                Provider.of<UserState>(context, listen:false).signOut();
                //vuelta a pagina inicio
                Navigator.of(context).pushNamed('/');
                   }
          )
      ],
    ),
          floatingActionButton: CustomBackButton(),
          bottomNavigationBar: ,
        ),);

  }
}
