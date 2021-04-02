import 'package:flutter/material.dart';
import 'custom_backbutton.dart';
import 'user_forms_widget.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';

//TODO FOTO????
//en este caso se coge la contraseña para crear un usuario con auth -> credentials
//todo anonym/phone tratamiento -> phone recuperar numero, anonym nada.
//guardar en bbdd como un register con la info que meta.
//sign in con nuevos credentials.


class AddProfileScreen extends StatefulWidget {
  //recibe el numero de telefono si es que se ha registrado con phone
  String _option;
  AddProfileScreen(this._option);
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  //keys
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _password2;
  TextEditingController _username;
  TextEditingController _name;
  TextEditingController _surname;
  TextEditingController _address;
  TextEditingController _age;
  TextEditingController _phone;
  TextEditingController _city;
  //TODO DROPDOWN marital status
  //TODO RADIOTILE gender


  //phonenumber o no?
  @override
  void initState() {
    super.initState();
    //vacios
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _password2 = TextEditingController(text: "");
    _username= TextEditingController(text:"");
    _name= TextEditingController(text:"");
    _surname= TextEditingController(text:"");
    _address= TextEditingController(text:"");
    _age= TextEditingController(text:"");
    _city= TextEditingController(text:"");
    //phone?
    widget._option==null? _phone= TextEditingController(text:""): _phone= TextEditingController(text: widget._option);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(_scaffoldKey, context),
          drawer: CustomDrawer(),
          body: Scrollbar(
            child: SingleChildScrollView(
              //todo form add profile añadir nuevos
              child: GestureDetector(
                onTap: ()=> hideKeyboard(context),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: AddProfileForm(formKey: _formKey, email: _email, password: _password, password2: _password2, username: _username, name: _name, surname: _surname, address: _address, age: _age, phone: _phone, city: _city)
            ),
          ),
            ),),
          floatingActionButton: CustomBackButton(),
          //custombottonnavigation bar: email o no?

        ),),
    );
  }
}



//desaparece keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}