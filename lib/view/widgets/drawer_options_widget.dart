
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:myBlueAd/model/theme_model.dart';
import 'package:myBlueAd/services/user_state_auth.dart';
import 'package:myBlueAd/view/widgets/settings_widget.dart';
import 'package:provider/provider.dart';
import 'custom_appbar.dart';
import 'custom_backbutton.dart';
import 'custom_snackbar.dart';
import 'error.dart';

import 'custom_drawer.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerOptionsWidget extends StatelessWidget {

  //parametro que le llega de la clase nombrada (lo añadimos al constructor)
  final String _option;

  DrawerOptionsWidget(this._option);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: CustomDrawer(),
            appBar: CustomAppBar(_scaffoldKey, context),
            floatingActionButton: CustomFavBackButton(),
            body: Scrollbar(child: SingleChildScrollView(child: _drawerOptionWidget(_option, context))),
          ),
    );
  }
}

Widget _drawerOptionWidget (String option, BuildContext context)
{
  switch (option) {
    case "About":
      return AboutSection();
      break;

    case "Security":
      return SecuritySection();
      break;

    case "Faq":
      return FaqSection();
      break;

  //no anonimo
    case "Help":
      return HelpSection();
      break;

  //usuario registrado
    case "Settings":
      return UserSettings();
      break;

    default:
      return Error("Something happened, return to homepage.");
  }
}
//ambos
class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Text("About", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("myBlueAd is a new way to connect customers and retail stores and to achieve the best customer experience.", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text(" With our mobile app, users have access to special offers or discounts that the retail stores want to share to their loyal clientels. \n\nDo you want to know how?", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          SizedBox(height:20),
          //TODO ROW CON BOTONES HELP FAQ SECURITY
          if (userstate.status == Status.Authenticated)
            Center(child:OutlinedButton(
              child:Text('Help'),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.white,
                backgroundColor: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                    .of(context)
                    .primaryColor,
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Help");
              },
              onLongPress: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Help");
              },
            ),),
          if (userstate.status == Status.Unauthenticated || userstate.status == Status.Authenticating || userstate.status == Status.Uninitialized)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                  child:Text('FAQ'),
                  style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.white,
                  backgroundColor: Provider
                      .of<ThemeModel>(context, listen: false)
                      .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                      .of(context)
                      .primaryColor,
                  elevation: 2,
                  ),
                  onPressed: () {
                  Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                  },
                  onLongPress: () {
                  Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                  },
                  ),
                  SizedBox(width: 10,),
                OutlinedButton(
                child:Text('Security'),
                style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.white,
                backgroundColor: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                    .of(context)
                    .primaryColor,
                elevation: 2,
                ),
                onPressed: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Security");
                },
                onLongPress: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Security");
                },
                ),
                ],
              ),
            ),
          //al final
          Center(child: Image.asset('assets/logo-completo.png')),


        ]
    );
  }
}

//not user.
class SecuritySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Text("Security", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("In myBlueAd the users' data collected comply with the current data protection regulations. We do not use users' private information for other purpose than improving the user navigation experience and our recommendation system.\n\n Users' confidential data is not spread and users can manage their profile information at anytime. With our secure authentication system, no password are stored.\n\n When a user signs out, the session expires and next time the user will have to log in again with credentials or 3rd party authentication.", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          SizedBox(height:20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    child:Text('About'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                          .of(context)
                          .primaryColor,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "About");
                    },
                    onLongPress: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "About");
                    },
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                    child:Text('FAQ'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                          .of(context)
                          .primaryColor,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                    },
                    onLongPress: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                    },
                  ),
                ],
              ),
            ),
          //al final
          Center(child: Image.asset('assets/logo-completo.png')),


        ]
    );
  }
}

Future <String> send() async {
  final url = Uri(
    scheme: 'mailto',
    path: 'myblueadapp@gmail.com',
    query: 'subject=Contact myBlueAd&body=Your message',
  ).toString();
  try {
    await launch(url);
    return null;
  } on Exception catch (e) {
    return e.toString();
  }
}
//not user
class FaqSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen: false);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Text("FAQ", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text("Is myBlueAd a free app?", textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                    .of(context)
                    .primaryColor,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text(
              "Yes, users can download myBlueAd for free and has no in-app purchases, no we do not ask users for bank data.\n\n myBlueAd act as a link between customers and retail stores creating a disruptive customer experience, but currently it does not handle e-commerce functions. \n\n We ask for fees to retail stores proportional to our service and content deliver.",
              textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text("How does myBlueAd work?", textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                    .of(context)
                    .primaryColor,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text(
              "First, you have to become a blue user to enjoy blue offers. You can register via email and password, sign in with 3rd party authentication, via link, phone or anonymously.\n\nAfter authentication, if you are in a retail store which is a blue partner, you only have to activate bluetooth in your device to search blue ads nearby and the ones next to you will show up, according to your position. \n\nUnless you sign in anonymously, you can manage the blue ads you are interested in, as well as your profile information. ",
              textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text("How does myBlueAd handle my private information?",
              textAlign: TextAlign.justify, style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                    .of(context)
                    .primaryColor,
              ),),
          ),

          SizedBox(height: 20),

          Center(child: OutlinedButton(
            child: Text('Security'),
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Colors.white,
              backgroundColor: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
              elevation: 2,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                  '/draweroptions', arguments: "Security");
            },
            onLongPress: () {
              Navigator.of(context).pushNamed(
                  '/draweroptions', arguments: "Security");
            },
          ),),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text(
              "Contact us", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),

          SizedBox(height: 20),
          ContactButtons(),
          //al final
          Center(child: Image.asset('assets/logo-completo.png')),

        ]
    );
  }
}

