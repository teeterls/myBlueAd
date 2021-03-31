import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../model/theme_model.dart';
import '../../services/firestore_db.dart' as db;
import '../../services/user_state_auth.dart';
import 'loading.dart';
import 'sign_inout_buttons_widget.dart';
import 'error.dart';

//TODO TODA LA INFOUSUARIO STREAM -> streambuilder
class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    //userstate Auth Provider
    final userstate = Provider.of<UserState>(context, listen: false);
    print(userstate.user.uid);
    print(db.getUserProfile(userstate.user.uid));

    return StreamBuilder<Usuario>(
        stream: db.getUserProfile(userstate.user.uid),
        builder: (context, AsyncSnapshot<Usuario> snapshot) {
          //si tengo un error se muestra en el widget aparte
          if (snapshot.hasError) {
            return Error(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Loading();
          }

          //hay datos
          //stack permite meter widgets encima de otros, muy util para los fondos.
          return Text(snapshot.data.lastaccess.toString());
        });
  }
}

