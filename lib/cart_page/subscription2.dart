
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../course/my_course_details.dart';
import '../home_page/course_details.dart';
import '../home_page/navigation_bar_page.dart';



class Subscription2PageScreen extends StatefulWidget {

  int darkOrLightStatus;
  Subscription2PageScreen(this.darkOrLightStatus);

  @override
  State<Subscription2PageScreen> createState() =>
      _Subscription2PageScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _Subscription2PageScreenState extends State<Subscription2PageScreen> {
  int _darkOrLightStatus;


  _Subscription2PageScreenState(this._darkOrLightStatus);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";

  int searchBoxVisible=0;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _darkOrLightToggleModeStatus=2;
  String _darkOrLightToggleButtonImageLink="";



  List _MyCourse = [];
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";

  bool _shimmerStatus = true;
  int monthlyOrAnnualPlanStatus=1;

  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      //_showToast(_userId.toString());

      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.intello_bd_color_dark,
      body: Container(
        decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ? intello_bg_color:
          intello_bg_color_for_darkMode,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
              // height: 50,
            ),

            Container(
              height: 55,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Container(
                    margin: new EdgeInsets.only(left: 30),
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();

                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        margin: new EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Subscription ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),



                ],
              ),
            ),


            SizedBox(
              height: 17,
              // height: 30,
            ),




            Expanded(
              child: _buildBottomDesignForList(),
            ),


          ],
        ),

        /* add child content here */
      ),
    );
  }



  Widget _buildBottomDesignForList() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 00),

            child: Column(
              children: [

               Container(
                 margin:  EdgeInsets.only(left: 30.0, right: 30.0,bottom: 10,top: 20),
                 child: Stack(
                   children: [
                     Container(
                       margin:  EdgeInsets.only(top: 13),
                       //width: 180,
                       decoration: new BoxDecoration(

                         color:_darkOrLightStatus == 1 ?intello_Indicator_bg_color_for_light:intello_level_color_for_dark_for_dark,

                         borderRadius: BorderRadius.circular(12),

                         boxShadow: [BoxShadow(

                           color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
                           //  blurRadius: 20.0, // soften the shadow
                           blurRadius: _darkOrLightStatus == 1?20:0, // soften the shadow
                           spreadRadius: 0.0, //extend the shadow
                           offset: _darkOrLightStatus == 1 ? Offset(
                             2.0, // Move to right 10  horizontally
                             1.0, // Move to bottom 10 Vertically
                           ):
                           Offset(
                             0.0, // Move to right 10  horizontally
                             0.0, // Move to bottom 10 Vertically
                           ),
                         )],

                       ),
                       height: 60,
                       child: Flex(direction: Axis.horizontal,
                         children: [

                           Expanded(child:
                           InkResponse(
                             onTap: (){

                               setState(() {
                                 monthlyOrAnnualPlanStatus=1;
                               });
                             },
                             child:  Container(

                               margin: EdgeInsets.only(right: 7.0,top: 7,bottom: 7,left: 7),
                               decoration: monthlyOrAnnualPlanStatus==1?BoxDecoration(
                                 color:_darkOrLightStatus == 1 ?
                                 Colors.white:Colors.white,
                                 borderRadius: BorderRadius.circular(8),

                                 // boxShadow: [BoxShadow(
                                 //
                                 //   color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
                                 //   //  blurRadius: 20.0, // soften the shadow
                                 //   blurRadius: _darkOrLightStatus == 1?20:0, // soften the shadow
                                 //   spreadRadius: 0.0, //extend the shadow
                                 //   offset: _darkOrLightStatus == 1 ? Offset(
                                 //     2.0, // Move to right 10  horizontally
                                 //     1.0, // Move to bottom 10 Vertically
                                 //   ):
                                 //   Offset(
                                 //     0.0, // Move to right 10  horizontally
                                 //     0.0, // Move to bottom 10 Vertically
                                 //   ),
                                 // )],

                               ):
                               BoxDecoration(
                                 color:_darkOrLightStatus == 1 ?
                                 Colors.transparent:Colors.transparent,
                                 borderRadius: BorderRadius.circular(8),

                                 // boxShadow: [BoxShadow(
                                 //
                                 //   color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
                                 //   //  blurRadius: 20.0, // soften the shadow
                                 //   blurRadius: _darkOrLightStatus == 1?20:0, // soften the shadow
                                 //   spreadRadius: 0.0, //extend the shadow
                                 //   offset: _darkOrLightStatus == 1 ? Offset(
                                 //     2.0, // Move to right 10  horizontally
                                 //     1.0, // Move to bottom 10 Vertically
                                 //   ):
                                 //   Offset(
                                 //     0.0, // Move to right 10  horizontally
                                 //     0.0, // Move to bottom 10 Vertically
                                 //   ),
                                 // )],

                               ),
                               child:  Align(
                                 alignment: Alignment.center,
                                 child: Text(
                                   "Monthly Plan",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       color:intello_easylearn_bold_text_color_,
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500),
                                 ),
                               ),
                               // height: double.infinity,
                               // width: double.infinity,

                             ) ,
                           )

                           ),

                           Expanded(child: InkResponse(
                             onTap: (){
                               setState(() {
                                 monthlyOrAnnualPlanStatus=2;
                               });
                             },
                             child:Container(

                               margin: EdgeInsets.only(right: 7.0,top: 7,bottom: 7,left: 7),
                               decoration: monthlyOrAnnualPlanStatus==2?BoxDecoration(
                                 color:_darkOrLightStatus == 1 ?
                                 Colors.white:Colors.white,
                                 borderRadius: BorderRadius.circular(8),

                                 // boxShadow: [BoxShadow(
                                 //
                                 //   color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
                                 //   //  blurRadius: 20.0, // soften the shadow
                                 //   blurRadius: _darkOrLightStatus == 1?20:0, // soften the shadow
                                 //   spreadRadius: 0.0, //extend the shadow
                                 //   offset: _darkOrLightStatus == 1 ? Offset(
                                 //     2.0, // Move to right 10  horizontally
                                 //     1.0, // Move to bottom 10 Vertically
                                 //   ):
                                 //   Offset(
                                 //     0.0, // Move to right 10  horizontally
                                 //     0.0, // Move to bottom 10 Vertically
                                 //   ),
                                 // )],

                               ):
                               BoxDecoration(
                                 color:_darkOrLightStatus == 1 ?
                                 Colors.transparent:Colors.transparent,
                                 borderRadius: BorderRadius.circular(8),

                                 // boxShadow: [BoxShadow(
                                 //
                                 //   color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
                                 //   //  blurRadius: 20.0, // soften the shadow
                                 //   blurRadius: _darkOrLightStatus == 1?20:0, // soften the shadow
                                 //   spreadRadius: 0.0, //extend the shadow
                                 //   offset: _darkOrLightStatus == 1 ? Offset(
                                 //     2.0, // Move to right 10  horizontally
                                 //     1.0, // Move to bottom 10 Vertically
                                 //   ):
                                 //   Offset(
                                 //     0.0, // Move to right 10  horizontally
                                 //     0.0, // Move to bottom 10 Vertically
                                 //   ),
                                 // )],

                               ),
                               child:  Align(
                                 alignment: Alignment.center,
                                 child: Text(
                                   "Annual Plan",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       color:intello_easylearn_bold_text_color_,
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500),
                                 ),
                               ),
                               // height: double.infinity,
                               // width: double.infinity,

                             ) ,
                           )),
                         ],

                       ) ,
                     ),
                     Container(
                       margin:  EdgeInsets.only(),
                       //width: 180,
                       color: Colors.transparent,
                      // height: 60,
                       child: Flex(direction: Axis.horizontal,
                         children: [

                           Expanded(
                             child: Container(
                                  color: Colors.transparent,
                             ),
                           ),

                           Expanded(child: Center(
                             child: Container(
                               height: 26,
                               width: 80,

                               decoration: BoxDecoration(
                                 color:intello_subscription_card_border_color,
                                 borderRadius: BorderRadius.circular(13),

                               ),

                               child:  Align(
                                 alignment: Alignment.center,
                                 child: Text(
                                   "Save 10%",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       color:Colors.white,
                                       fontSize: 13,
                                       fontWeight: FontWeight.w500),
                                 ),
                               ),

                             ),
                           ) ),
                         ],

                       ) ,
                     ),
                   ],
                 ),
               ),

                Flex(direction: Axis.horizontal,
                children: [

                 Expanded(child: Container(
                   margin: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                   padding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                   height: 132,
                   decoration: new BoxDecoration(
                      // color: Colors.red,
                       border: Border.all(color: intello_subscription_card_border_color,width: 1),
                       borderRadius: new BorderRadius.all(
                         Radius.circular(12),
                       )
                   ),
                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.spaceAround,

                     children: [
                       Align(
                         alignment: Alignment.topLeft,
                         child: Text(
                           "Free",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color:_darkOrLightStatus == 1 ?
                               intello_easylearn_bold_text_color_:Colors.white,
                               fontSize: 19,
                               fontWeight: FontWeight.w600),
                         ),
                       ),
                       Align(
                         alignment: Alignment.topLeft,
                         child: Text(
                           "Not ready to commit?\nTry us out with ease.",

                           textAlign: TextAlign.left,
                           style: TextStyle(
                               color:_darkOrLightStatus == 1 ?
                               intello_easylearn_bold_text_color_:Colors.white,
                               height: 1.3,
                               fontSize: 12,
                               fontWeight: FontWeight.w400),
                         ),
                       ),
                       Flex(direction: Axis.horizontal,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "\$0",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color:_darkOrLightStatus == 1 ?
                                    intello_subscription_card_bg_color:Colors.white,

                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                " /month",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color:_darkOrLightStatus == 1 ?
                                    intello_easylearn_bold_text_color_:Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                       )
                     ],
                   ),
                 )),

                 Expanded(child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
                   padding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                    height: 132,
                    decoration: new BoxDecoration(
                       color: intello_subscription_card_border_color,
                        border: Border.all(color: intello_subscription_card_border_color,width: 1),
                        borderRadius: new BorderRadius.all(
                          Radius.circular(12),
                        )
                    ),
                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.spaceAround,

                     children: [
                       Align(
                         alignment: Alignment.topLeft,
                         child: Text(
                           "Basic",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color:Colors.white,
                               fontSize: 19,
                               fontWeight: FontWeight.w600),
                         ),
                       ),
                       Align(
                         alignment: Alignment.topLeft,
                         child: Text(
                           "Not ready to commit?\nTry us out with ease.",

                           textAlign: TextAlign.left,
                           style: TextStyle(
                               color: Colors.white,
                               height: 1.3,
                               fontSize: 12,
                               fontWeight: FontWeight.w400),
                         ),
                       ),
                       Flex(direction: Axis.horizontal,
                         children: [
                           Align(
                             alignment: Alignment.topLeft,
                             child: Text(
                               "\$30",
                               textAlign: TextAlign.left,
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 24,
                                   fontWeight: FontWeight.w600),
                             ),
                           ),
                           Align(
                             alignment: Alignment.topLeft,
                             child: Text(
                               " /month",
                               textAlign: TextAlign.left,
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 12,
                                   fontWeight: FontWeight.w400),
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                  )),

                ],
                ),

                Flex(direction: Axis.horizontal,
                  children: [

                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                      padding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                      height: 132,
                      decoration: new BoxDecoration(
                          color: intello_subscription_card_bg_color,
                          border: Border.all(color: intello_subscription_card_border_color,width: 1),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(12),
                          )
                      ),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Pro",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1 ?
                                  intello_easylearn_bold_text_color_:Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Not ready to commit?\nTry us out with ease.",

                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1 ?
                                  intello_easylearn_bold_text_color_:Colors.white,
                                  height: 1.3,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Flex(direction: Axis.horizontal,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "\$0",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ?
                                      intello_subscription_card_bg_color:Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  " /month",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ?
                                      intello_easylearn_bold_text_color_:Colors.white,

                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),

                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
                      padding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                      height: 132,
                      decoration: new BoxDecoration(
                        // color: Colors.red,
                          border: Border.all(color: intello_subscription_card_border_color,width: 1),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(12),
                          )
                      ),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Business",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1 ?
                                  intello_easylearn_bold_text_color_:Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Not ready to commit?\nTry us out with ease.",

                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1 ?
                                  intello_easylearn_bold_text_color_:Colors.white,
                                  height: 1.3,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Flex(direction: Axis.horizontal,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "\$0",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ?
                                      intello_subscription_card_bg_color:Colors.white,

                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  " /month",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ?
                                      intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),

                  ],
                ),






              ],
            )));
  }




  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_id)!;
      _accessToken = sharedPreferences.getString(pref_user_access_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
     // _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
    });
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: intello_bg_color,
        textColor: Colors.white,
        fontSize: 16.0);
  }


}
