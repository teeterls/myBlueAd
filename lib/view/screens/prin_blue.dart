import 'package:flutter/material.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';

class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

//TODO DETECTAR BLUETOOTH Y LOCATION
//TODO DIFERENCIAR CON ANONYM
class _PrincipalBlueState extends State<PrincipalBlue> {
  @override
  Widget build(BuildContext context) {
    //control estado, porque no se guardan anonimos o phone en la bbdd -> uid cambia cada vez.
    final userstate = Provider.of<UserState>(context, listen: false);
    if (userstate.user.email != null) {
      return  Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>
          [
            Text("Welcome to myBlueAd, ${userstate.user.email}!",  style: TextStyle(fontSize:12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            SizedBox(height:20),
            Text("Waiting for blue ads...", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            BlueLoading()
          ],),
      );
    }
    else
      return  Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>
          [
            if (userstate.user.phoneNumber!=null)
              Text("Welcome to myBlueAd, ${userstate.user.phoneNumber}!"),
            if (userstate.user.phoneNumber==null)
              Text("Welcome to myBlueAd!",  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            Text("Waiting for blue ads...", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            BlueLoading(),
            SizedBox(height:150),
            Text("Update your profile with an email account and password so your activity and preferences can persist next time you sign in. If not, when singing out they will be lost", textAlign: TextAlign.justify, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
            ButtonQuickSignIn(),
          ],),
      );


  }
}
