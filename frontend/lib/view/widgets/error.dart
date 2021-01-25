import 'package:flutter/material.dart';
//error widget
class Error extends StatelessWidget {
  //error msg
 final String _error;
  Error(this._error);

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
