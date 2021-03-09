import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/user_state.dart';
import 'package:frontend/view/screens/sign_log_in_screen.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:frontend/view/widgets/home_forms_widget.dart';
import 'package:provider/provider.dart';
//screen donde el usuario (que exista registrado) realizara cambios
//TODO para ver que cambio hacer, utiliza el provider user state. RECIBE EL ESTADO DEL USER. se ha autenticado ya o no?
//dos opciones, se ha autenticado -> cambio en el perfil, o no se ha autenticado -> cambio de contraseña

class ChangesScreen extends StatefulWidget {
  @override
  _ChangesScreenState createState() => _ChangesScreenState();
}

class _ChangesScreenState extends State<ChangesScreen> {
  TextEditingController _email;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacio
    _email = TextEditingController(text: "");
  }
  @override
  Widget build(BuildContext context) {
    //userstate para controlar estados
    final userstate = Provider.of<UserState>(context);
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
                  child: (userstate.status== Status.Unauthenticated) ? ResetPwdForm(formKey: _formKey, email: _email) : Text('cambio de perfil'),
                ),
              ),
          ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }
}
