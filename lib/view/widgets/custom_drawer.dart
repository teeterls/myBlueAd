import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'file:///C:/Users/teete/Documents/ICAI/TFG/myBlueAd/lib/services/user_state_auth.dart';
import 'package:frontend/view/widgets/custom_snackbar.dart';
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
        myListTile(label: "Settings", icondata: Icons.settings),
        //sign out distinto
        ListTile(
          onTap: () async {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(userstate
                .user
                .email != null ? '${userstate
                .user
                .email} has succesfully signed out' :userstate
                .user
                .phoneNumber != null
                ? '${userstate
                .user
                .phoneNumber} has succesfully signed out'
                : 'Signed out succesfully', context));
            await Provider.of<UserState>(context, listen: false).signOut();
            //vuelta a pagina inicio
            Navigator.of(context).pushNamed('/');
          },
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


