import 'package:flutter/material.dart';
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
    return /*SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(_scaffoldKey, context),
        floatingActionButton: CustomBackButton(),
        //TODO
        body: */Container(
          color: Colors.red,
          child: Center (
            child: Text(_error,
              style: TextStyle(color: Colors.white),
            ),
          ),

    );
  }
}
