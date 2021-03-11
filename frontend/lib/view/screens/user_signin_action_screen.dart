import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state_auth.dart';
import 'package:frontend/view/screens/sign_log_in_screen.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_backbutton.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:frontend/view/widgets/custom_snackbar.dart';
import 'package:frontend/view/widgets/home_forms_widget.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

//screen donde el usuario con conflicto de credentials repite su contraseña. Se le puede ofrecer cambiarla si no se acuerda
class PwdCredentials extends StatefulWidget {
  final List _credentials;
  PwdCredentials(this._credentials);
  
  @override
  _PwdCredentialsState createState() => _PwdCredentialsState();
}

class _PwdCredentialsState extends State<PwdCredentials> {
  TextEditingController _pwd;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacio
    _pwd = TextEditingController(text: "");
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
               child: CredentialPwdForm(provider: widget._credentials[0], email: widget._credentials[1], formKey: _formKey, pwd: _pwd),
            ),
          ),
        ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }
}

//screen donde el usuario (que exista registrado) realizara cambios
//dos opciones, se ha autenticado -> cambio en el perfil, o no se ha autenticado -> cambio de contraseña

class UserActionScreen extends StatefulWidget {
  @override
  _UserActionScreenState createState() => _UserActionScreenState();
}

class _UserActionScreenState extends State<UserActionScreen> {
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
                  //TODO CHANGES USER
                  child: Provider.of<UserState>(context, listen:false).status== Status.Unauthenticated ? ResetPwdForm(formKey: _formKey, email: _email) : Text("changes user"),
                ),
              ),
          ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }
}

class ResetPwdForm extends StatefulWidget {
  ResetPwdForm({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
  }) : _formKey = formKey, _email = email;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;

  @override
  _ResetPwdFormState createState() => _ResetPwdFormState();
}

class _ResetPwdFormState extends State<ResetPwdForm> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget._email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget._formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Reset password with your email", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
              myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(Icons.vpn_key),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate()) {
                      if (!await Provider.of<UserState>(context, listen:false).resetPasswordWithEmail(widget._email.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Reset password failed, enter a valid user email", context));
                      }

                      else {
                        widget._formKey.currentState.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Email sent to ${widget._email.text} to reset your password",
                                context));
                        Navigator.of(context).pop(widget._email.text);
                      }
                    }
                  },
                  gradient: Gradients.jShine,
                  shadowColor: Gradients.jShine.colors.last.withOpacity(
                      0.25),
                ),
              ),
            ],
          ),),
      ),
    );
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
        //Navigator.of(context).pushNamed('/changepwd', arguments: widget._email.text);

      }
  }*/
}

/*class  ChangePwd extends StatefulWidget {
  final String _email;
  ChangePwd(this._email);

  @override
  _ChangePwdState createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  TextEditingController _pwd;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacio
    _pwd = TextEditingController(text: "");
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
              child: ChangePwdForm(formKey: _formKey, pwd: _pwd, email: widget._email),
            ),
          ),
        ),
        floatingActionButton: CustomBackButton(),
      ),
    );
  }
}*/

