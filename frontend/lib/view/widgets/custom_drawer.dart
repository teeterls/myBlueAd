import 'package:flutter/material.dart';
import 'package:frontend/model/theme_model.dart';
import 'package:provider/provider.dart';

//TODO JUNTAR TODA LA LOGICA CUSTOMDRAWER
class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _option=null;

  @override
  Widget build(BuildContext context) {

    //lista de opciones del drawer
    final List <Widget> homeoptions =<Widget> [
      Container(
        height: 100,
        child: DrawerHeader(
          margin: EdgeInsets.only(left:4.0),
          child: Image.asset(
            "assets/logo-completo.png",
            alignment:Alignment.centerLeft,
          ),
        ),
      ),
      ListTile(
        onTap: ()
        {
          Navigator.of(context).pushNamed('/about');
        },
        title: Text('About us'),
        leading: Icon(Icons.info,
            color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor),
      ),
      ListTile(
        onTap: ()
        {
          _option="security";
          Navigator.of(context).pushNamed('/homeoptions', arguments: _option);
        },
        title: Text('Security'),
        leading: Icon(Icons.security,
        color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor),
      ),
      ListTile(
        onTap: ()
        {
          _option="faq";
          Navigator.of(context).pushNamed('/homeoptions', arguments: _option);
        },
        title: Text('FAQ'),
        leading: Icon(Icons.help,
            color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.yellow : Theme.of(context).primaryColor),
      ),
    ];

    return Container(
      width: 220,
      child: Drawer(
          child: GestureDetector(
            onTap: ()
            {

            },
            child: ListView.separated(
                itemCount: homeoptions.length,
                itemBuilder: (context, index) => homeoptions[index],
            separatorBuilder: (context, index)=> Divider(
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

