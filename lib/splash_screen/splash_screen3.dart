import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:delayed_widget/delayed_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen3 extends StatefulWidget {
  const SplashScreen3({Key? key}) : super(key: key);

  @override
  State<SplashScreen3> createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> with SingleTickerProviderStateMixin{
  String countryName="en",countryIcon="icon_country.png";


  String _genderDropDownSelectedValue = "English";
  final List<String> _countryNameList = ["English", "French", "Spanish","Italian",
                                    "German","Indonesia","Portugues","Romana","Arabics"];
  final List<String> _countryNameIcon = ["icon_country.png", "icon_country.png", "icon_country.png","icon_country.png",
    "German","icon_country.png","icon_country.png","icon_country.png","icon_country.png"];


  //size animation
  late Tween<double> _tweenSize;
  late Animation<double> _animationSize;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _tweenSize = Tween(begin: 70, end: 20);
    _animationSize = _tweenSize.animate(_animationController);
    _animationController.forward();
    super.initState();


    /* Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.of(context).pushReplacementNamed("/dashboard");
    });
*/
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: intello_bg_color,
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: 45,
            ),

            // InteractiveViewer(
            //   panEnabled: false, // Set it to false
            //   boundaryMargin: EdgeInsets.all(100),
            //   minScale: 0.5,
            //   maxScale: 2,
            //   child: Image.asset(
            //     'assets/images/getstarted_1.png',
            //     width: 200,
            //     height: 200,
            //     fit: BoxFit.cover,
            //   ),
            // ),

            Expanded(child:Stack(
              children: [
                Container(
                  //margin: const EdgeInsets.only(left: 70.0, right: 70.0),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child:AnimatedBuilder(
                        animation: _animationSize,
                        builder: (context, child) {
                          // Put your image here and replace height, width of image with _animationSize.value
                          return Container(
                            margin: EdgeInsets.only(left:_animationSize.value,right: _animationSize.value ),
                            child:  Image.asset(
                              "assets/images/getstarted_1.png",
                              fit: BoxFit.fill,
                              height: double.infinity,
                              width: MediaQuery.of(context).size.height / 1,
                            ),
                          );
                        })




                ),
                // Container(
                //   margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                //   child: Image.asset(
                //     "assets/images/getstarted_1.png",
                //     fit: BoxFit.fill,
                //     height: double.infinity,
                //     width: MediaQuery.of(context).size.height / 1,
                //   ),
                // ),

                Container(
                  child:Align(
                    alignment: Alignment.topRight,
                    child:  _buildDropDownMenu(),
                  ),

                  //
                )
              ],
            ),),


            DelayedWidget(

              delayDuration: Duration(milliseconds: 100),// Not required
              animationDuration: Duration(milliseconds: 400),// Not required
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,// Not required
              child: _buildBottomDesign(),
            ),

          ],
        ) /* add child content here */,
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
            padding:
            const EdgeInsets.only(left: 36, top: 10, right: 36, bottom: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 22,
                ),
                DelayedWidget(

                    delayDuration: Duration(milliseconds: 100),// Not required
                    animationDuration: Duration(milliseconds: 1000),// Not required
                    animation: DelayedAnimations.SLIDE_FROM_LEFT,// Not required
                    child: Text(
                      "Easily learn what you want,\n where you want",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                          color:intello_easylearn_bold_text_color_,
                          fontSize: 25,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600),
                    ),
                ),

                SizedBox(
                  height: 15,
                ),
                DelayedWidget(

                  delayDuration: Duration(milliseconds: 100),// Not required
                  animationDuration: Duration(milliseconds: 1000),// Not required
                  animation: DelayedAnimations.SLIDE_FROM_LEFT,// Not required
                  child:  Text(
                    "Lorem Ipsum is simply dummy text of the printing and type setting industry when and the "
                        "unknown printer took a gallery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:intello_small_text_color_,
                        fontSize: 15,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                      decoration: const BoxDecoration(
                        color:intello_bg_color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(2.0),
                          bottomRight: Radius.circular(2.0),
                          bottomLeft: Radius.circular(2.0),
                        ),
                      ),
                      height: 2,
                      width: 11,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 2.0, right:2.0),
                      decoration: const BoxDecoration(
                        color:intello_page_unselected_tab_color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(2.0),
                          bottomRight: Radius.circular(2.0),
                          bottomLeft: Radius.circular(2.0),
                        ),
                      ),
                      height: 2,
                      width: 11,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                      decoration: const BoxDecoration(
                        color:intello_page_unselected_tab_color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(2.0),
                          bottomRight: Radius.circular(2.0),
                          bottomLeft: Radius.circular(2.0),
                        ),
                      ),
                      height: 2,
                      width: 11,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                DelayedWidget(

                  delayDuration: Duration(milliseconds: 100),// Not required
                  animationDuration: Duration(milliseconds: 1000),// Not required
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,// Not required
                  child: _buildNextButton(),
                ),

              ],
            )));
  }

  Widget _buildNextButton() {
    return Container(
      margin: const EdgeInsets.only(left: 00.0, right: 00.0),
      child: ElevatedButton(
        onPressed: () {

          Route route = MaterialPageRoute(builder: (context) => const SplashScreen4());
          Navigator.pushReplacement(context, route);

        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
         // Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SplashScreen4()));

        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7))),
        child: Ink(

          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [intello_button_color_green,intello_button_color_green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(7.0)
          ),
          child: Container(

            height: 50,
            alignment: Alignment.center,
            child:  Text(
              "Next",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  //You can create a function with your desirable animation

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  Widget _buildDropButton() {
    return Container(
      padding: EdgeInsets.only(left: 5,right: 20,top: 10,bottom: 10),
      child: InkResponse(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
            color: Colors.white,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Image.asset(
                  "assets/images/$countryIcon",
                  height: 15,
                  width: 15,
                ),
                SizedBox(width: 5,),
                Text(
                  countryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PT-Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color:hint_color,
                  ),
                ),
                SizedBox(width: 0,),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color:hint_color,
                  size: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Drop Down Menu
  Widget _buildDropDownMenu() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(

        customButton: Container(
          child: _buildDropButton(),
        ),
        // openWithLongPress: true,
        customItemsIndexes: const [4],
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
                (item) =>
                DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
        ],
        onChanged: (value) {
          switch (value as MenuItem) {
            case MenuItems.English:
              setState(() {
                countryName="en";
              });

              //Do something
              break;
            case MenuItems.French:
              setState(() {
                countryName="fr";
              });
              //Do something
              break;
            case MenuItems.Spanish:
              setState(() {
                countryName="es";
              });
              break;
            case MenuItems.Italian:
              setState(() {
                countryName="it";
              });
              break;
          }
          // MenuItems.onChanged(context, value as MenuItem);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 13, right: 13),
        //dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(-10, 0),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final String imageLink;

  const MenuItem({
    required this.text,
    required this.imageLink,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [English, French, Spanish,Italian];


  static const English = MenuItem(text: 'en', imageLink: "assets/images/icon_country.png" );
  static const French = MenuItem(text: 'fr', imageLink: "assets/images/icon_country.png");
  static const Spanish = MenuItem(text: 'es', imageLink: "assets/images/icon_country.png");
  static const Italian = MenuItem(text: 'it', imageLink: "assets/images/icon_country.png");


  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Image.asset(
          "assets/images/icon_country.png",
          height: 22,
          width: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.English:
      //countryName="en";
      //Do something
        break;
      case MenuItems.French:
      //Do something
        break;
      case MenuItems.Spanish:
      //Do something
        break;
      case MenuItems.Italian:
      //Do something
        break;
    }
  }
}

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;

  AnimatedRoute(this.widget)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}