import 'package:flutter/material.dart';
import 'package:myBlueAd/view/widgets/sign_inout_buttons_widget.dart';
import '../../model/theme_model.dart';
import '../widgets/loading.dart';
import '../../services/user_state_auth.dart';
import 'package:provider/provider.dart';

import 'custom_appbar.dart';
import 'custom_drawer.dart';

//todo anonym/phone tratamiento -> phone recuperar numero, anonym nada. solo uid
//guardar en bbdd como un register con la info que meta.
//sign in con nuevos credentials.

class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(_scaffoldKey, context),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: ,
        ),
        floatingActionButton: mySignOutButton(),
        //custombottonnavigation bar: email o no?

      ),);
  }
}
