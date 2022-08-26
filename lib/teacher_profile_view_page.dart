
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


import 'Colors/colors.dart';
import 'api_service/api_service.dart';
import 'api_service/sharePreferenceDataSaveName.dart';
import 'contact_with_teacer_page.dart';
import 'home_page/course_details.dart';

class TeacherProfileViewScreen extends StatefulWidget {
  String teacherId;
  TeacherProfileViewScreen({required this.teacherId});

  @override
  State<TeacherProfileViewScreen> createState() =>
      _TeacherProfileViewScreenState(this.teacherId);
}

class _TeacherProfileViewScreenState extends State<TeacherProfileViewScreen> {
  String _teacherId;
  _TeacherProfileViewScreenState(this._teacherId);



  TextEditingController? searchController = TextEditingController();



  Color aboutTextColor = Colors.white;
  Color newsfeedTextColor = Colors.black;
  Color eventsTextColor = Colors.black;
  Color aboutTabColor =intello_bg_color;
  Color newsfeedTabColor =tabColor;
  Color eventsTabColor = tabColor;

  int des_rev_less_status = 1;

  Color favoriteColor = Colors.pink;

  bool _shimmerStatus = true;
  List _get_teacher_public_profile_featured = [];
  List _get_teacher_public_profile_course = [];
  List _get_teacher_public_profile_blog_post = [];
  var _get_teacher_public_profile_blogpost_response;
  List _get_teacher_public_profile_course_seminar = [];

  var _get_teacher_public_profile_response;

  String _teacherName="";
  double _avarageRating=0.0;
  String _aboutTitle="";
  String _coverImage="";
  String _profileImage="";

  var _get_teacher_public_profile_about_response;
  String _ProfileAbout="";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;
  bool _aboutShimmerStatus = true;
  bool _blogPostShimmerStatus = true;
  bool _eventShimmerStatus = true;
  bool _headerShimmerStatus = true;
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    loadUserIdFromSharePref().then((_) {
      if(_darkOrLightStatus==1){
        aboutTextColor = Colors.white;
        newsfeedTextColor = Colors.black;
        eventsTextColor = Colors.black;
        aboutTabColor = intello_bd_color;
        newsfeedTabColor = tabColor;
        eventsTabColor = tabColor;
        des_rev_less_status = 1;
      }
      else{
        aboutTextColor = Colors.white;
        newsfeedTextColor = Colors.white;
        eventsTextColor = Colors.white;
        aboutTabColor = intello_bd_color;
        newsfeedTabColor = intello_bg_color_for_darkMode;
        eventsTabColor = intello_bg_color_for_darkMode;
        des_rev_less_status = 1;
      }
      _teacher_public_profile_List();
      _teacher_public_profile_about();
      _teacher_public_profile_featured();
      _teacher_public_profile_course();
      _teacher_public_profile_blog_post();
      _teacher_public_profile_course_seminar();


    });