class ContactButtons extends StatelessWidget {
  const ContactButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SignInButtonBuilder(
              shape:StadiumBorder(),
          mini:true,
          text: "",
          icon: Icons.mail,
          splashColor: Colors.blue,
          iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
    backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
          onPressed: () async
          {
          if (await send()!=null)
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Failed launching your email app. Please, try again.", context));

          }
        ),
        SignInButtonBuilder(
            shape:StadiumBorder(),
            mini:true,
            text: "",
            icon: Icons.alternate_email,
            splashColor: Colors.blue,
            iconColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.black : Colors.white,
            backgroundColor: Provider.of<ThemeModel>(context, listen: false).mode==ThemeMode.dark ? Colors.tealAccent : Theme.of(context).primaryColor,
            onPressed: () async
            {
              try {
                await launch("https://myblueadstore-user.web.app/");
              } on Exception catch (e)
              {
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar("Failed launching webpage. Please, try again.", context));
              }
            }

        ),
       SignInButton(
             Buttons.Facebook,
           mini:true,
           onPressed: () async
           {
                 await launch("https://www.facebook.com/profile.php?id=100069741004415");
           },

         ),
        SignInButton(
          Buttons.Twitter,
          mini:true,
          onPressed: () async
          {
            await launch("https://twitter.com/myBlueAd1");
          },

        ),
      ],
    ),);
  }
}


//user
class HelpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context, listen:false);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Text("Help", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("How to search blue ads", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("Searching nearby blue ads screen is the one on the middle of the navigation bar, and the first screen to appear when you log in.\n\n To start searching, you have to activate Bluetooth in your phone, and according to your location the blue ads next to you will pop up. You can disable bluetooth at anytime.\n\n In the current version, there are two options for users to search blue ads: button and demo. With button option, when clicking it a random blue ad will show up. With demo option, blue ads will show up periodically. ", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("How to manage my profile", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("If you click in the left icon at the bottom navigation bar, you will go to your profile section. At first, all info but registration or log in data will be empty.\n\n You can fill and delete your data at any time. Your profile is updated in real-time, so you can check it immediately after changing some data.", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("How to manage my favorites", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("If you click in the right icon at the bottom navigation bar, you will go to your favorites section. At first, the list of favs will be empty.\n"
                "\nWhen searching offers nearby, you can add blue ads to your favorites lists or discard them if you are not interested.\n\nIn your favorites section, you will find a list with a preview of your current fav blue ads, as well as the time left to expire. When you tap on the preview, the offer will appear on full screen. You can delete one or the complete list at any time as well. ", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right:25.0),
            child: Text("Do you want to change your user account?", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          SizedBox(height:20),
          //TODO ROW CON BOTONES HELP FAQ SECURITY
          if (userstate.status == Status.Authenticated)
            Center(child:OutlinedButton(
              child:Text('Settings'),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.white,
                backgroundColor: Provider
                    .of<ThemeModel>(context, listen: false)
                    .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                    .of(context)
                    .primaryColor,
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Settings");
              },
              onLongPress: () {
                Navigator.of(context).pushNamed('/draweroptions', arguments: "Settings");
              },
            ),),
          if (userstate.status == Status.Unauthenticated || userstate.status == Status.Authenticating || userstate.status == Status.Uninitialized)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    child:Text('FAQ'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                          .of(context)
                          .primaryColor,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                    },
                    onLongPress: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Faq");
                    },
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                    child:Text('Security'),
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.white,
                      backgroundColor: Provider
                          .of<ThemeModel>(context, listen: false)
                          .mode == ThemeMode.dark ? Colors.blueAccent : Theme
                          .of(context)
                          .primaryColor,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Security");
                    },
                    onLongPress: () {
                      Navigator.of(context).pushNamed('/draweroptions', arguments: "Security");
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: Text(
              "Contact us", textAlign: TextAlign.justify, style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: Provider
                  .of<ThemeModel>(context, listen: false)
                  .mode == ThemeMode.dark ? Colors.tealAccent : Theme
                  .of(context)
                  .primaryColor,
            ),),
          ),
          SizedBox(height:20),
          ContactButtons(),
          //al final
          Center(child: Image.asset('assets/logo-completo.png')),


        ]
    );
  }
}
