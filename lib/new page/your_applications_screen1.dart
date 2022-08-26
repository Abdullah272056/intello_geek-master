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

class YourApplicationsScreen1 extends StatefulWidget {

  @override
  State<YourApplicationsScreen1> createState() => _YourApplicationsScreenState();
}

class _YourApplicationsScreenState extends State<YourApplicationsScreen1> {



  // TextEditingController? _emailController = TextEditingController();
  TextEditingController? _searchController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure3 = true;
  String countryName="All Ratings";
  Color descriptionTextColor = Colors.white;
  Color lessonsTextColor = Colors.black;
  Color reviewTextColor = Colors.black;
  Color descriptionTabColor =intello_bg_color;
  Color lessonsTabColor =tabColor;
  Color reviewTabColor = tabColor;

  int des_rev_less_status = 1;
  String _ratingValue="";
  String _reviewSearchValue="";

  Color favoriteColor = Colors.pink;

  bool _shimmerStatus = true;
  // List _Course_single_response = [];

  var _course_single_response;
  String _courseTitle="";
  String _courseCreatedBy="";
  double _avarageRating=0.0;
  String _courseCreatedByImage="";

  var _course_description_response;
  List _course_what_will_you_learn_list=[];
  List _course_review_response=[];
  String _courseDescription="";
  String _courselearnQuestion="";
  String _courselearnAnswer="";

  // List _course_review_feedback_response=[];
  //
   var _course_review_feedback_response;
  // double _studentavarageRating=0.0;

  // String _coverImage="";
  // String _profileImage="";

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=2;
  bool _videoShimmerStatus=true;
  bool _descriptionShimmerStatus=true;
  bool _lessonsShimmerStatus=true;
  bool _reviewShimmerStatus=true;
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
                           'assets/images/travel_around_the_world.png',
                           fit: BoxFit.fill,
                         ),
                       ),
                      Container(
                        margin: EdgeInsets.only(left: 30,right: 30,top: 40),
                        child:  Text(
                          "With IntelloGeek, travel abroad easily to study at your favourite school",
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
                           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitatio",
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
                height: 15,
              ),
              _buildNextButtonField(),
              _buildSkipButtonField()
            ],
          ),
        )
    );
  }



  Widget _buildNextButtonField() {
    return Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 14, bottom: 0),
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
                              "Next",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PT-Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
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
        ));
  }
  Widget _buildSkipButtonField() {
    return Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 14, bottom: 14),
        child: InkWell(
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Text(
                    "Skip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color:intello_search_view_hint_color,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ));
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

