import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/theme_model.dart';
import '../../services/user_state_auth.dart';
import 'custom_snackbar.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    //autenticado o no? -> nos enseña un drawer u otro
    List <Widget> _options;
    if (userstate.status == Status.Unauthenticated) {
      _options = <Widget>[
        myDrawerHeader(),
        myListTile(label: "About", icondata: Icons.info),
        myListTile(label: "Security", icondata: Icons.security),
        myListTile(label: "Faq", icondata: Icons.help),
      ];
    } else if (userstate.status == Status.Authenticated) {
      _options = <Widget>[
        myDrawerHeader(),
        myListTile(label: "About", icondata: Icons.info),
        myListTile(label: "Help", icondata: Icons.help),
        if (userstate.user.email!=null)
        myListTile(label: "Settings", icondata: Icons.settings),
        //sign out distinto
        ListTile(
          onTap: () => _showSignOutDialog(context),
          title: Text("Sign out"),
          leading: Icon(Icons.logout,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor),
        ),
      ];
    }

    return Container(
      width: 220,
      child: Drawer(
        child: GestureDetector(
          onTap: () {

          },
          child: ListView.separated(
              itemCount: _options.length,
              itemBuilder: (context, index) => _options[index],
              separatorBuilder: (context, index) =>
                  Divider(
                      height: 1,
                      //inicio y fin de la linea
                      indent: 15,
                      endIndent: 15)
          ),
        ),
      ),
    );
  }

  Future _showSignOutDialog(BuildContext context) async {
    if (Platform.isAndroid)
    {
      return showDialog(
        context: context,
        builder: (_) => _buildAndroidAlertDialog(context),
      );

    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _buildiOSAlertDialog(context),
      );
    }
  }

  Widget _buildAndroidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text('Do you want to sign out?', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
          ]
      ),
      content:
        Provider.of<UserState>(context, listen: false).user.email!=null?
      Text("All your info & fav blue ads will be saved! Goodbye! :)",textAlign: TextAlign.justify, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w400)):Text("Goodbye! :)",textAlign: TextAlign.justify, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w400)),
      actions: [
        OutlinedButton(
          child:Text('Sign out'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.lightBlue,
            elevation: 2,
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
            },
          onLongPress: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
        ),
        OutlinedButton(
          child:Text('Not yet'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.grey,
            elevation: 2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildiOSAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text('Do you want to sign out?', style: TextStyle(color: Provider
                .of<ThemeModel>(context, listen: false)
                .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                .of(context)
                .primaryColor)),
          ]
      ),
      content:
      Provider.of<UserState>(context, listen: false).user.email!=null?
      Text("All your info & fav blue ads will be saved! Goodbye! :)",textAlign: TextAlign.justify, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w400)):Text("Goodbye! :)",textAlign: TextAlign.justify, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w400)),
      actions: [
        OutlinedButton(
          child:Text('Sign out'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.lightBlue,
            elevation: 2,
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
          onLongPress: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(Provider.of<UserState>(context, listen: false)
                .user
                .email != null ? '${Provider.of<UserState>(context, listen: false)
                .user
                .email} has succesfully signed out' :Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber != null
                ? '${Provider.of<UserState>(context, listen: false)
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            //todo dialog signout
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
        ),
        OutlinedButton(
          child:Text('Not yet'),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.white,
            backgroundColor: Colors.grey,
            elevation: 2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class myListTile extends StatefulWidget {
  const myListTile({
  Key key,
  @required String label,
    @required IconData icondata,
  }): _label=label, _icondata=icondata, super(key: key);

  final String _label;
  final IconData _icondata;
  @override
  _myListTileState createState() => _myListTileState();
}

class _myListTileState extends State<myListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/draweroptions', arguments: widget._label);
      },
      title: Text(widget._label),
      leading: Icon(widget._icondata,
          color: Provider
              .of<ThemeModel>(context, listen: false)
              .mode == ThemeMode.dark ? Colors.tealAccent : Theme
              .of(context)
              .primaryColor),
    );
  }
}

class myDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:100,
      child: DrawerHeader(
        margin: EdgeInsets.only(left: 4.0),
        child: Image.asset(
          "assets/logo-completo.png",
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}


