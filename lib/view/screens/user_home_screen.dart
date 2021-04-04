import 'package:flutter/material.dart';
import 'prin_blue_nouser.dart';
import 'prin_blue.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorite_ads_widget.dart';
import '../widgets/sign_inout_buttons_widget.dart';
import '../widgets/user_profile_widget.dart';
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
    //depende de si hay o no email, lo dejamos asi porque va por auth
    List<Widget> _screens=
    [
          UserProfile(),
          PrincipalBlue(),
          FavoriteAds(),
        ];

    if (userstate.user.email!=null)
    return WillPopScope(
      //no deja ir para atras
      onWillPop: () async => false,
      child: SafeArea(
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
          ),),
    );

    //phone o anonym
    else
      return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(_scaffoldKey, context),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              child: PrincipalBlueNoUser(),
            ),
            floatingActionButton: AddAccountButton(),
            //custombottonnavigation bar: email o no?
          ),),
      );

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
            icon: Icon(Icons.person_add),
            label:"Create profile"
        ),
        BottomNavigationBarItem(
            icon: new Icon(Icons.bluetooth),
            label: "Blue nearby"
        ),
      ];


  }
}

class AddAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
      splashColor: Colors.blue,
      hoverColor: Colors.blue,
      backgroundColor: Colors.white54,
      tooltip: "Add acount",
      onPressed: () async {
        //pagina register
        Navigator.of(context).pushNamed('/signlogin', arguments: "Log in");
      },
    );
  }
}