    // loadUserIdFromSharePref().then((_) {
    //   _getOfferDataList(accessToken: _accessToken);
    //   _getExploreList(accessToken: _accessToken);
    //   _getMostPopularHotelList(accessToken: _accessToken);
    //   _getRecommendedHotelList(accessToken: _accessToken);
    // });

  }
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.intello_bd_color_dark,
      body:Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color:_darkOrLightStatus == 1 ? Colors.white:   intello_bottom_bg_color_for_dark,
              ),
              child: Stack(
                children: [

                  if(_coverImage=="")...[

                    Container(
                    //  color: shimmer_baseColor,
                      height: screenHeight / 3.5,
                      child:Image.asset(

                        'assets/images/loading.png',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,),

                    ),
                  ]
                  else...[
                    Container(
                      height: screenHeight / 3.5,
                      child: FadeInImage.assetNetwork(
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: 'assets/images/loading.png',
                        image: _coverImage,
                        imageErrorBuilder: (context, url, error) =>
                            Image.asset(
                              'assets/images/loading.png',
                              fit: BoxFit.fill,
                            ),
                      ),

                    ),
                  ],
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight / 17,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            height: screenHeight / 15,
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
                                margin: new EdgeInsets.only(right: 50),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Trainer Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )),
                          Container(
                            height: screenHeight / 15,
                            margin: new EdgeInsets.only(right: 30),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactWithTeacherScreen()));
                               // _showToast("send message");
                              },
                              child: Icon(
                                Icons.message_rounded,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 16,
                      ),

                      if(_profileImage==""||_coverImage==null)...[

                        InkResponse(
                          onTap: () {
                            _showToast("Pik clicked");
                          },
                          child: Container(
                            width: 142.0,
                            height: 142.0,
                            decoration: BoxDecoration(
                              color: shimmer_baseColor,

                              borderRadius: BorderRadius.all( Radius.circular(121.0)),
                              border: Border.all(
                                color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
                                width: 4,
                              ),
                            ),
                          ),


                        ),

                      ]
                      else...[
                        InkResponse(
                          onTap: () {
                            _showToast("Pik clicked");
                          },
                          child: Container(
                            width: 142.0,
                            height: 142.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: NetworkImage(_profileImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all( Radius.circular(121.0)),
                              border: Border.all(
                                color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
                                width: 4,
                              ),
                            ),
                          ),


                        ),
                      ],
                      
                      
                      
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Column(
                          children: [
                            if(_headerShimmerStatus)...{
                              Container(
                                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0,bottom: 00),
                                child:Flex(direction: Axis.horizontal,
                                  children: [
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height:25,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ), flex: 2,),

                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),


                                  ],
                                ) ,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5,bottom: 00),
                                child: Container(
                                  margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                  child: Align(alignment: Alignment.topLeft,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Shimmer.fromColors(
                                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                        child: Container(
                                          height:25,
                                          //  width: 65,
                                          decoration: BoxDecoration(
                                            color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2.0),

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10,bottom: 0),
                                child:Flex(direction: Axis.horizontal,
                                  children: [
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height:25,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ), flex: 2,),

                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),


                                  ],
                                ) ,
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15,bottom: 15),
                                child:Flex(direction: Axis.horizontal,
                                  children: [
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 40,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ), flex: 2,),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 40,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ), flex: 2,),
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),


                                  ],
                                ) ,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10,bottom: 15),
                                child:Flex(direction: Axis.horizontal,
                                  children: [
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), flex: 2,),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), flex: 2,),
                                    Expanded(child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          margin: EdgeInsets.only(left: 0.0, right: 2.0, top: 0),
                                          child: Align(alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Shimmer.fromColors(
                                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                                child: Container(
                                                  height: 17,
                                                  //  width: 65,
                                                  decoration: BoxDecoration(
                                                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), flex: 2,),
                                    Expanded(child: Container(

                                    ),
                                      flex: 1,
                                    ),


                                  ],
                                ) ,
                              ),

                            }
                            else...{
                              Container(
                                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child:  Align(
                                  alignment: Alignment.topCenter,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(
                                        _teacherName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:_darkOrLightStatus == 1 ?intello_text_color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top:2),
                                        child: Image.asset(
                                          "assets/images/verified.png",
                                          fit: BoxFit.fill,
                                          height: 21,
                                          width: 21,
                                        ),
                                      )


                                      // Icon(
                                      //   Icons.verified_rounded,
                                      //   color: Colors.intello_bd_color_dark,
                                      //   size: 24.0,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 22.0, right: 22.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin:  EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child:  Text(
                                      _aboutTitle,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:intello_hint_color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                      softWrap: false,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Container(

                                margin: const EdgeInsets.only(left: 22.0, right: 22.0),
                                child:Align(
                                  alignment: Alignment.topCenter,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      RatingBarIndicator(
                                        rating: _avarageRating,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: intello_star_color,
                                        ),
                                        itemCount: 5,
                                        itemSize: screenWidth / 19,
                                        direction: Axis.horizontal,
                                      ),
                                      Text(
                                        " ($_avarageRating)",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:intello_hint_color,
                                            fontSize: screenWidth / 20,
                                            fontWeight: FontWeight.w500),
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 22.0, right: 22.0),
                                child:_buildReadMore_FollowField(),
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 22.0, right: 22.0),
                                child:_buildFollowerTotalStudentTrainerField(),
                              ),
                            },



                            //about


                            if (des_rev_less_status == 1) ...{
                              _buildAboutTabSectionDesign(),
                            }
                            else if (des_rev_less_status == 2) ...{
                              _buildNewsFeedList(),

                            }
                            else if (des_rev_less_status == 3) ...{
                              if(_eventShimmerStatus)...{
                                eventsListShimmer()
                              }
                              else...{
                                _buildEventsList()
                              }

                            }
                            else ...{
                              _buildAboutTabSectionDesign(),
                            },


                          ],
                        ),
                      )

                    ],
                  )
                ],
              ),

              /* add child content here */
            ),
          )),

          _buildTabButton()

        ],
      )
    );
  }

  Widget _buildReadMore_FollowField() {
    return Container(
        padding:
            const EdgeInsets.only(left: 30.0, right: 30.0, top: 10, bottom: 10),

        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Ink(
                    //
                    decoration: BoxDecoration(
                        color:_darkOrLightStatus==1? intello_hint_color:intello_bg_color_for_darkMode,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Read More",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PT-Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [intello_bg_color, intello_bg_color],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Follow Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PT-Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18.0,
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

  Widget _buildFollowerTotalStudentTrainerField() {
    return Container(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),

        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "Followers",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: intello_hint_color,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    softWrap: false,
                    maxLines: 2,
                  ),
                  Text(
                    "2.6M",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: .5,
              height: 30,
              color:hint_color,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "Total Students",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color:intello_hint_color,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    softWrap: false,
                    maxLines: 2,
                  ),
                  Text(
                    "1.6M",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: .5,
              height: 30,
              color: hint_color,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "All Trainings",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: intello_hint_color,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    softWrap: false,
                    maxLines: 2,
                  ),
                  Text(
                    "2.6K",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildAboutTabSectionDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(_aboutShimmerStatus)...{
          Container(
            margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child:  Row(
                children: [
                  Expanded(child: Align(alignment: Alignment.topLeft,
                    child:  Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                      child:Container(
                        height: 25,
                        // width: 130,
                        color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                      ),
                    ),
                  ),),
                  Expanded(child: Container(),)
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 15),
            child:  Shimmer.fromColors(
              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
              child:Container(
                height: 70,
                // width: 130,
                color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child:  Row(
                children: [
                  Expanded(child: Align(alignment: Alignment.topLeft,
                    child:  Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                      child:Container(
                        height: 25,
                        // width: 130,
                        color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                      ),
                    ),
                  ),),
                  Expanded(child: Container(),)
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            height:150.0,
            // child: _buildRecentlyAddedCourseItem(),
            child: ListView.builder(
              //itemCount: offerDataList == null ? 0 : offerDataList.length,
              itemCount: 7,
              itemBuilder: (context, index) {
                if(index==0){
                  return _buildTopCategoriesItemShimmer(item_marginLeft:20,item_marginRight: 0);
                }
                //length
                if(index==6){
                  return _buildTopCategoriesItemShimmer(item_marginLeft:15,item_marginRight: 20);
                }

                else{
                  return _buildTopCategoriesItemShimmer(item_marginLeft:15,item_marginRight: 00);
                }

              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child:  Row(
                children: [
                  Expanded(child: Align(alignment: Alignment.topLeft,
                    child:  Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                      child:Container(
                        height: 25,
                        // width: 130,
                        color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                      ),
                    ),
                  ),),
                  Expanded(child: Container(),)
                ],
              ),
            ),
          ),

          Container(
            //  margin: const EdgeInsets.only(top: 25),
              height:270.0,

              // child: _buildRecentlyAddedCourseItem(),
              child: ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),
                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                itemCount: 6,
                itemBuilder: (context, index) {
                  if(index==0){
                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:20,item_marginRight: 0);
                  }
                  //length
                  if(index==5){
                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 20);
                  }
                  else{
                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 00);
                  }


                },
                scrollDirection: Axis.horizontal,
              )
          ),
        }else...{
          Container(
            margin: const EdgeInsets.only(left: 22.0, right: 22.0),
            child:_buildAboutText(),

          ),
          Container(
            margin: const EdgeInsets.only(left: 22.0, right: 22.0),
            child:_buildCommunityDesign(),
          ),
          _buildFeaturedDesign(),
          Container(
            margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Current Courses",
                style: TextStyle(
                    color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25),
              height:255.0,

              // child: _buildRecentlyAddedCourseItem(),
              child: ListView.builder(
                shrinkWrap: true,

                // physics: const NeverScrollableScrollPhysics(),
                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                itemCount: _get_teacher_public_profile_course==null||_get_teacher_public_profile_course.length<=0?0:
                _get_teacher_public_profile_course.length,
                itemBuilder: (context, index) {
                  if(index==0){
                    return _buildRecentlyAddedCourseItem(item_marginLeft:20,item_marginRight: 0,response: _get_teacher_public_profile_course[index]);
                  }
                  //length
                  if(index==_get_teacher_public_profile_course.length-1){
                    return _buildRecentlyAddedCourseItem(item_marginLeft:30,item_marginRight: 20,response: _get_teacher_public_profile_course[index]);
                  }
                  else{
                    return _buildRecentlyAddedCourseItem(item_marginLeft:30,item_marginRight: 00,response: _get_teacher_public_profile_course[index]);
                  }


                },
                scrollDirection: Axis.horizontal,
              )


          ),
        },

      ],
    );
  }

  Widget _buildAboutText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "About",
              style: TextStyle(
                  color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _ProfileAbout,
              style: TextStyle(
                  color: _darkOrLightStatus==1? intello_text_color:intello_hint_colorfor_dark,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildCommunityDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Community",
              style: TextStyle(
                  color: _darkOrLightStatus==1? intello_text_color:Colors.white,

                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/facebook.png'),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                    Text(
                      "2.6M",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                      maxLines: 2,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  width: .5,
                  height: 45,
                  color: intello_hint_color,
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/youtube.png'),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                    Text(
                      "1.6M",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                      maxLines: 2,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  width: .5,
                  height: 45,
                  color:intello_hint_color,
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/instagram.png'),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                    Text(
                      "2.6K",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyAddedCourseItem({required double item_marginLeft,required double item_marginRight, required var response}) {
    return InkResponse(
      onTap: (){
       Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: response["course_id"].toString() ,)));
      },
      child: Container(
        margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10),
        width: 250,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  height: 150,
                  child: Stack(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          placeholder: 'assets/images/loading.png',
                          image: "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                          imageErrorBuilder: (context, url, error) =>
                              Image.asset(
                                'assets/images/loading.png',
                                fit: BoxFit.fill,
                              ),
                        ),
                        // Image.network(
                        //   "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   fit: BoxFit.fill,
                        // ),
                        Center(
                          child: Image.asset(
                            "assets/images/play.png",
                            height: 80,
                            width: 80,
                            fit: BoxFit.fill,
                          ),

                        ),

                        Container(
                            width: double.infinity,

                            alignment: Alignment.topLeft,
                            child: Container(

                              width: double.infinity,
                              color: Colors.transparent,
                              padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 2),
                              child:Column(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(17.0),
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            color:Colors.white,
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              placeholder: 'assets/images/empty.png',
                                              image: "$BASE_URL"+ response["channel_name_info"]["channel_name_logo"],
                                              imageErrorBuilder: (context, url, error) =>
                                                  Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.fill,
                                                  ),
                                            )),

                                      ),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: Container(
                                          padding:
                                          EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            response["channel_name_info"]["channel_name"],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                            softWrap: false,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Container(
                                        //height: 40,
                                        width: 30,
                                      ),
                                      SizedBox(width: 5,),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text(
                                              response["course_duration"].toString()+"min",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                              softWrap: false,
                                              maxLines: 1,
                                            ),
                                          ],

                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                            ))
                      ]),
                )
            ),


            Container(
              margin:  EdgeInsets.only(left: 7.0, right: 7.0,bottom: 10,top: 100),
              //width: 180,
              decoration: new BoxDecoration(
                color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(

                  color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):intello_bg_color_for_darkMode,
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
              //   height: 150,
              child: Container(
                margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 10,left: 10),
                // height: double.infinity,
                // width: double.infinity,
                child: Center(
                  child:Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          response["course_title"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          softWrap: false,
                          maxLines:1,
                        ),
                      ),

                      SizedBox(height: 5,),
                      Flex(direction: Axis.horizontal,
                        children:  [
                          Expanded(child: Text(
                            "72 Participants",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: intello_hint_color,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            softWrap: false,
                            maxLines:1,
                          )),
                          Text(
                            "\$"+response['course_price_info'][0]["new_price"].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:_darkOrLightStatus == 1 ? intello_bg_color:Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            softWrap: false,
                            maxLines:1,
                          )

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                RatingBarIndicator(
                                  rating:double.parse(response["avg_rating"]),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color:intello_star_color,
                                  ),
                                  itemCount: 5,
                                  itemSize: 17.0,
                                  direction: Axis.horizontal,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  response["avg_rating"].toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: intello_hint_color,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Flex(direction: Axis.horizontal,
                        children:  [
                          Expanded(child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 7),
                                child: InkResponse(
                                  onTap: (){},
                                  child:Image.asset('assets/images/icon_level.png',
                                    height: 25,
                                    width: 25,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 7),
                                child: InkResponse(
                                  onTap: (){},
                                  child:Image.asset('assets/images/icon_share.png',
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.fill
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 7),
                                child: InkResponse(
                                  onTap: (){},
                                  child:Image.asset('assets/images/icon_certificate.png',
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ],
                          )),
                          Align(alignment: Alignment.topRight,
                            child:   Container(
                              margin: const EdgeInsets.only(right: 7),
                              child: InkResponse(
                                onTap: (){},
                                child:Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child:  Wrap(
                              direction: Axis.horizontal,
                              children: [

                                Container(
                                  margin: const EdgeInsets.only(right: 3),
                                  child: InkResponse(
                                    onTap: (){},
                                    child:Image.asset('assets/images/btn_enroll.png',
                                      width: 60,
                                      height: 25,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ) ,
            ),



          ],
        ) ,
      ),
    );
  }
  //shimmer
  Widget _buildRecentlyAddedCourseItemShimmer({required double item_marginLeft,required double item_marginRight}) {
    return Container(
      margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10,top: 15),
      width: 250,
      child: Stack(
        children: [
          Container(
            //width: 180,
            // margin: EdgeInsets.only(right: 10.0, top: 0, bottom: 10, left: 10),
              decoration: new BoxDecoration(
                color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(

                  color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):shimmer_containerBgColorDark1,
                  //  blurRadius: 20.0, // soften the shadow
                  blurRadius: _darkOrLightStatus == 1?20:6, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: _darkOrLightStatus == 1 ? Offset(
                    2.0, // Move to right 10  horizontally
                    1.0, // Move to bottom 10 Vertically
                  ):
                  Offset(
                    1.0, // Move to right 10  horizontally
                    1.0, // Move to bottom 10 Vertically
                  ),
                )],
              ),
              child: SizedBox(
                height: 150,
                child: Stack(children: <Widget>[

                  Center(
                    child: Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                      child:Container(
                        margin: EdgeInsets.only(right: 20.0,left: 20,bottom: 10),
                        decoration: BoxDecoration(
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),

                          ),
                        ),
                        height: 50,
                        width: double.infinity,


                      ),
                    ),
                  ),

                  Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 7, bottom: 2),
                        child: Column(
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Shimmer.fromColors(
                                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                  child:Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),

                                      ),
                                    ),
                                    height: 30,
                                    width: 30,


                                  ),
                                ),

                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child:  Column(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                          child:Container(
                                            margin: EdgeInsets.only(right: 20.0,),
                                            color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                            height: 12,
                                            width: double.infinity,


                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        Shimmer.fromColors(
                                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                          child:Container(
                                            margin: EdgeInsets.only(right: 20.0,),
                                            color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                            height: 12,
                                            width: double.infinity,


                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ))
                ]),
              )),




          Container(
            margin:  EdgeInsets.only(left: 7.0, right: 7.0,bottom: 10,top: 103),
            //width: 180,
            // decoration: new BoxDecoration(
            //   color:shimmer_baseColor1,
            //   borderRadius: BorderRadius.circular(12),
            //
            // ),
            decoration: new BoxDecoration(
              color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark1,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(
                color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):shimmer_containerBgColorDark.withOpacity(.25),
                //  blurRadius: 20.0, // soften the shadow
                blurRadius: _darkOrLightStatus == 1?20:20, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: _darkOrLightStatus == 1 ? Offset(
                  2.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ):
                Offset(
                  2.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ),
              )],
            ),
            //   height: 150,
            child: Container(
              margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 10,left: 10),
              // height: double.infinity,
              // width: double.infinity,
              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child:  Shimmer.fromColors(
                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                        child:Container(
                          margin: EdgeInsets.only(right: 5.0,left: 5,bottom: 0),
                          decoration: BoxDecoration(
                            color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          ),
                          height: 15,
                          width: double.infinity,


                        ),
                      ),
                    ),

                    SizedBox(height: 5,),
                    Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                      child:Container(
                        margin: EdgeInsets.only(right: 5.0,left: 5,bottom: 0),
                        decoration: BoxDecoration(
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        ),
                        height: 15,
                        width: double.infinity,


                      ),
                    ),
                    SizedBox(height: 5,),
                    Shimmer.fromColors(
                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                      child:Container(
                        margin: EdgeInsets.only(right: 70.0,left: 5,bottom: 0),
                        decoration: BoxDecoration(
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        ),
                        height: 15,
                        width: double.infinity,


                      ),
                    ),
                    SizedBox(height: 5,),
                    Flex(direction: Axis.horizontal,
                      children:  [
                        Expanded(child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Shimmer.fromColors(
                              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                              child:Container(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                ),

                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                              child:Container(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                ),

                              ),
                            ),

                            Shimmer.fromColors(
                              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                              child:Container(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                ),

                              ),
                            )
                          ],
                        )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                            child:Container(
                              width: 25,
                              height: 25,
                              margin: EdgeInsets.only(right: 5.0,left: 5,bottom: 0),
                              decoration: BoxDecoration(
                                color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              ),

                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                            child:Container(
                              width: 60,
                              height: 25,
                              margin: EdgeInsets.only(right: 5.0,left: 5,bottom: 0),
                              decoration: BoxDecoration(
                                color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ) ,
          ),



        ],
      ) ,
    );
  }
  Widget _buildTopCategoriesItemShimmer({required double item_marginLeft,required double item_marginRight}) {
    return Container(
      margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10),
      width: 150,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
            child:Container(
              height: 120,
              //  width: 65,
              decoration: BoxDecoration(
                color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),

                ),
              ),
            ),
          ),



        ],
      ) ,
    );
  }
  Widget _buildNewsFeedListItemShimmer() {
    return Container(
      margin:  EdgeInsets.only(right: 16.0, top: 10, bottom: 10, left: 16),

      decoration: new BoxDecoration(
        color:_darkOrLightStatus == 1 ? Colors.white: intello_bg_color_for_darkMode,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(

          color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):intello_bg_color_for_darkMode,
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
      //   height: 150,
      child: Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            //teacher profile
            Container(
              margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
              child: Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    padding:
                    const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Shimmer.fromColors(
                              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),

                                  ),
                                ),
                              ),
                            ),


                            SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Column(
                                children: [

                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Shimmer.fromColors(
                                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                      child: Container(
                                        height: 15,
                                        //  width: 65,
                                        decoration: BoxDecoration(
                                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2.0),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Shimmer.fromColors(
                                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                      child: Container(
                                        height: 15,
                                        //  width: 65,
                                        decoration: BoxDecoration(
                                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2.0),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  )),
            ),

            Container(
              margin: EdgeInsets.only(left: 0.0, right: 60.0, top: 5),
              child: Align(alignment: Alignment.topLeft,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 20,
                      //  width: 65,
                      decoration: BoxDecoration(
                        color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.0),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0.0, right: 00.0, top: 5),
              child: Align(alignment: Alignment.topLeft,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 40,
                      //  width: 65,
                      decoration: BoxDecoration(
                        color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.0),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0.0, right: 00.0, top: 5),
              child: Align(alignment: Alignment.topLeft,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 100,
                      //  width: 65,
                      decoration: BoxDecoration(
                        color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.0),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),



            Container(
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20,bottom: 15),
              child:Flex(direction: Axis.horizontal,
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 0),
                    child: Align(alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Shimmer.fromColors(
                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                          child: Container(
                            height: 30,
                            //  width: 65,
                            decoration: BoxDecoration(
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    flex: 1,
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                    child: Align(alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Shimmer.fromColors(
                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                          child: Container(
                            height: 30,
                            //  width: 65,
                            decoration: BoxDecoration(
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    flex: 1,
                  ),



                ],
              ) ,
            ),
            Container(
              height: 1,
              color: intello_hint_color,
            ),

            Container(
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20,bottom: 15),
              child:Flex(direction: Axis.horizontal,
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 0),
                    child: Align(alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Shimmer.fromColors(
                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                          child: Container(
                            height: 30,
                            //  width: 65,
                            decoration: BoxDecoration(
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    flex: 2,
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                    child: Align(alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Shimmer.fromColors(
                          baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                          child: Container(
                            height: 30,
                            //  width: 65,
                            decoration: BoxDecoration(
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    flex: 2,
                  ),
                  Expanded(child: Container(

                  ),
                    flex: 1,
                  ),


                ],
              ) ,
            ),


          ],
        ),
      ),
    );
  }

  Widget eventsListShimmer() {
    return  ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return  Container(
            margin: EdgeInsets.only(right: 10.0, top: 10, bottom: 10, left: 10),
            //color: Colors.white,
            child: SizedBox(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                    child:ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 90,
                          width: 90,
                          color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                        )),


                  ),

                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Align(alignment: Alignment.topLeft,
                              child:  Shimmer.fromColors(
                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                child:Container(
                                  height: 30,
                                  // width: 130,
                                  color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            Row(
                              children: [
                                Expanded(child:  Shimmer.fromColors(
                                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                  child:Container(
                                    height: 15,
                                    // width: 130,
                                    color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                  ),
                                )),

                                Expanded(child:  Container()),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            Flex(
                              direction: Axis.horizontal,
                              children:  [
                                Expanded(
                                    child: Flex(direction: Axis.vertical,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Shimmer.fromColors(
                                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                            child:Container(
                                              height: 15,
                                              width: 150,
                                              color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child:Flex(direction: Axis.horizontal,
                                              children: [
                                                Expanded(child:  Shimmer.fromColors(
                                                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                                  child:Container(
                                                    height: 15,
                                                    width: 150,
                                                    color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                                  ),
                                                ),),
                                                SizedBox(width: 7,)
                                              ],
                                            )
                                        ),

                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 0, top: 10, bottom: 0),
                                  child:Align(alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 27,
                                      width: 70,
                                      // color:Colors.white,
                                      child: Shimmer.fromColors(
                                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                        child:Container(
                                          height: 15,
                                          width: 150,
                                          color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildFeaturedDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 22.0, right: 22.0, top: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Featured Trainings",
              style: TextStyle(
                  color: _darkOrLightStatus==1? intello_text_color:Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 10),
          child:Container(
            margin: const EdgeInsets.only(top: 10),
            height:170.0,

            // child: _buildRecentlyAddedCourseItem(),
            child: ListView.builder(
              //itemCount: offerDataList == null ? 0 : offerDataList.length,
              itemCount: _get_teacher_public_profile_featured==null||_get_teacher_public_profile_featured.length<=0?0:
              _get_teacher_public_profile_featured.length,
              itemBuilder: (context, index) {
                if(index==0){
                  return _buildFeaturedItem(item_marginLeft:20,item_marginRight: 0,response: _get_teacher_public_profile_featured[index]);
                }
                //length
                if(index==_get_teacher_public_profile_featured.length-1){
                  return _buildFeaturedItem(item_marginLeft:15,item_marginRight: 20,response: _get_teacher_public_profile_featured[index]);
                }

                else{
                  return _buildFeaturedItem(item_marginLeft:15,item_marginRight: 00,response: _get_teacher_public_profile_featured[index]);
                }
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedItem({required double item_marginLeft,required double item_marginRight, required var response}) {
    return Container(
      margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10),
      width: 150,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.assetNetwork(
                height: 150,
                width: 150,
                fit: BoxFit.fill,
                placeholder: 'assets/images/loading.png',
                image: "$BASE_URL"+response["image"].toString(),
                imageErrorBuilder: (context, url, error) =>
                    Image.asset(
                      'assets/images/loading.png',
                      fit: BoxFit.fill,
                    ),
              )
          ),

        ],
      ) ,
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      itemCount: _get_teacher_public_profile_course_seminar==null||_get_teacher_public_profile_course_seminar.length<=0?0:
      _get_teacher_public_profile_course_seminar.length,
      // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildEventsItemList(_get_teacher_public_profile_course_seminar[index]);
      },
    );
  }

  Widget _buildEventsItemList1() {
    return InkResponse(
        onTap: (){
          // _showToast("ok");
        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen()));
        },
        child:  Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.15),
                blurRadius: 20.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: Offset(
                  2.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(right: 15.0, top: 10, bottom: 10, left: 15),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(right: 5.0, top: 0, bottom: 0, left: 0),
                  color: Colors.white,
                  child: Container(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Stack(children: <Widget>[
                                FadeInImage.assetNetwork(
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.fill,
                                  placeholder: 'assets/images/loading.png',
                                  image:
                                  "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                                  imageErrorBuilder: (context, url, error) =>
                                      Image.asset(
                                        'assets/images/loading.png',
                                        fit: BoxFit.fill,
                                      ),
                                ),

                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                    ),
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        color: intello_star_color,
                                        child:Align(
                                          alignment: Alignment.center,
                                          child:  Flex(direction: Axis.vertical,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "30",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                  softWrap: false,
                                                  maxLines: 1,
                                                ) ,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "August",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.normal),
                                                  softWrap: false,
                                                  maxLines: 1,
                                                ),
                                              ),


                                            ],

                                          ),
                                        )),
                                  ),
                                )


                              ]),
                            )),
                        SizedBox(
                          width: 13,
                        ),
                        Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Flex(
                                direction: Axis.vertical,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Unleash Your Potential In 3 Days",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:intello_text_color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                      maxLines: 1,
                                    ),

                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Paris",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:intello_bg_color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: const [
                                      Expanded(
                                          child: Text(
                                            "Hall Gare Du Nord",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: intello_color_green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                            softWrap: false,
                                            maxLines: 1,
                                          )),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children:  [
                                      Image(
                                        image: AssetImage(
                                          'assets/images/icon_user.png',
                                        ),
                                        height: 16,
                                        width: 20,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        "1703",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:intello_hint_color,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                      Expanded(
                                          child: Align(alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 10, top: 0, bottom: 0),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: InkResponse(
                                                  onTap: (){
                                                    _showToast("clicked");
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 80,
                                                    color:intello_bg_color,
                                                    child: Align(alignment: Alignment.center,
                                                      child:  Text("Book Now",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400)
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          )

                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )),
        )
    );
  }

  Widget _buildEventsItemList(var response) {
    return InkResponse(
        onTap: (){
          // _showToast("ok");
          //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen()));
        },
        child:Container(
          margin:  EdgeInsets.only(right: 16.0, top: 10, bottom: 15, left: 16),
          decoration: new BoxDecoration(
            color:_darkOrLightStatus == 1 ? Colors.white:intello_bg_color_for_darkMode,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(

              color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):intello_bg_color_for_darkMode,
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
          //   height: 150,
          child: Container(
            padding: const EdgeInsets.only(left: 0.0, right: 15.0),
            child:  Container(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 110,
                        width: 110,
                        child: Stack(children: <Widget>[
                          FadeInImage.assetNetwork(
                            height: 110,
                            width: 110,
                            fit: BoxFit.fill,
                            placeholder: 'assets/images/loading.png',
                            image:
                            "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                            imageErrorBuilder: (context, url, error) =>
                                Image.asset(
                                  'assets/images/loading.png',
                                  fit: BoxFit.fill,
                                ),
                          ),

                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                              ),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  color:intello_star_color,
                                  child:Align(
                                    alignment: Alignment.center,
                                    child:  Flex(direction: Axis.vertical,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "30",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            softWrap: false,
                                            maxLines: 1,
                                          ) ,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "August",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal),
                                            softWrap: false,
                                            maxLines: 1,
                                          ),
                                        ),


                                      ],

                                    ),
                                  )),
                            ),
                          )


                        ]),
                      )),
                  SizedBox(
                    width: 13,
                  ),
                  Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  response["course_seminar_title"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:_darkOrLightStatus == 1 ?intello_text_color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                softWrap: false,
                                maxLines: 1,
                              ),

                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                response["city_info"]["city_name"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:intello_bg_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                    child: Text(
                                      response["location"].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:intello_color_green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      softWrap: false,
                                      maxLines: 1,
                                    )),

                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children:  [
                                Image(
                                  image: AssetImage(
                                    'assets/images/icon_user.png',
                                  ),
                                  color:_darkOrLightStatus == 1 ? intello_bold_text_color:intello_hint_color,
                                  height: 16,
                                  width: 20,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "1703",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:intello_hint_color,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                                Expanded(
                                    child: Align(alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 10, top: 0, bottom: 0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: InkResponse(
                                              onTap: (){
                                                _showToast("clicked");
                                              },
                                              child: Container(
                                                height: 28,
                                                width: 80,
                                                color:intello_bg_color,
                                                child: Align(alignment: Alignment.center,
                                                  child:  Text("Book Now",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400)
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    )

                                ),

                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),

                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        )
    );
  }
  //news feed section
  Widget _buildNewsFeedList() {
    return Flex(direction: Axis.vertical,
    children: [
      if(_blogPostShimmerStatus)...{
        ListView.builder(
          itemCount:2,
          // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildNewsFeedListItemShimmer();
          },
        )
      }
      else...{
        ListView.builder(
          itemCount: _get_teacher_public_profile_blog_post==null||_get_teacher_public_profile_blog_post.length<=0?0:
          _get_teacher_public_profile_blog_post.length,
          // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildNewsFeedListItem(_get_teacher_public_profile_blog_post[index]);
          },
        )
      }

    ],
    );


  }

  Widget _buildNewsFeedListItem(var response) {
    return InkResponse(
      onTap: (){
        //Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen()));

      },
      child: Container(
        margin:  EdgeInsets.only(right: 16.0, top: 10, bottom: 10, left: 16),

        decoration: new BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white: intello_bg_color_for_darkMode,

          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(

            color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):intello_bg_color_for_darkMode,
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
        //   height: 150,
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              //teacher profile
              Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            InkResponse(
                              onTap: () {
                              //  Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen()));
                                // _showToast("Pik clicked");
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Container(
                                    height: 45,
                                    width: 45,
                                    color:intello_bd_color,
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/images/empty.png',
                                      image:
                                      _get_teacher_public_profile_blogpost_response["image"].toString(),
                                      imageErrorBuilder: (context, url, error) =>
                                          Image.asset(
                                            'assets/images/empty.png',
                                            fit: BoxFit.fill,
                                          ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      _get_teacher_public_profile_blogpost_response["surname"].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:_darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            response["when_published_blog_post"].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color:intello_hint_color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            softWrap: false,
                                            maxLines: 1,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                              size: 25.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 5),
                child: Align(alignment: Alignment.topLeft,
                  child: Text(
                    "#event, #learning",
                    style: TextStyle(
                        color:intello_color_tag_text,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    response["title"].toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                )


              ),
              Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child:InkResponse(
                      onTap: (){

                       // Navigator.push(context,MaterialPageRoute(builder: (context)=>VideoPlayPreviousPageScreen()));
                      },

                      child:  SizedBox(
                        height: 175,
                        child: FadeInImage.assetNetwork(
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          placeholder: 'assets/images/loading.png',
                          image:"$BASE_URL"+response["image"].toString()
                          ,
                          imageErrorBuilder: (context, url, error) =>
                              Image.asset(
                                'assets/images/loading.png',
                                fit: BoxFit.fill,
                              ),
                        ),
                      ),
                    )),
              ),

              Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20,bottom: 15),
                child:Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Flex(direction: Axis.horizontal,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 25.0, right: 00.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                    height: 25,
                                    width: 25,
                                    color:intello_bd_color,
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/images/empty.png',
                                      image:
                                      "https://i.pinimg.com/236x/44/59/80/4459803e15716f7d77692896633d2d9a--business-headshots-professional-headshots.jpg",
                                      imageErrorBuilder: (context, url, error) =>
                                          Image.asset(
                                            'assets/images/empty.png',
                                            fit: BoxFit.fill,
                                          ),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 13.0, right: 00.0),
                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                    height: 25,
                                    width: 25,
                                    color:intello_bd_color,
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/images/empty.png',
                                      image:
                                      "https://monirulakand.com/static/media/monirul.27ff4fe8d0724c3f68a4.png",
                                      imageErrorBuilder: (context, url, error) =>
                                          Image.asset(
                                            'assets/images/empty.png',
                                            fit: BoxFit.fill,
                                          ),
                                    )),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                  height: 25,
                                  width: 25,
                                  color:intello_bd_color,
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/images/empty.png',
                                    image:
                                    "https://i.pinimg.com/236x/44/59/80/4459803e15716f7d77692896633d2d9a--business-headshots-professional-headshots.jpg",
                                    imageErrorBuilder: (context, url, error) =>
                                        Image.asset(
                                          'assets/images/empty.png',
                                          fit: BoxFit.fill,
                                        ),
                                  )),
                            )


                          ],
                        ),

                        SizedBox(width: 10,),
                        Text(
                          "1125 Likes",
                        //  response["blog-post_like_info"][0]["likes"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ],
                    ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Align(alignment: Alignment.centerRight,
                        child: Wrap(direction: Axis.horizontal,
                          children: [
                            SizedBox(width: 20,),
                            Text(
                              "23 Comments",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              softWrap: false,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      flex: 1,
                    )



                  ],
                ) ,
              ),
              Container(
                height: 1,
                color: intello_hint_color,
              ),

              Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15,bottom: 20),
                child:Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Flex(direction: Axis.horizontal,
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/heart.png',
                          ),
                          height: 22,
                          width: 22,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "like",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ],
                    ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Flex(direction: Axis.horizontal,
                        children: [
                          SizedBox(width: 20,),
                          Image(
                            image: AssetImage(
                              'assets/images/icon_comment.png',
                            ),
                            height: 22,
                            width: 22,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "Comment",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            softWrap: false,
                            maxLines: 1,
                          )
                        ],
                      ),
                      flex: 2,
                    )



                  ],
                ) ,
              )


            ],
          ),
        ),
      ),

    );
  }

  Widget _buildTabButton() {
    return Container(
      color: _darkOrLightStatus == 1 ?Colors.white:intello_bottom_bg_color_for_dark,
        // intello_bg_color_for_darkMode
      padding: EdgeInsets.only(
        top: 10.0,left: 15,right: 15,bottom: 10
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [

          Expanded(
            child: InkResponse(
              onTap: () {
                setState(() {
                  if(_darkOrLightStatus==1){
                    aboutTextColor = Colors.white;
                    newsfeedTextColor = Colors.black;
                    eventsTextColor = Colors.black;
                    aboutTabColor = intello_bd_color;
                    newsfeedTabColor = tabColor;
                    eventsTabColor = tabColor;
                    des_rev_less_status = 1;
                  }
                  else{
                    aboutTextColor = Colors.white;
                    newsfeedTextColor = Colors.white;
                    eventsTextColor = Colors.white;
                    aboutTabColor = intello_bd_color;
                    newsfeedTabColor = intello_bg_color_for_darkMode;
                    eventsTabColor = intello_bg_color_for_darkMode;
                    des_rev_less_status = 1;
                  }

                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                margin: const EdgeInsets.only(left: 0.0, right: 5.0),
                decoration: BoxDecoration(
                  color: aboutTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "About",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: aboutTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkResponse(
              onTap: () {
                setState(() {

                  if(_darkOrLightStatus==1){
                    aboutTextColor = Colors.black;
                    newsfeedTextColor = Colors.white;
                    eventsTextColor = Colors.black;
                    aboutTabColor = tabColor;
                    newsfeedTabColor =intello_bg_color;
                    eventsTabColor = tabColor;
                    des_rev_less_status = 2;
                  }
                  else{
                    aboutTextColor = Colors.white;
                    newsfeedTextColor = Colors.white;
                    eventsTextColor = Colors.white;
                    aboutTabColor = intello_bg_color_for_darkMode;
                    newsfeedTabColor = intello_bd_color;
                    eventsTabColor = intello_bg_color_for_darkMode;
                    des_rev_less_status = 2;
                  }


                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 5.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: newsfeedTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Newsfeed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: newsfeedTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkResponse(
              onTap: () {
                setState(() {

                  if(_darkOrLightStatus==1){
                    aboutTextColor = Colors.black;
                    newsfeedTextColor = Colors.black;
                    eventsTextColor = Colors.white;
                    aboutTabColor = tabColor;
                    newsfeedTabColor = tabColor;
                    eventsTabColor = intello_bg_color;
                    des_rev_less_status = 3;
                  }
                  else{
                    aboutTextColor = Colors.white;
                    newsfeedTextColor = Colors.white;
                    eventsTextColor = Colors.white;
                    aboutTabColor = intello_bg_color_for_darkMode;
                    newsfeedTabColor = intello_bg_color_for_darkMode;
                    eventsTabColor = intello_bd_color;
                    des_rev_less_status = 3;
                  }


                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 5.0, right: 0.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: eventsTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Events",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: eventsTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: intello_bg_color,
        textColor: Colors.black,
        fontSize: 16.0);
  }

//
  _teacher_public_profile_List() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         _headerShimmerStatus = true;

        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );


          if (response.statusCode == 200) {
            setState(() {
              _headerShimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_response = data["data"];
              _coverImage=_get_teacher_public_profile_response["cover_image"].toString();
              _teacherName=_get_teacher_public_profile_response["username"].toString();
              _avarageRating=double.parse(_get_teacher_public_profile_response["avg_rating"].toString());
              _aboutTitle=_get_teacher_public_profile_response["about_info"][0]["about_title"].toString();

              _profileImage=_get_teacher_public_profile_response["image"].toString();

            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }

//
  _teacher_public_profile_about() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _aboutShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile_about$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );



          if (response.statusCode == 200) {
            setState(() {
              _aboutShimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_about_response = data["data"];
              _ProfileAbout=_get_teacher_public_profile_about_response["about_info"][0]["about"].toString();
            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }

//
  _teacher_public_profile_featured() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile_featured$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
        //  _showToast(response.statusCode.toString()+"aqwq");

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_featured = data["data"]["featured_info"];
            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }

//
  _teacher_public_profile_course() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile_course$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );


          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_course = data["data"]["course_info"];
            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }
//
  _teacher_public_profile_blog_post() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _blogPostShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile_blog_post$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );

          if (response.statusCode == 200) {
            setState(() {
              _blogPostShimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_blogpost_response = data["data"];
              _get_teacher_public_profile_blog_post = data["data"]["blog-post_info"];
            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }


  _teacher_public_profile_course_seminar() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Teacher_public_profile_course_seminar$_teacherId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );

         // _showToast(response.statusCode.toString()+"ddd");
          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _get_teacher_public_profile_course_seminar = data["data"]["seminar_info"];
            });
          }
          else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          // Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
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
