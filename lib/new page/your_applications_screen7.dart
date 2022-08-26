import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flag/flag_widget.dart';
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

class YourApplicationsScreen7 extends StatefulWidget {
  const YourApplicationsScreen7({Key? key}) : super(key: key);


  @override
  State<YourApplicationsScreen7> createState() => _YourApplicationsScreenState();
}

class _YourApplicationsScreenState extends State<YourApplicationsScreen7> {


  int des_rev_less_status = 1;


  Color favoriteColor = Colors.pink;

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=2;
  String _countryCode = "IT";

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
                      percent: 0.57,
                      center: Text("57%",
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
                         margin: EdgeInsets.only(right: 20,left: 20,top: 00),
                         child: Image.asset(
                           'assets/images/education.png',
                           fit: BoxFit.fill,
                         ),
                       ),

                      Flex(direction: Axis.vertical,
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,top: 00),
                          child:  Align(
                            alignment: Alignment.topLeft,
                            child: Text("What kind/type of training do you need?",
                                style: TextStyle(
                                    color: intello_level_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child:  userInputInitialTraining(),
                        ),


                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,top: 00),
                          child:  Align(
                            alignment: Alignment.topLeft,
                            child: Text("What training do you want to do?",
                                style: TextStyle(
                                    color: intello_level_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child:  userInputAddTraining(),
                        ),


                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,top: 15),
                          child:  Align(
                            alignment: Alignment.center,
                            child: Text("You have only 1 to 3 choices",
                                style: TextStyle(
                                    color: intello_level_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),



                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                          child: Align(alignment: Alignment.topLeft,
                            child:  Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: <Widget>[
                                _buildChip("Name of the University"),
                                _buildChip("Name of the University"),
                                _buildChip("Name of the University"),


                              ],
                            ),
                          ),
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
            InkWell(
              onTap: () {




              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration:  BoxDecoration(
                  color: _darkOrLightStatus==1? intello_bg_color:intello_bg_color,
                  // color: Colors.backGroundColor1,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/arrow_icon.png',
                  width: 25,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ),
            ),
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

  Widget userInputInitialTraining() {
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
        height: 50,
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

               Expanded(child:  Text("Initial Training",
                 style: TextStyle(
                     color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                     fontSize: 14,
                     fontWeight: FontWeight.normal))),
               RotationTransition(
                turns:AlwaysStoppedAnimation(90 / 360),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                  size: 20.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget userInputAddTraining() {
    return Container(
        child: Flex(
          direction: Axis.horizontal,
          children: [

            Expanded(
              flex: 4,
              child:  Container(
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                    color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 0, bottom: 0, right: 20),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [

                      Expanded(child:  Text(
                          "Computer Science, AI and Big...",
                          style: TextStyle(
                              color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal))),
                      RotationTransition(
                        turns:AlwaysStoppedAnimation(90 / 360),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color:_darkOrLightStatus==1? intello_text_color:Colors.white,
                          size: 20.0,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {


              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration:  BoxDecoration(
                  color: _darkOrLightStatus==1? intello_bg_color:intello_bg_color,
                  // color: Colors.backGroundColor1,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset(
                      'assets/images/add-icon.png',
                      width: 15,
                      height: 15,
                      fit: BoxFit.fill,
                    ),
                    Text(
                        "Add",
                        style: TextStyle(
                            color:_darkOrLightStatus==1? Colors.white:Colors.white,
                            fontSize: 14,

                            fontWeight: FontWeight.w500)),
                  ],

                ),
              ),
            ),

          ],
        )
    );
  }



  Widget _buildChip(String text) {
    return Container(
      decoration: BoxDecoration(color: _darkOrLightStatus==1?home_chip_bg_color_light:intello_bg_color_for_darkMode
        ,
        borderRadius: BorderRadius.circular(20),
        ),
      padding: EdgeInsets.only(left: 10,right: 10,top: 12,bottom: 12),
      child:  Flex(direction: Axis.horizontal,
        children: [
          SizedBox(width: 5,),
         Expanded(child:  Text(
           text,
           textAlign: TextAlign.center,
           style: TextStyle(
             fontFamily: 'PT-Sans',
             fontSize: 13,
             fontWeight: FontWeight.w500,
             color:_darkOrLightStatus==1?intello_bg_color:intello_bg_color,
           ),
         ),),


         Align(
           alignment: Alignment.centerRight,
         child:  Container(
           margin: EdgeInsets.only(top: 2,right: 10),
           child:  ImageIcon(
             AssetImage("assets/images/cross_icon.png"),
             color:_darkOrLightStatus==1?intello_bg_color:intello_bg_color,
             size: 10,
           ),
         ),
         )

        ],

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

