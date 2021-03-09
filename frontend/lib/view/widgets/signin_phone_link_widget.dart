import 'package:flutter/material.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/screens/sign_log_in_screen.dart';
import 'package:frontend/view/widgets/home_forms_widget.dart';
import 'package:provider/provider.dart';


import 'custom_appbar.dart';
import 'custom_backbutton.dart';
import 'custom_drawer.dart';
class SignInPhoneLink extends StatefulWidget {
  //parametro que le llega de la clase nombrada (lo añadimos al constructor) -> phone o link
  final String _option;
  SignInPhoneLink(this._option);

  @override
  _SignInPhoneLinkState createState() => _SignInPhoneLinkState();
}

class _SignInPhoneLinkState extends State<SignInPhoneLink> {

  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneNumberController;
  TextEditingController _smsController;
  TextEditingController _emailController;


  @override
  void initState() {
    super.initState();
    //vacios
    _phoneNumberController = TextEditingController(text: "");
    _smsController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldkey,
          drawer: CustomDrawer(),
          appBar: CustomAppBar(_scaffoldkey, context),
          body: SingleChildScrollView(
          child: GestureDetector(
          onTap: ()=> hideKeyboard(context),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: widget._option=="Phone" ? SignInPhoneForm(formKey: _formKey, phone: _phoneNumberController, smsCode: _smsController) : SignInLinkForm(formKey: _formKey, email: _emailController),
            ),
          ),
          ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }
}
