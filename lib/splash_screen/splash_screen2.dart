import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intello_geek/splash_screen/splash_screen3.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  @mustCallSuper
  initState() {
    super.initState();

    Future.delayed( Duration(milliseconds: 1000), () {
      setState(() {
        Route route = MaterialPageRoute(builder: (context) => const SplashScreen3());
        Navigator.pushReplacement(context, route);

       //Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen3()));

        //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop,duration: Duration(milliseconds: 500), child: SplashScreen3()));
      });

    }

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_splashanim.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Align(alignment: Alignment.center,
             child: DelayedWidget(

               delayDuration: Duration(milliseconds: 100),// Not required
               animationDuration: Duration(milliseconds: 1000),// Not required
               animation: DelayedAnimations.SLIDE_FROM_BOTTOM,// Not required
               child: Image.asset(
                 "assets/images/logo1.png",
                 width: 250,
                 height: 180,
                 fit: BoxFit.fill,
               ),
             ),
             )


            ],

          ),
        )/* add child content here */,
      ),
    );


  }


}
