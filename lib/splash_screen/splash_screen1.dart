import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intello_geek/splash_screen/splash_screen2.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service/sharePreferenceDataSaveName.dart';

import '../home_page/home_page.dart';
import '../home_page/navigation_bar_page.dart';
import '../registration/log_in.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {

  late String userId;
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  String _login_status_check = "";
  int _darkOrLightStatus=1;
  final QuickActions quickActions = const QuickActions();
 // final FlutterShortcuts flutterShortcuts = FlutterShortcuts();


  @override
  @mustCallSuper
  initState() {
    super.initState();

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'continue_learning', localizedTitle: 'Continue Learning', icon: 'icon_cart'),
      const ShortcutItem(type: 'my_cart', localizedTitle: 'My Cart', icon: "icon_cart"),
      const ShortcutItem(type: 'travel_abroad', localizedTitle: 'Travel Abroad', icon: 'icon_travel'),

      const ShortcutItem(type: 'search_course', localizedTitle: 'Search Course', icon: 'icon_travel',),
      const ShortcutItem(type: 'categories', localizedTitle: 'Categories', icon: 'icon_help'),
    ]);
    quickActions.initialize((type) {
      if(type=="continue_learning"){

      }
      else if(type=="my_cart"){

      }
      else if(type=="travel_abroad"){

      }
      // else if(type=="categories"){
      //
      // }
      else if(type=="search_course"){

      }

    });

    loadUserIdFromSharePref().then((_) {

      if(_login_status_check!=null &&!_login_status_check.isEmpty&&_login_status_check!=""){
        Future.delayed( Duration(milliseconds: 320), () {
          setState(() {
            // Route route = MaterialPageRoute(builder: (context) => LogInScreen());
            // Navigator.pushReplacement(context, route);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(_darkOrLightStatus)),
              ),
                  (route) => false,
            );


          });

        });
      }
      else{
        setState(() {
          Route route = MaterialPageRoute(builder: (context) => SplashScreen2());
          Navigator.pushReplacement(context, route);
        });


      // if(_userId!=null &&!_userId.isEmpty&&_userId!=""){
      //   Future.delayed( Duration(milliseconds: 320), () {
      //     setState(() {
      //
      //       Route route = MaterialPageRoute(builder: (context) => LogInScreen());
      //       Navigator.pushReplacement(context, route);
      //
      //
      //     });
      //
      //   });
      // }
      // else{
      //   setState(() {
      //     Route route = MaterialPageRoute(builder: (context) => SplashScreen2());
      //     Navigator.pushReplacement(context, route);
      //
      //
      //   });


      }

    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkResponse(
        onTap: (){
          Route route = MaterialPageRoute(builder: (context) => SplashScreen2());
          Navigator.pushReplacement(context, route);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: null /* add child content here */,
        ),
      ),
    );
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        _userId = sharedPreferences.getString(pref_user_id)!;
        _login_status_check = sharedPreferences.getString(pref_login_status)!;
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
      });
    } catch(e) {
      //code
    }

  }

}
