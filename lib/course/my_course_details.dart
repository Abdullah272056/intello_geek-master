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

class MyCourseDetailsScreen extends StatefulWidget {
  String courseId;
  MyCourseDetailsScreen({required this.courseId});

  @override
  State<MyCourseDetailsScreen> createState() => _MyCourseDetailsScreenState(this.courseId);
}

class _MyCourseDetailsScreenState extends State<MyCourseDetailsScreen> {

  String _courseId;

  _MyCourseDetailsScreenState(
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
  String _courseTitle="Animation is the art of bringing life to an otherwise inanimate objects, or illustrated / 3D generated characters.";
  String _courseCreatedBy="";
  double _avarageRating=0.0;
  String _courseCreatedByImage="";


  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;
  bool _videoShimmerStatus=false;

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {

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

                           margin:  EdgeInsets.only(left: 20, top: 10, right:20, bottom: 0),
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
                           margin:  EdgeInsets.only(left: 20, top: 15, right:20, bottom: 0),
                           child: Text(
                             _courseTitle,
                             style: TextStyle(
                                 color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                                 fontSize: 17,
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                         Container(
                           margin:  EdgeInsets.only(left: 20, top: 0, right:20, bottom: 0),
                           child: _buildTrainerInfoSection(),
                         ),

                         Container(
                           margin:  EdgeInsets.only(left: 20, top: 15, right:20, bottom: 0),
                           child: LinearPercentIndicator(
                             // width: MediaQuery.of(context).size.width - 80,
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 1000,
                             percent: .74,
                             center: Text("74%",
                               style: TextStyle(
                                   color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                                   fontSize: 11,
                                   fontWeight: FontWeight.normal),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,

                             backgroundColor:_darkOrLightStatus == 1? intello_Indicator_bg_color_for_light:intello_Indicator_bg_color_for_dark,
                             progressColor: _darkOrLightStatus == 1?intello_tab_indicator_color_for_light:intello_bg_color_for_dark,
                            // progressColor: intello_tab_indicator_color_for_light,

                           ),
                         ),

                         Container(
                           margin:  EdgeInsets.only(left: 20, top: 28, right:20, bottom: 0),
                           child: Flex(direction: Axis.horizontal,
                             children: [
                               Expanded(child: Align(
                                 alignment: Alignment.topLeft,
                                 child: Text(
                                   "Course Detail",
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(
                                       color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                                       fontSize: 20,
                                       fontWeight: FontWeight.w600),
                                   softWrap: false,
                                   maxLines:1,
                                 ),
                               ),),
                               Image.asset(
                                 "assets/images/icon_course_diration_time.png",
                                 height: 20,
                                 width: 20,
                                 color:_darkOrLightStatus == 1?intello_tab_indicator_color_for_light:intello_bg_color_for_dark,
                               ),
                               SizedBox(width: 10,),
                               Align(
                                 alignment: Alignment.topLeft,
                                 child: Text(
                                   "1 hours, 30 min",
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(
                                       color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                                       fontSize: 13,
                                       fontWeight: FontWeight.normal),
                                   softWrap: false,
                                   maxLines:1,
                                 ),
                               ),
                             ],
                           ),
                         ),

                         Container(
                           margin:const EdgeInsets.only(top:00),
                           height:200.0,
                           child: ListView.builder(
                             //itemCount: offerDataList == null ? 0 : offerDataList.length,
                             itemCount:4,
                             itemBuilder: (context, index) {
                               if(index==0){
                                 return _buildMyCourseDetailsItem(item_marginLeft:20,item_marginRight: 0,);
                               }
                               //length
                               if(index==3){
                                 return _buildMyCourseDetailsItem(item_marginLeft:20,item_marginRight: 20);
                               }

                               else{
                                 return _buildMyCourseDetailsItem(item_marginLeft:20,item_marginRight: 00,);
                               }

                             },
                             scrollDirection: Axis.horizontal,
                           ),
                         ),
                       },

                      ],
                    ),
                  )),

            ],
          ),
        )
    );
  }

  Widget _buildMyCourseDetailsItem({required double item_marginLeft,
    required double item_marginRight}) {
    return InkResponse(
      onTap: (){
       // Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen(teacherId: response["id"].toString() ,)));

      },
      child: Container(
        margin:  EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 20,top: 20),
        width: 180,
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
          margin: EdgeInsets.only(right: 10.0,top: 20,bottom: 10,left: 20),
          // height: double.infinity,
          // width: double.infinity,

          child: Center(
            child: Column(
              children: [


                Flex(direction: Axis.horizontal,
                  children: [
                    Image.asset(
                      "assets/images/icon_course_edit.png",
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(width: 10,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Introducing",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color:_darkOrLightStatus == 1?intello_bg_color_for_dark:intello_bg_color_for_dark,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                        softWrap: false,
                        maxLines:1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "What is animation?",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines:1,
                  ),
                ),
                SizedBox(height: 2,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "15 min",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.normal),
                    softWrap: false,
                    maxLines:1,
                  ),
                ),
                SizedBox(height: 18,),
                Flex(direction: Axis.horizontal,
                  children: [
                    Image.asset(
                      "assets/images/icon_play.png",
                    height: 33,
                      width: 33,
                    ),
                    SizedBox(width: 12,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Start",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                        softWrap: false,
                        maxLines:1,
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        ) ,
      ),

    );
  }


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


  Widget _buildTrainerInfoSection() {
    return Container(
        width: double.infinity,
        alignment: Alignment.topLeft,
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Column(
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "98 Modules",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color:intello_hint_color,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 10,),
              Flex(
                direction: Axis.horizontal,
                children: [

                  InkResponse(
                    onTap: () {
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen(
                      //   teacherId: _course_single_response["course_created_by_info"]["id"].toString(),)));
                     // _showToast("Pik clicked");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                          height: 26,
                          width: 26,
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
                            "Mario rossi • Trainer and Speaker",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:intello_hint_color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            softWrap: false,
                            maxLines: 1,
                          ),
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

