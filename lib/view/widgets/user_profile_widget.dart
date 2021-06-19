import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/show_update_profile.dart';
import '../../model/user.dart';
import '../../model/theme_model.dart';
import '../../services/firestore_db_user.dart' as db;
import '../../services/user_state_auth.dart';
import 'loading.dart';
import 'error.dart';

// desde Firebase TODA LA INFOUSUARIO STREAM -> streambuilder
class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    //userstate Auth Provider
    final userstate = Provider.of<UserState>(context, listen: false);
    //print(userstate.user.uid);
    //print(db.getUserProfile(userstate.user.uid));
    if (userstate!=null)
    return StreamBuilder<Usuario>(
        stream: db.getUserProfile(userstate.user.uid),
        builder: (context, AsyncSnapshot<Usuario> snapshot) {
          //si tengo un error se muestra en el widget aparte
          if (snapshot.hasError) {
            return ErrorContainer(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return Center(child: Loading());
          }
          //hay datos del perfil del usuario identificado con el uid al sign in/register
          //

          return ShowUpdateProfile(snapshot.data);
        });
  }
}

