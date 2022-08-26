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

class CourseDetailsScreen extends StatefulWidget {
  String courseId;
  CourseDetailsScreen({required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState(this.courseId);
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {

  String _courseId;

  _CourseDetailsScreenState(
      this._courseId);


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
  int _darkOrLightStatus=1;
  bool _videoShimmerStatus=true;
  bool _descriptionShimmerStatus=true;
  bool _lessonsShimmerStatus=true;
  bool _reviewShimmerStatus=true;
  @override
  @mustCallSuper
  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {

      _Course_single_responseList();
      _Course_description_response_List();
      _single_course_review_response_List();
      _Course_REVIEW_feedback_List();


      if(_darkOrLightStatus==1){
        descriptionTextColor = Colors.white;
        lessonsTextColor =intello_text_color;
        reviewTextColor = intello_text_color;
        descriptionTabColor =intello_bg_color;
        lessonsTabColor = tabColor;
        reviewTabColor =tabColor;
        des_rev_less_status = 1;
      }
      else{
        descriptionTextColor = Colors.white;
        lessonsTextColor = Colors.white;
        reviewTextColor = Colors.white;
        descriptionTabColor =intello_bg_color;
        lessonsTabColor = intello_dark_bg_color;
        reviewTabColor = intello_dark_bg_color;
        des_rev_less_status = 1;
      }


    });




  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
              height: screenHeight / 15,
            ),
            Flex(
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
                  margin: new EdgeInsets.only(right: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Course Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: screenHeight / 25,
            ),
            Expanded(
              child: _buildBottomDesign(),
            ),
          ],
        ),

