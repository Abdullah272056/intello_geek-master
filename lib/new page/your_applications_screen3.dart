import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/course/course_video_play_previous_page.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../teacher_profile_view_page.dart';

class YourApplicationsScreen3 extends StatefulWidget {

  @override
  State<YourApplicationsScreen3> createState() => _YourApplicationsScreenState();
}

class _YourApplicationsScreenState extends State<YourApplicationsScreen3> {


  int des_rev_less_status = 1;
  String _ratingValue="";
  String _reviewSearchValue="";

  Color favoriteColor = Colors.pink;

  bool _shimmerStatus = true;
  // List _Course_single_response = [];


  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    // loadUserIdFromSharePref().then((_) {
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _darkOrLightStatus == 1 ? intello_bg_color:
                          intello_bg_color_for_darkMode,
      body:CustomScrollView(
        slivers: [
          SliverFillRemaining(

            hasScrollBody: false,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 15,
                ),

                Expanded(
                  child: _buildBottomDesign(),
                ),


              ],
            ),
          ),
        ],
      ),


    );
  }

  Widget _buildBottomDesign() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Container(
          margin:  EdgeInsets.only(left: 0, top: 20, right:0, bottom: 0),
          child:  Column(
            children: [

              Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20,left: 20),
                      decoration:  BoxDecoration(
                        color: _darkOrLightStatus==1? cross_btn_bg_color:intello_bg_color_for_darkMode,
                        // color: Colors.backGroundColor1,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      padding: EdgeInsets.all(9),
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/icon_cross.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),

              Expanded(
                 child: Container(

                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                      Container(
                         height: 185,
                         margin: EdgeInsets.only(right: 30,left: 30,top: 00),
                         child: Image.asset(
                           'assets/images/discount_coupon.png',
                           fit: BoxFit.fill,
                         ),
                       ),

                      Container(
                        margin: EdgeInsets.only(left: 30,right: 30,top: 40),
                        child:  Text(
                          "Take advantage of a quality follow-up until your integration in your destination country",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:_darkOrLightStatus==1?intello_bold_text_color:Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      Container(
                         margin: EdgeInsets.only(right: 30,left: 30,top: 20),
                         child: Text(
                           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                               "sed do eiusmod tempor incididunt ut labore et dolore magna"
                               " aliqua. Ut enim ad minim veniam, quis nostrud exercitatio",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color:intello_hint_colorfor_dark,
                               fontSize: 14,
                               fontWeight: FontWeight.w500),
                         ),
                       ),

                     ],
                   ),
                 ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              _buildStartNowButtonField(),

            ],
          ),
        )
    );
  }

  Widget _buildStartNowButtonField() {
    return Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 14, bottom: 40),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 00.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: _darkOrLightStatus==1? intello_subscription_card_bg_color:intello_subscription_card_bg_color,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Start Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PT-Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        _userId = sharedPreferences.getString(pref_user_id)!;
        _accessToken = sharedPreferences.getString(pref_user_access_token)!;
        _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;

      });
    } catch(e) {
      //code
    }

  }

}

