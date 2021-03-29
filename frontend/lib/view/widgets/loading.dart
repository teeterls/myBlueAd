import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
//loadings
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center (
      child: CircularProgressIndicator(
      ),
    );
  }
}

//TODO CUSTOMIZAR LOADING GRADIENT
class BlueLoading extends StatefulWidget {
  @override
  _BlueLoadingState createState() => _BlueLoadingState();
}

class _BlueLoadingState extends State<BlueLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
      ),
    );
  }
}
