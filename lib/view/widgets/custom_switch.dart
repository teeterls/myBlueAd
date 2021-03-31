import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../model/theme_model.dart';

class CustomSwitch extends StatefulWidget {
  final ThemeModel _model;

  //constructor
  CustomSwitch(this._model);
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isSwitched=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlutterSwitch(
        padding: 2.0,
        activeToggleColor: Theme.of(context).primaryColor,
        inactiveToggleColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColor,
        activeSwitchBorder: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
        activeText: "Dark",
        inactiveText: "Light",
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Color(0xFFF8E3A1),
        ),
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Color(0xFFFFDF5D),
        ),
        width: 100,
        borderRadius: 30.0,
        valueFontSize: 15.0,
        showOnOff: true,
        value: _isSwitched,
        onToggle: (value) {
//notify Listeners change in theme
          widget._model.toggleMode();
          setState(() {
            _isSwitched = value;
          });
        },
      ),
    );
  }
}

