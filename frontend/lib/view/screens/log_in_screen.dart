import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

import 'package:frontend/model/theme_model.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';

//TODO FORM LOGIN
//TODO EMAIL VERIFICATION 

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomBackButton(),
    );
  }
}
