import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:frontend/model/user_state_auth.dart';
import 'package:frontend/view/widgets/custom_appbar.dart';
import 'package:frontend/view/widgets/custom_drawer.dart';
import 'package:frontend/view/widgets/favorite_ads_widget.dart';
import 'package:frontend/view/widgets/loading.dart';
import 'package:frontend/view/widgets/sign_inout_buttons_widget.dart';
import 'package:frontend/view/widgets/user_profile_widget.dart';
import 'package:provider/provider.dart';


class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //empieza en el de en medio
  int _currentIndex=1;

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    //lista de distintos widgets a mostrar por orden!! acorde al bottombar
    //depende de si hay o no email
    List<Widget> _screens;
    if (userstate.user.email!=null)
      {
        _screens=<Widget>
        [
          UserProfile(),
          PrincipalBlue(),
          FavoriteAds(),

        ];
      }
    //phone o anonym
    else
        {
          _screens=<Widget>
          [
            UserProfile(),
            PrincipalBlue(),

          ];
        }

    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(_scaffoldKey, context),
          drawer: CustomDrawer(),
         body: SingleChildScrollView(
           child: _screens[_currentIndex],
    ),
          floatingActionButton: mySignOutButton(),
         //custombottonnavigation bar: email o no?
         bottomNavigationBar: BottomNavigationBar(
           elevation: 2.0,
            selectedItemColor: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor,
            type: BottomNavigationBarType.fixed,
           onTap: _onTabTapped,
           currentIndex: _currentIndex,
           items: _getBottomItems(userstate.user.email),
          ),
        ),);

  }

  //cambiamos la pagina que se ve
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //segun si hay email o no
  List <BottomNavigationBarItem> _getBottomItems(String email)
  {
    if (email!=null)
      return  [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label:"My profile"
        ),
        BottomNavigationBarItem(
            icon: new Icon(Icons.bluetooth),
            label: "Blue nearby"
        ),
        BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label: "My blue ads"
        ),
      ];
    else
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label:"My profile"
        ),
        BottomNavigationBarItem(
            icon: new Icon(Icons.bluetooth),
            label: "Blue nearby"
        ),

      ];


  }
}

class PrincipalBlue extends StatefulWidget {
  @override
  _PrincipalBlueState createState() => _PrincipalBlueState();
}

//TODO DETECTAR BLUETOOTH Y LOCATION
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

