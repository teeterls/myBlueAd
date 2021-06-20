import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myBlueAd/view/screens/prin_blue_anonym.dart';
import 'package:myBlueAd/view/screens/sign_log_in_screen.dart';
import 'package:myBlueAd/view/widgets/bluetooth_modes_buttons.dart';
import 'package:myBlueAd/view/widgets/custom_backbutton.dart';
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
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  //empieza en el de en medio
  int _currentIndex = 1;
  bool _enabled;


  /*@override
  void initState() {
    Future.delayed(Duration(seconds:0)).then((value)
    async  {
      if (!await flutterBlue.isOn) {
        _enabled = false;
      }
      else {
        _enabled = true;
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen: false);
    //lista de distintos widgets a mostrar por orden!! acorde al bottombar
    //depende de si hay o no email, lo dejamos asi porque va por auth
    List<Widget> _screensuser =
    [
      UserProfile(),
      PrincipalBlue(),
      FavoriteAds(),
    ];

    List<Widget> _screensanonym =
    [
      //pagina login anonimo
      RegisterAnonym(),
      PrinBlueAnonym(),
    ];

      return WillPopScope(
        //no deja ir para atras
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(_scaffoldKey, context),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              child: userstate.user.email!=null ? _screensuser[_currentIndex] : _screensanonym[_currentIndex],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.white54 : Colors.white,
              backgroundColor: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
              onTap: _onTabTapped,
              index: _currentIndex,
              items: userstate.user.email!=null ?_getBottomItems(true) : _getBottomItems(false) ,
            ),
            floatingActionButton: StreamBuilder<BluetoothState>(
                    stream: FlutterBlue.instance.state,
                    initialData: BluetoothState.unknown,
                    builder: (c, snapshot) {
                      final state = snapshot.data;
                      if (state == BluetoothState.on) {
                        if (_currentIndex == 1) {
                          //return BeaconButton(true);
                         if (userstate.user.email!=null) {
                            return //DemoButton(true);
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Align(alignment: Alignment
                                        .bottomLeft, child: DemoButton(true)),
                                  ),
                                  Align(alignment: Alignment.bottomRight,
                                      child: ScanButton(true)),
                                ],
                              );
                          } else
                            return ScanButton(true);
                        }
                        else
                          return Container(
                            width: 0,
                            height: 0,
                          );
                      } else {
                        if (_currentIndex == 1) {
                          if (userstate.user.email!=null) {
                            return //DemoButton(false);
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Align(alignment: Alignment
                                        .bottomLeft, child: DemoButton(false)),
                                  ),
                                  Align(alignment: Alignment.bottomRight,
                                      child: ScanButton(false)),
                                ],
                              );
                          } else
                            return ScanButton(false);
                          //return BeaconButton(false);
                        }
                        else
                          return Container(
                            width: 0,
                            height: 0,
                          );
                      }
                    }

                ),
          ),
        ),
      );


    //phone o anonym ->
    /*else
      {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                appBar: CustomAppBar(_scaffoldKey, context),
                drawer: CustomDrawer(),
                body: SingleChildScrollView(
                  child: PrinBlueAnonym(),
                ),
                floatingActionButton: StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot) {
                final state = snapshot.data;
                if (state == BluetoothState.on) {
                  print("on");
                  return SpeedDial( //AddAccountButton()
                    marginEnd: 18,
                    marginBottom: 20,
                    // animatedIcon: AnimatedIcons.menu_close,
                    // animatedIconTheme: IconThemeData(size: 22.0),
                    icon: Icons.add,
                    activeIcon: Icons.close,
                    iconTheme: IconThemeData(color: Provider
                        .of<ThemeModel>(context, listen: false)
                        .mode == ThemeMode.dark ? Colors.teal : Theme
                        .of(context)
                        .primaryColor, size: 30),
                    labelTransitionBuilder: (widget, animation) =>
                        ScaleTransition(scale: animation, child: widget),
                    buttonSize: 56.0,
                    visible: true,
                    closeManually: false,
                    renderOverlay: false,
                    curve: Curves.bounceIn,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    tooltip: 'Options',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 8.0,
                    shape: CircleBorder(),
                    // orientation: SpeedDialOrientation.Up,
                    // childMarginBottom: 2,
                    // childMarginTop: 2,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.account_circle, color: Provider
                            .of<ThemeModel>(context, listen: false)
                            .mode == ThemeMode.dark ? Colors.teal : Theme
                            .of(context)
                            .primaryColor,),
                        label: "Create profile",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                        labelBackgroundColor: Provider
                            .of<ThemeModel>(context, listen: false)
                            .mode == ThemeMode.dark ? Colors.teal : Theme
                            .of(context)
                            .primaryColor,
                        onTap: () async {
                          Navigator.of(context).pushNamed(
                              '/signlogin', arguments: "Log in");
                        },
                        onLongPress: () async {
                          Navigator.of(context).pushNamed(
                              '/signlogin', arguments: "Log in");
                        },
                      ),
                      // ignore: unrelated_type_equality_checks
                      SpeedDialChild(
                        child: myBeaconButton(true),
                        //Icon(Icons.bluetooth, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.teal: Theme.of(context).primaryColor,),
                        label: "Nearby blue ads",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                        labelBackgroundColor: Provider
                            .of<ThemeModel>(context, listen: false)
                            .mode == ThemeMode.dark ? Colors.teal : Theme
                            .of(context)
                            .primaryColor,
                        //boton beacon
                      ),
                    ],
                  );
                }
                else
                  {
                  return SpeedDial( //AddAccountButton()
                    marginEnd: 18,
                    marginBottom: 20,
                    // animatedIcon: AnimatedIcons.menu_close,
                    // animatedIconTheme: IconThemeData(size: 22.0),
                    icon: Icons.add,
                    activeIcon: Icons.close,
                    iconTheme: IconThemeData(color: Provider
                        .of<ThemeModel>(context, listen: false)
                        .mode == ThemeMode.dark ? Colors.teal : Theme
                        .of(context)
                        .primaryColor, size: 30),
                    labelTransitionBuilder: (widget, animation) =>
                        ScaleTransition(scale: animation, child: widget),
                    buttonSize: 56.0,
                    visible: true,
                    closeManually: false,
                    renderOverlay: false,
                    curve: Curves.bounceIn,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    tooltip: 'Options',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 8.0,
                    shape: CircleBorder(),
                    // orientation: SpeedDialOrientation.Up,
                    // childMarginBottom: 2,
                    // childMarginTop: 2,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.account_circle, color: Provider
                            .of<ThemeModel>(context, listen: false)
                            .mode == ThemeMode.dark ? Colors.teal : Theme
                            .of(context)
                            .primaryColor,),
                        label: "Create profile",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                        labelBackgroundColor: Provider
                            .of<ThemeModel>(context, listen: false)
                            .mode == ThemeMode.dark ? Colors.teal : Theme
                            .of(context)
                            .primaryColor,
                        onTap: () async {
                          Navigator.of(context).pushNamed(
                              '/signlogin', arguments: "Log in");
                        },
                        onLongPress: () async {
                          Navigator.of(context).pushNamed(
                              '/signlogin', arguments: "Log in");
                        },
                      ),
                      // ignore: unrelated_type_equality_checks
                    ],
                  );
              }}
          )
              //custombottonnavigation bar: email o no?
            ),),);
      }*/
  }

  //cambiamos la pagina que se ve
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //segun si hay email o no
  List <Widget> _getBottomItems(bool user) {
    if (user)
    return [
      Icon(Icons.account_circle, semanticLabel: "My profile"),
      Icon(Icons.bluetooth, semanticLabel: "Blue nearby"),
      Icon(Icons.favorite, semanticLabel: "My blue ads"),
    ];
    else
      return [
        Icon(Icons.person_add_alt_1_sharp, semanticLabel: "Add profile"),
        Icon(Icons.bluetooth, semanticLabel: "Blue nearby"),
      ];
  }
}




