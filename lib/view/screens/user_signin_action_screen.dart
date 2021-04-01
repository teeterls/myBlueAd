import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import '../screens/sign_log_in_screen.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_backbutton.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/home_forms_widget.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
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
      ),
    );
  }
}

//cambio de contraseña o sign in anonimo/phone -> updateanonym o resetpwd

class UserActionScreen extends StatefulWidget {

  final String _option;
  UserActionScreen(this._option);

  @override
  _UserActionScreenState createState() => _UserActionScreenState();
}

class _UserActionScreenState extends State<UserActionScreen> {
  TextEditingController _email;
  TextEditingController _pwd;
  //keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //vacio
    _email = TextEditingController(text: "");
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
                  child: widget._option=="resetpwd" ? ResetPwdForm(formKey: _formKey, email: _email) : UpdateAnonym(formKey: _formKey, email: _email, pwd: _pwd),
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

class UpdateAnonym extends StatefulWidget {

  UpdateAnonym({
    @required GlobalKey<FormState> formKey,
    @required TextEditingController email,
    @required TextEditingController pwd
  }) : _formKey = formKey, _email = email, _pwd=pwd;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _email;
  final TextEditingController _pwd;
  @override
  _UpdateAnonymState createState() => _UpdateAnonymState();
}

class _UpdateAnonymState extends State<UpdateAnonym> {
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
              Text("Update your account with an email and a password!", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.blueAccent: Theme.of(context).primaryColor,
              ),),
              myFormField(controller: widget._email, icon: Icon(Icons.mail), label: "Email", validate: validateEmail, type: TextInputType.emailAddress),
              myFormField(controller: widget._pwd, icon: Icon(Icons.lock), label: "Password", validate: validatePwd, type: TextInputType.visiblePassword),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: GradientButton(
                  child: Icon(Icons.add),
                  callback: () async {
                    //validar formulario todos los campos
                    if (widget._formKey.currentState.validate()) {
                      String e= await Provider.of<UserState>(context, listen:false).updateAnonymous(widget._email.text, widget._pwd.text);
                      if (e!=null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Updating your account failed with: ${e}", context));
                      }
                      else {
                        //update ok -> vuelve a la pagina anterior
                        widget._formKey.currentState.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                "Welcome, ${widget._email.text}. Now your preferences and favorite blue ads will be saved!",
                                context));
                        //Navigator.of(context).pushNamed('/userhome', arguments: widget._email.text);
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

