import 'package:flutter/material.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:provider/provider.dart';
import 'custom_appbar.dart';
import 'custom_backbutton.dart';
import 'custom_drawer.dart';
//error widget
class Error extends StatelessWidget {
  //error msg
 final String _error;
  Error(this._error);
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(_scaffoldKey, context),
        floatingActionButton: CustomBackButton(),
        body:Container(
          color: Colors.red,
          child: Center (
            child: Text(_error,
              style: TextStyle(color: Colors.white),
            ),
          ),),),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  //error msg
  final String _error;
  ErrorContainer(this._error);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center (
        child: Text(_error,
          style: TextStyle(color: Colors.white),
        ),
      ),

    );
  }
  }


  class ErrorScanning extends StatelessWidget {
    //error msg
    final String _error;
    ErrorScanning(this._error);
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top:180.0),
        child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center (
                  child: Padding(
                    padding: const EdgeInsets.only(left:15.0, right:15.0),
                    child: Text(_error,textAlign: TextAlign.center,
                    style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
          ),
                  ),),
                Center(child: Image.asset('assets/logo-completo.png')),
              ],

            //color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
        ),
      );
    }
  }

