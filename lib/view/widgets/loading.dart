import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:provider/provider.dart';
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

class ScanLoading extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
        child:Padding(
        padding: const EdgeInsets.only(top:180.0),
         child:Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Waiting for blue ads...",textAlign: TextAlign.center,
                style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height:40),
            Center (
              child: CircularProgressIndicator()),
            SizedBox(height:20),
            Center(child: Image.asset('assets/logo-completo.png')),
          ],
        ),
        //color: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,

      ),
    );
  }
}