        /* add child content here */
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
          margin:  EdgeInsets.only(left: 0, top: 15, right:0, bottom: 0),
          child:  Column(
            children: [
              // SizedBox(
              //   height: 10,
              // ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                       if(_videoShimmerStatus)...{
                         _buildCourseVideoShimmer(),
                         Container(
                           margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                           child:  Shimmer.fromColors(
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
                       }
                       else...{
                         Container(

                           margin:  EdgeInsets.only(left: 15, top: 10, right:15, bottom: 0),
                           child: ClipRRect(
                               borderRadius: BorderRadius.circular(25.0),
                               child:InkResponse(
                                 onTap: (){

                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>VideoPlayPreviousPageScreen()));
                                 },

                                 child:  SizedBox(
                                   height: 220,
                                   child: Stack(children: <Widget>[
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
                                     Center(
                                       child: Image.asset(
                                         "assets/images/play.png",
                                         height: 80,
                                         width: 80,
                                         fit: BoxFit.fill,
                                       ),
                                     ),
                                   ]),
                                 ),
                               )),
                         ),
                         Container(
                           margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                           child: Text(
                             _courseTitle,
                             style: TextStyle(
                                 color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                         Container(
                           margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                           child: _buildTrainerInfoSection(),
                         ),
                       },




                        Container(
                          margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                          child: _buildTabButton(),
                        ),



                        if (des_rev_less_status == 1) ...{
                          Container(
                            margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                            child:_buildDescriptionDesign() ,
                          ),

                        }
                        else if (des_rev_less_status == 2) ...{
                          Container(
                            margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                            child:_buildLessonsDesign(),
                          ),

                        }
                        else if (des_rev_less_status == 3) ...{
                          Container(
                            margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                            child:_buildDescriptionReviewLessonsDesign(),
                          ),


                        }
                        else ...{
                          Container(
                            margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
                            child:_buildDescriptionDesign(),
                          ),


                        }
                      ],
                    ),
                  )),
              _buildEnrollNowField(),
            ],
          ),
        )
    );
  }


  //description
  Widget _buildDescriptionDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //shimmer design
        if(_descriptionShimmerStatus)...{
          Row(
            children: [
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 25,
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
              ),),
              Expanded(child: Container(),)
            ],
          ),
          
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 25,
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
              ),),
              Expanded(child: Container(),)
            ],
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
        }
        else...{
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: TextStyle(
                    color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,

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
                _courseDescription,
                style: TextStyle(
                    color:intello_hint_color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What will you learn:",
                style: TextStyle(
                    color:_darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildWhatYouWillLearnList(),
        },

      ],
    );
  }


  Widget _buildDescriptionReviewLessonsDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(_reviewShimmerStatus)...{
          Row(
            children: [
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 25,
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
              ),),
              Expanded(child: Container(),)
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 85,
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
              ),),
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 85,
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
              ),),
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 85,
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
              ),),
            ],
          ),

          Row(
            children: [
              Expanded(child: Container(

                margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                    highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                    child: Container(
                      height: 25,
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
              ),),
              Expanded(child: Container(),)
            ],
          ),
          Container(

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 50,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
           // margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
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

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 70,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            // margin:  EdgeInsets.only(left: 15, top: 15, right:15, bottom: 0),
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

            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child: Container(
                  height: 70,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),

                    ),
                  ),
                ),
              ),
            ),
          ),
        }else...{
          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Student Feedback",
                style: TextStyle(
                    color: _darkOrLightStatus==1?intello_bold_text_color:Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Flex(
            direction: Axis.horizontal,
            children: [
              Container(

                width: 85,
                height: 85,
                margin: const EdgeInsets.only(left: 0.0, right: 5.0),
                decoration: BoxDecoration(
                  color:intello_bg_color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Wrap(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(

                          _course_review_feedback_response["avg_rating"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold),
                        ),
                      ),


                      SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child:RatingBarIndicator(
                          // rating:_course_review_feedback_response["avg_rating"],
                          rating:double.parse(_course_review_feedback_response["avg_rating"].toString()
                          ),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_star_color,
                          ),
                          unratedColor: Colors.white,
                          itemCount: 5,
                          itemSize: 8.0,
                          direction: Axis.horizontal,
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child:Text(
                          "Course Ratings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.normal),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child:  LinearPercentIndicator(
                          //width: MediaQuery.of(context).size.width/3.9,
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration: 1000,
                          percent: _course_review_feedback_response["five_rating_percentage"]/100,
                          backgroundColor: intello_unrated_color_for_light,
                          center: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor:intello_indicator_color,
                        ),),
                        RatingBarIndicator(
                          rating: 5,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_indicator_color,
                          ),
                          itemCount: 5,
                          unratedColor: intello_unrated_color_for_light,
                          itemSize: MediaQuery.of(context).size.width / 23,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          _course_review_feedback_response["five_rating_percentage"].toString()+"%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child:  LinearPercentIndicator(
                          //width: MediaQuery.of(context).size.width/3.9,
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration: 1000,
                          percent: _course_review_feedback_response["four_rating_percentage"]/100,
                          backgroundColor: intello_unrated_color_for_light,
                          center: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor:intello_indicator_color,
                        ),),
                        RatingBarIndicator(
                          rating: 4,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_indicator_color,
                          ),
                          itemCount: 5,
                          unratedColor:intello_unrated_color_for_light,
                          itemSize: MediaQuery.of(context).size.width / 23,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          _course_review_feedback_response["four_rating_percentage"].toString()+"%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child:  LinearPercentIndicator(
                          //width: MediaQuery.of(context).size.width/3.9,
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration: 1000,
                          percent: _course_review_feedback_response["three_rating_percentage"]/100,
                          backgroundColor: intello_unrated_color_for_light,
                          center: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor:intello_indicator_color,
                        ),),
                        RatingBarIndicator(
                          rating: 3,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_indicator_color,
                          ),
                          itemCount: 5,
                          unratedColor:intello_unrated_color_for_light,
                          itemSize: MediaQuery.of(context).size.width / 23,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          _course_review_feedback_response["three_rating_percentage"].toString()+"%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child:  LinearPercentIndicator(
                          //width: MediaQuery.of(context).size.width/3.9,
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration: 1000,
                          percent: _course_review_feedback_response["two_rating_percentage"]/100,
                          backgroundColor: intello_unrated_color_for_light,
                          center: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor:intello_indicator_color,
                        ),),
                        RatingBarIndicator(
                          rating: 2,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_indicator_color,
                          ),
                          itemCount: 5,
                          unratedColor: intello_unrated_color_for_light,
                          itemSize: MediaQuery.of(context).size.width / 23,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          _course_review_feedback_response["two_rating_percentage"].toString()+"%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(child:  LinearPercentIndicator(
                          //width: MediaQuery.of(context).size.width/3.9,
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration: 1000,
                          percent: _course_review_feedback_response["one_rating_percentage"]/100,
                          backgroundColor: intello_unrated_color_for_light,
                          center: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor:intello_indicator_color,
                        ),),

                        RatingBarIndicator(
                          rating: 1,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color:intello_indicator_color,
                          ),
                          itemCount: 5,
                          unratedColor: intello_unrated_color_for_light,
                          itemSize: MediaQuery.of(context).size.width / 23,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          _course_review_feedback_response["one_rating_percentage"].toString()+"%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),

          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 20,bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reviews",
                style: TextStyle(
                    color: _darkOrLightStatus==1?intello_bold_text_color:Colors.white,

                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 0.0, top: 20, bottom: 5, left:0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _darkOrLightStatus==1?Colors.white:intello_dark_bg_color,

              border: Border.all(
                  color: _darkOrLightStatus==1?Color(0xFFCCCCCC):intello_dark_bg_color,
                  // Set border color
                  width: 0.5),   // Set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // Set rounded corner radius
              // Make rounded corner of border
            ),
            padding: EdgeInsets.only(right: 5.0, top: 5, bottom: 5, left: 5),

            child: Flex(
              direction: Axis.horizontal,
              children: [

                SizedBox(
                  width: 10,
                ),

                Expanded(
                  child:  userInputReviewSearch(_searchController!, 'Search Review', TextInputType.text),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10,left: 10),
                  width: 1,
                  height: 30,
                  color:intello_hint_color,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: _buildDropDownMenu(),
                ),
              ],
            ),
          ),

          _buildReviewList(),
        }

      ],
    );
  }

  Widget userInputReviewSearch(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return TextField(
      controller: userInput,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor:intello_input_text_color,
      autofocus: false,
      onSubmitted: (value) {
        _reviewSearchValue = _searchController!.text;
        _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);

      },
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIconConstraints: BoxConstraints(
          minHeight: 15,
          minWidth: 15,
        ),



        // suffixIcon: Icon(Icons.email,color: Colors.hint_color,),

        hintText: hintTitle,
        hintStyle: const TextStyle(fontSize: 16, color:hint_color, fontStyle: FontStyle.normal),
      ),
      keyboardType: keyboardType,
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
        customItemsIndexes: const [5],
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
            case MenuItems.AllRatings:
              setState(() {
                countryName="All Ratings";

                _ratingValue="";

                _reviewSearchValue = _searchController!.text;
                _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);

              });

              //Do something
              break;
            case MenuItems.Ratings5:
              setState(() {
                countryName="5 Star";
                _ratingValue="5";
                _reviewSearchValue = _searchController!.text;
                _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);

              });
              //Do something
              break;
            case MenuItems.Ratings4:
              setState(() {
                countryName="4 Star";
                _ratingValue="4";
                _reviewSearchValue = _searchController!.text;
                _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);
              });
              break;
            case MenuItems.Ratings3:
              setState(() {
                countryName="3 Star";
                _ratingValue="3";
                _reviewSearchValue = _searchController!.text;
                _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);

              });
              break;
            case MenuItems.Ratings2:
              setState(() {
                countryName="2 Star";
                _ratingValue="2";
                _reviewSearchValue = _searchController!.text;
                _single_course_review_search_response_List(ratingValue: _ratingValue,reviewSearchValue: _reviewSearchValue);
              });
              break;
          }
          // MenuItems.onChanged(context, value as MenuItem);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 5, right: 5),
        //dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 0),
      ),
    );
  }

  Widget _buildDropButton() {
    return Container(
      width: 100,
      padding: EdgeInsets.only(left: 0,right: 0,top: 10,bottom: 10),
      child: Align(alignment: Alignment.centerRight,
      child: Wrap(
        children: [

          SizedBox(width: 5,),
          Text(
            countryName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color:hint_color,
            ),
          ),
          SizedBox(width: 0,),
          Icon(
            Icons.arrow_drop_down_sharp,
            color:hint_color,
            size: 18.0,
          ),
        ],
      ),
      ),
    );
  }

  //order list
  Widget _buildWhatYouWillLearnList() {
    return ListView.builder(
      itemCount: _course_what_will_you_learn_list==null||_course_what_will_you_learn_list.length<=0?0:
      _course_what_will_you_learn_list.length
      ,
      // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 0),
                        child: Image.asset(
                          _darkOrLightStatus == 1 ? "assets/images/check_circle.png":
                          "assets/images/check_circle_for_dark.png",

                          height: 25,
                          width: 25,

                          fit: BoxFit.fill,
                        ),
                      ),
                      // check_circle_for_dark.png
                      Expanded(
                          child: Text(
                            _course_what_will_you_learn_list[index]["course_learn_question"].toString(),

                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            softWrap: false,
                            maxLines: 1,
                          )),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 45.0, right: 0.0, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                          _course_what_will_you_learn_list[index]["course_learn_answer"].toString(),
                    style: TextStyle(
                        color:intello_hint_color,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewList() {
    return ListView.builder(

      itemCount: _course_review_response == null ? 0 : _course_review_response.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 15),
              child: Column(
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkResponse(
                          onTap: () {
                            _showToast("Pik clicked");
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                                height: 40,
                                width: 40,
                                color:intello_bg_color,
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/images/empty.png',
                                  image:
                                  "$BASE_URL"+ _course_review_response[index]["student_information"]["image"].toString(),
                                  imageErrorBuilder: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/empty.png',
                                    fit: BoxFit.fill,
                                  ),
                                )),
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
                              child: Text(
                                _course_review_response[index]["student_information"]["surname"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                            // Flex(
                            //   direction: Axis.horizontal,
                            //   children: [
                            //     Expanded(
                            //         child: Text(
                            //           dateConvert(_course_review_response[index][""].toString()),
                            //       overflow: TextOverflow.ellipsis,
                            //       style: TextStyle(
                            //           color:intello_hint_color,
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w500),
                            //       softWrap: false,
                            //       maxLines: 1,
                            //     )),
                            //   ],
                            // ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                RatingBarIndicator(
                                  rating:double.parse(_course_review_response[index]["rating"].toString()
                                  ),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: intello_indicator_color,
                                  ),
                                  itemCount: 5,
                                  itemSize: 17.0,
                                  direction: Axis.horizontal,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    _course_review_response[index]["whenpublished"].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 0.0, right: 0.0, top: 7),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _course_review_response[index]["review_description"].toString(),
                        style: TextStyle(
                            color:intello_hint_color,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 0.0, right: 0.0, top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Was this review helpful?",
                        style: TextStyle(
                            color:intello_hint_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/review_like.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/review_unlike.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      InkResponse(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                          child: Text(
                            "Report",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: intello_bg_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 0.0, right: 00.0, top: 10),
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color:intello_hint_color,
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildTabButton() {
    return Container(
      margin: EdgeInsets.only(
        top: 10.0,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: InkResponse(
              onTap: () {
                setState(() {

                  if(_darkOrLightStatus==1){
                    descriptionTextColor = Colors.white;
                    lessonsTextColor = intello_text_color;
                    reviewTextColor =intello_text_color;
                    descriptionTabColor =intello_bg_color;
                    lessonsTabColor =tabColor;
                    reviewTabColor =tabColor;
                    des_rev_less_status = 1;
                  }
                  else{
                    descriptionTextColor = Colors.white;
                    lessonsTextColor = Colors.white;
                    reviewTextColor = Colors.white;
                    descriptionTabColor = intello_bg_color;
                    lessonsTabColor = intello_dark_bg_color;
                    reviewTabColor = intello_dark_bg_color;
                    des_rev_less_status = 1;
                  }



                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                margin: const EdgeInsets.only(left: 0.0, right: 5.0),
                decoration: BoxDecoration(
                  color: descriptionTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Description",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: descriptionTextColor,
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
                    descriptionTextColor =intello_text_color;
                    lessonsTextColor = Colors.white;
                    reviewTextColor = intello_text_color;
                    descriptionTabColor = tabColor;
                    lessonsTabColor =intello_bg_color;
                    reviewTabColor = tabColor;
                    des_rev_less_status = 2;
                  }
                  else{
                    descriptionTextColor = Colors.white;
                    lessonsTextColor = Colors.white;
                    reviewTextColor = Colors.white;
                    descriptionTabColor = intello_dark_bg_color;
                    lessonsTabColor = intello_bg_color;
                    reviewTabColor = intello_dark_bg_color;
                    des_rev_less_status = 2;
                  }



                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 5.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: lessonsTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Lessons",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: lessonsTextColor,
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
                    descriptionTextColor =intello_text_color;
                    lessonsTextColor = intello_text_color;
                    reviewTextColor = Colors.white;
                    descriptionTabColor =tabColor;
                    lessonsTabColor =tabColor;
                    reviewTabColor = intello_bg_color;
                    des_rev_less_status = 3;
                  }
                  else{
                    descriptionTextColor = Colors.white;
                    lessonsTextColor = Colors.white;
                    reviewTextColor = Colors.white;
                    descriptionTabColor = intello_dark_bg_color;
                    lessonsTabColor = intello_dark_bg_color;
                    reviewTabColor = intello_bg_color;
                    des_rev_less_status = 3;
                  }


                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 5.0, right: 0.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: reviewTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Reviews",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: reviewTextColor,
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

  Widget _buildEnrollNowField() {
    return Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 14, bottom: 14),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 10.0),
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
                        color: _darkOrLightStatus==1? intello_button_color_green:intello_bg_color,
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
                              "Enroll Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PT-Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {

                _addFavouriteDataList(courseId: _courseId);
                //
                // if (favoriteColor == Colors.pink) {
                //   setState(() {
                //     favoriteColor =hint_color;
                //   });
                // } else {
                //   setState(() {
                //     favoriteColor = Colors.pink;
                //   });
                // }
              },
              child: Container(
                decoration:  BoxDecoration(
                  color: _darkOrLightStatus==1? Colors.white:intello_bg_color_for_darkMode,
                  // color: Colors.backGroundColor1,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: Icon(
                  Icons.favorite,
                  color: favoriteColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildTrainerInfoSection() {
    return Container(
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

                  InkResponse(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen(
                        teacherId: _course_single_response["course_created_by_info"]["id"].toString(),)));
                     // _showToast("Pik clicked");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                          height: 45,
                          width: 45,
                          color:intello_bg_color,
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/images/empty.png',
                            image:"$BASE_URL"+_courseCreatedByImage,
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
                            _courseCreatedBy,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:intello_hint_color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            RatingBarIndicator(
                              rating: _avarageRating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color:intello_star_color,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                            Expanded(
                                child: Text(
                              " ($_avarageRating), (2312 rating on 42012 students enrolled)",
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

                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildLessonsDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(_lessonsShimmerStatus)...{

          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
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
          ListView.builder(
            itemCount: 10,
            // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return lessonItemShimmer();
            },
          ),

        }else...{
          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lessons",
                style: TextStyle(
                    color: _darkOrLightStatus==1?intello_bold_text_color:Colors.white,

                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ListView.builder(
            itemCount: 10,
            // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildLessonListItem();
            },
          ),
        }

      ],
    );

  }
////////////////////////////////////////
  Widget _buildLessonListItem() {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
      //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: '10',)));
      },
      child:
      Container(
        margin: EdgeInsets.only(right: 00.0, top: 0, bottom: 15, left: 00),
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
        child:Center(
          child: Container(
            padding: EdgeInsets.only(right: 5.0, top: 5, bottom: 5, left: 5),
            child: SizedBox(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child:  FadeInImage.assetNetwork(
                          height: 70,
                          width: 70,
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
                      )),
                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:  Flex(
                      direction: Axis.vertical,
                      children: [


                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(

                            "Learn Online",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 15,),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Flex(direction: Axis.horizontal,
                            children: [
                              Icon(Icons.timer,
                                color:intello_bg_color,
                                size: 15,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "5:32 mins",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:intello_bg_color,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                softWrap: false,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(

                      onTap: () {

                        // if(list_grid_status==1){
                        //   setState(() {
                        //     list_grid_status=2;
                        //     list_grid_image_icon_link = "assets/images/grid.png";
                        //   });
                        //
                        //
                        // }
                        // else {
                        //   setState(() {
                        //     list_grid_status=1;
                        //     list_grid_image_icon_link = "assets/images/icon_list.png";
                        //   });
                        //
                        // }

                      },
                      child: Image.asset(
                        'assets/images/expand.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

  //shimmer
  Widget _buildCourseVideoShimmer() {
    return Container(

      margin:  EdgeInsets.only(left: 15, top: 10, right:15, bottom: 0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Shimmer.fromColors(
            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
            child: Container(
            height: 220,
              //  width: 65,
              decoration: BoxDecoration(
                color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),

                ),
              ),
            ),
          ),



      ),
    );
  }
  //shimmer design
  Widget lessonItemShimmer() {
    return Container(
      margin: EdgeInsets.only(right: 00.0, top: 0, bottom: 10, left: 00),
      //width: 180,
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
      //   height: 150,
      child:Container(
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
                      height: 70,
                      width: 70,
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
                              height: 35,
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
                            Expanded(child: Align(alignment: Alignment.topLeft,
                              child:  Shimmer.fromColors(
                                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                                child:Container(
                                  height: 15,
                                  // width: 130,
                                  color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                                ),
                              ),
                            ),),
                            Expanded(child: Container(),)
                          ],
                        )


                      ],
                    ),
                  )),
            ],
          ),
        ),
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
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //add favourite list
  _addFavouriteDataList({required String courseId}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try {
          var response = await post(
              Uri.parse(
                  '$BASE_URL_API$SUB_URL_API_ADD_FAVOURITE_LIST'),
              headers: {
                //"Authorization": "Token $accessToken",
              },
              body: {
                "course_id":courseId,
                "student_id":_userId
              }
          );

        //  _showToast(response.statusCode.toString());

          if (response.statusCode == 201) {
            setState(() {

              var data = jsonDecode(response.body);
              _showToast(data["message"].toString());
            });
          }
          else {
            var data = jsonDecode(response.body);
            _showToast(data["message"].toString());
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
  _Course_single_responseList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_public_course_single_response$_courseId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
          //_showToast(response.statusCode.toString()+"cc");

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _course_single_response = data["data"];
              _courseTitle=_course_single_response["course_title"].toString();

              _courseCreatedBy=_course_single_response["course_created_by_info"]["username"].toString();
              _courseCreatedByImage=_course_single_response["course_created_by_info"]["image"].toString();
              _avarageRating=double.parse(_course_single_response["avg_rating"].toString());
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
  _Course_description_response_List() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _videoShimmerStatus = true;
        _descriptionShimmerStatus = true;
        _descriptionShimmerStatus = true;

        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_public_course_description_response$_courseId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
        //  _showToast(response.statusCode.toString()+"nv");

          if (response.statusCode == 200) {
            setState(() {
              _videoShimmerStatus = false;
              _descriptionShimmerStatus = false;
              var data = jsonDecode(response.body);
              _course_description_response = data["data"];
              _courseDescription=_course_description_response["course_description"].toString();
              _course_what_will_you_learn_list=_course_description_response["course_learn_info"];

              // _courselearnQuestion=_course_description_response["course_learn_info"][0]["course_learn_question"].toString();
              // _courselearnAnswer=_course_description_response["course_learn_info"][0]["course_learn_answer"].toString();

              // _courseCreatedByImage=_course_single_response["course_created_by_info"]["image"].toString();
              // _avarageRating=double.parse(_course_single_response["avg_rating"].toString());
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
  _Course_REVIEW_feedback_List() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_REVIEW_feedback$_courseId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
        //  _showToast(response.statusCode.toString()+"asd");

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _course_review_feedback_response = data["data"];

              // _courseTitle=_course_single_response["course_title"].toString();
              //
              // _courseCreatedBy=_course_single_response["course_created_by_info"]["username"].toString();
              // _courseCreatedByImage=_course_single_response["course_created_by_info"]["image"].toString();
              // _studentavarageRating=double.parse(_course_review_feedback_response["avg_rating"].toString());
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
  _single_course_review_response_List() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _reviewShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_public_course_course_student_review$_courseId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
         // _showToast(response.statusCode.toString()+"aaa");

          if (response.statusCode == 200) {
            setState(() {
              _reviewShimmerStatus = false;
              var data = jsonDecode(response.body);
              _course_review_response = data["data"];
              // _courseDescription=_course_description_response["course_description"].toString();
              // _course_what_will_you_learn_list=_course_description_response["course_learn_info"];
              //
              // _courselearnQuestion=_course_description_response["course_learn_info"][0]["course_learn_question"].toString();
              // _courselearnAnswer=_course_description_response["course_learn_info"][0]["course_learn_answer"].toString();

              // _courseCreatedByImage=_course_single_response["course_created_by_info"]["image"].toString();
              // _avarageRating=double.parse(_course_single_response["avg_rating"].toString());
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

  _single_course_review_search_response_List({required String ratingValue,required String reviewSearchValue}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await put(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_REVIEW_SEARCH$_courseId/'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
            body: {
              "search_value":reviewSearchValue,
              "rating": ratingValue,
            }
          );
         //_showToast(response.statusCode.toString()+"ww");

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _course_review_response.clear();
              _course_review_response = data["data"];

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



  String dateConvert(String timeString) {
    var parsedDate = DateTime.parse(timeString);
    final DateFormat format = DateFormat('dd MMM, yyyy');
    final String formatted = format.format(parsedDate);
    return formatted;
    // 2021-03-02
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

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [AllRatings, Ratings5, Ratings4,Ratings3,Ratings2];


  static const AllRatings = MenuItem(text: 'All Ratings' );
  static const Ratings5 = MenuItem(text: '5 Star',);
  static const Ratings4 = MenuItem(text: '4 Star',);
  static const Ratings3 = MenuItem(text: '3 Star',);
  static const Ratings2 = MenuItem(text: '2 Star',);



  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
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
      case MenuItems.AllRatings:
      //countryName="en";
      //Do something
        Fluttertoast.showToast(
            msg: "1234",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: intello_bg_color,
            textColor: Colors.white,
            fontSize: 16.0);

        break;
      case MenuItems.Ratings5:
      //Do something
        break;
      case MenuItems.Ratings4:
      //Do something
        break;
      case MenuItems.Ratings3:
      //Do something
        break;
      case MenuItems.Ratings2:
      //Do something
        break;
    }
  }

  _showToastdf(String message) {
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