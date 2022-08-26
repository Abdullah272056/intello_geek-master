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

class YourApplicationsScreen4 extends StatefulWidget {

  @override
  State<YourApplicationsScreen4> createState() => _YourApplicationsScreenState();
}

class _YourApplicationsScreenState extends State<YourApplicationsScreen4> {


  int des_rev_less_status = 1;


  Color favoriteColor = Colors.pink;

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=2;

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
                  Expanded(child: Container(
                    margin: EdgeInsets.only(right: 00,left: 55),
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0),
                        )
                    ),
                    child: LinearPercentIndicator(
                      // width: MediaQuery.of(context).size.width - 80,
                      animation: true,

                      lineHeight: 20.0,
                      animationDuration: 1000,
                      percent: 0.1,
                      center: Text("5%",
                      style: TextStyle(color: Colors.white),
                      ),
                      barRadius: const Radius.circular(10),
                      backgroundColor: intello_progress_bg_color,
                      progressColor: intello_bg_color,
                    ),



                  )),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20,left: 10),
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
                    // mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [

                      Container(
                         height: 185,
                         margin: EdgeInsets.only(right: 30,left: 30,top: 00),
                         child: Image.asset(
                           'assets/images/teacher_checking_online_test_paper.png',
                           fit: BoxFit.fill,
                         ),
                       ),

                      Flex(direction: Axis.vertical,
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,top: 00),
                          child:  Align(
                            alignment: Alignment.topLeft,
                            child: Text("What's your current study level?",
                                style: TextStyle(
                                    color: intello_level_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child:  userInputCurrentStudy(),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child:  Align(
                            alignment: Alignment.topLeft,
                            child: Text("What degree do you want to get?",
                                style: TextStyle(
                                    color: intello_level_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child:  userInputCurrentDegree(),
                        ),
                      ],
                      ),



                     ],
                   ),
                 ),
              ),



              const SizedBox(
                height: 15,
              ),

              _buildProceedButtonField(),

            ],
          ),
        )
    );
  }

  Widget _buildProceedButtonField() {
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
                              "Proceed",
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

  Widget userInputCurrentStudy() {
    return InkResponse(
      onTap: () {
        setState(() {
          // _countryName="Bangladesh";
          // _countryCode=FlagsCode.BD;
         // _getCountryDataList();
        });

        // showToast("Ok");
      },
      child: Container(
        height: 55,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
             Expanded(child:  Text("Bachelor",
                 style: TextStyle(
                     color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.normal))),
               RotationTransition(
                turns:AlwaysStoppedAnimation(90 / 360),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                  size: 24.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget userInputCurrentDegree() {
    return InkResponse(
      onTap: () {
        setState(() {
          // _countryName="Bangladesh";
          // _countryCode=FlagsCode.BD;
          // _getCountryDataList();
        });

        // showToast("Ok");
      },
      child: Container(
        height: 55,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child:  Text("Master Degree",
                  style: TextStyle(
                      color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal))),
              RotationTransition(
                turns:AlwaysStoppedAnimation(90 / 360),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                  size: 24.0,
                ),
              ),

            ],
          ),
        ),
      ),
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

