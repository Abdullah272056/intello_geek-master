
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/home_page/recently_added_course.dart';
import 'package:intello_geek/home_page/search_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../registration/log_in.dart';
import '../teacher_profile_view_page.dart';
import 'course_details.dart';
import 'most_visited_course_page.dart';
import 'navigation_bar_page.dart';

class HomeScreen extends StatefulWidget {
  int darkOrLightStatus;
  HomeScreen(this.darkOrLightStatus);

  @override
  State<HomeScreen> createState() => _HomeScreenState(this.darkOrLightStatus);
}

class _HomeScreenState extends State<HomeScreen> {
  int _darkOrLightStatus;
  _HomeScreenState(this._darkOrLightStatus);

  bool _shimmerStatus = true;
  bool _recentlyAddedShimmerStatus = true;
  bool _mostVisitedShimmerStatus = true;
  bool _recommendedShimmerStatus = true;
  bool _bestTeacherAndCoachShimmerStatus = true;
  bool _topCategoriesShimmerStatus = true;

  List _topCategory = [];
  List _Recently_added_course = [];
  List _mostVisitedCourse = [];
  List _BestTeacherCourse = [];
  List _Recommended_for_you = [];

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";

  int paymentMethodTappedIndex=0;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    loadUserIdFromSharePref().then((_) {

      if(_userId!=null &&!_userId.isEmpty&&_userId!=""){
        Future.delayed( Duration(milliseconds: 320), () {
          setState(() {
            _getTopCategoryDataList();
            _getRecently_added_courseList();
            _mostVisitedCourseList();
            _BestTeacherAndCoachList();
            _Recommended_for_youList();
          });
        });
      }else{
        setState(() {
          Route route = MaterialPageRoute(builder: (context) => LogInScreen());
          Navigator.pushReplacement(context, route);
        });


      }



    });



    // loadUserIdFromSharePref().then((_) {
    //
    //   _getTopCategoryDataList();
    //   _getRecently_added_courseList();
    //   _mostVisitedCourseList();
    //   _BestTeacherAndCoachList();
    //   _Recommended_for_youList();
    //
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.intello_bd_color_dark,
      body:
      Container(
        decoration: BoxDecoration(
            color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 380,
                    decoration: BoxDecoration(

                      image: DecorationImage(
                     //   image: AssetImage("assets/images/bg_dark.png",
                        image: AssetImage( _darkOrLightStatus==1?"assets/images/background2.png":"assets/images/bg_dark.png",
                        ),
                      //  colorFilter: new ColorFilter.mode(Colors.black, BlendMode.dstATop),
                        fit: BoxFit.fill,
                      ),


                    ),
                    child:Stack(
                      children: [
                        Flex(direction: Axis.horizontal,
                          children: [

                            Expanded(child: Container(

                            ),flex: 2,),
                            Expanded(child: Container(
                              margin: const EdgeInsets.only(right: 20.0,top: 50),

                              decoration: BoxDecoration(

                                image: DecorationImage(
                                  image: AssetImage("assets/images/getstarted_2.png"),
                                  fit: BoxFit.fill,
                                ),

                              ),

                            ),flex: 3,),
                          ],
                        ),


                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 00.0,top: 50,left: 00),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          margin:EdgeInsets.only(right: 0.0,top: 00,left: 20),
                          child: Align(alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: (){
                                openCloseSideMenu();
                                //_showToast("menu");
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(11.0),
                                  ),
                                  color:_darkOrLightStatus==1? home_page_menu_button_bg_color:intello_bottom_bg_color,
                                ),

                                child: Center(
                                  child: Image.asset(
                                    "assets/images/icon_menu2.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),

                              )


                            ),
                          ),
                        ),

                        Container(
                          margin:EdgeInsets.only(right: 20.0,top: 00,left: 20),
                          child: Flex(direction: Axis.vertical,
                            children: [
                              SizedBox(height: 40,),
                              Align(alignment: Alignment.topLeft,
                                child:  Text("Welcome",
                                  style: TextStyle(
                                      color:_darkOrLightStatus==1?intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,

                                ),
                              ),
                              SizedBox(height: 3,),

                              Align(alignment: Alignment.topLeft,
                                child:  Text("Simon Lewis",
                                  style: TextStyle(
                                      color:_darkOrLightStatus==1?intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,

                                ),
                              ),


                              SizedBox(height: 30,),

                              _buildSearchBar(),
                              SizedBox(height: 10,),

                              _buildCategoriesField(),



                            ],
                          ),
                        ),


                        // recently added course
                        if(_recentlyAddedShimmerStatus)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top: 30,left: 20),
                            child:  Flex(direction: Axis.horizontal,
                              children: [
                                Expanded(child: Align(alignment: Alignment.topLeft,
                                  child:  Text("Recently Added course",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,

                                  ),
                                ),),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 25),
                              height:245.0,

                              // child: _buildRecentlyAddedCourseItem(),
                              child: ListView.builder(
                                shrinkWrap: true,

                                physics: const NeverScrollableScrollPhysics(),
                                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  if(index==0){
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:20,item_marginRight: 0);
                                  }
                                  //length
                                  if(index==2){
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 20);
                                  }
                                  else{
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 00);
                                  }


                                },
                                scrollDirection: Axis.horizontal,
                              )
                          ),

                        }
                        else...{
                        if(_Recently_added_course.length>0)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top: 30,left: 20),
                            child:  Flex(direction: Axis.horizontal,
                              children: [

                                Expanded(child: Align(alignment: Alignment.topLeft,
                                  child:  Text("Recently Added course",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,

                                  ),
                                ),),
                                Container(
                                  margin:  EdgeInsets.only(left: 10.0, right: 0.0),
                                  child: InkResponse(
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>RecentlyAddedSeeMoreScreen()));

                                    },
                                    child: Image.asset(
                                      "assets/images/arrow_right.png",
                                      color: _darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                      width: 27,
                                      height: 27,
                                      fit: BoxFit.fill,
                                    ),
                                  ),

                                )

                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 25),
                              height:245.0,

                              // child: _buildRecentlyAddedCourseItem(),
                              child: ListView.builder(
                                shrinkWrap: true,

                                // physics: const NeverScrollableScrollPhysics(),
                                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                                itemCount: _Recently_added_course==null||_Recently_added_course.length<=0?0:
                                _Recently_added_course.length,
                                itemBuilder: (context, index) {
                                  if(index==0){
                                    return _buildRecentlyAddedCourseItem(item_marginLeft:20,item_marginRight: 0,response: _Recently_added_course[index]);
                                  }
                                  //length
                                  if(index==_Recently_added_course.length-1){
                                    return _buildRecentlyAddedCourseItem(item_marginLeft:30,item_marginRight: 20,response: _Recently_added_course[index]);
                                  }
                                  else{
                                    return _buildRecentlyAddedCourseItem(item_marginLeft:30,item_marginRight: 00,response: _Recently_added_course[index]);
                                  }


                                },
                                scrollDirection: Axis.horizontal,
                              )
                          ),
                        }

                        },



                        // most visited
                        if(_mostVisitedShimmerStatus)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top: 10,left: 20),
                            child:  Flex(direction: Axis.horizontal,
                              children: [
                                Expanded(child: Flex(direction: Axis.horizontal,
                                  children: [
                                    Align(alignment: Alignment.topLeft,
                                      child:  Text("Most Visited",
                                        style: TextStyle(
                                            color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        // textAlign: TextAlign.left,

                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 25),
                              height:245.0,

                              // child: _buildRecentlyAddedCourseItem(),
                              child: ListView.builder(
                                shrinkWrap: true,

                                physics: const NeverScrollableScrollPhysics(),
                                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  if(index==0){
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:20,item_marginRight: 0);
                                  }
                                  //length
                                  if(index==4){
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 20);
                                  }
                                  else{
                                    return _buildRecentlyAddedCourseItemShimmer(item_marginLeft:30,item_marginRight: 00);
                                  }


                                },
                                scrollDirection: Axis.horizontal,
                              )
                          ),

                        }
                        else...{
                          if(_mostVisitedCourse.length>0)...{
                            Container(
                              margin:EdgeInsets.only(right: 20.0,top: 10,left: 20),
                              child:  Flex(direction: Axis.horizontal,
                                children: [
                                  Expanded(child: Flex(direction: Axis.horizontal,
                                    children: [
                                      Align(alignment: Alignment.topLeft,
                                        child:  Text("Most Visited",
                                          style: TextStyle(
                                              color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          // textAlign: TextAlign.left,

                                        ),
                                      ),
                                      Align(alignment: Alignment.topLeft,
                                        child:  Text(" (",
                                          style: TextStyle(
                                              color:intello_search_view_hint_color,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          // textAlign: TextAlign.left,

                                        ),
                                      ),
                                      Align(alignment: Alignment.topLeft,
                                        child:  Text(_mostVisitedCourse==null||_mostVisitedCourse.length<=0?"0":
                                        _mostVisitedCourse.length.toString(),
                                          style: TextStyle(
                                              color:intello_search_view_hint_color,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          // textAlign: TextAlign.left,

                                        ),
                                      ),
                                      Align(alignment: Alignment.topLeft,
                                        child:  Text(")",
                                          style: TextStyle(
                                              color:intello_search_view_hint_color,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          // textAlign: TextAlign.left,

                                        ),
                                      ),
                                    ],
                                  )),

                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                                    child: InkResponse(
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>MostVisitedCourseSeeMoreScreen()));

                                      },
                                      child: Image.asset(
                                        "assets/images/arrow_right.png",
                                        color: _darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        width: 27,
                                        height: 27,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                  )

                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              height:245.0,

                              // child: _buildRecentlyAddedCourseItem(),
                              child: ListView.builder(
                                //itemCount: offerDataList == null ? 0 : offerDataList.length,
                                itemCount: _mostVisitedCourse==null||_mostVisitedCourse.length<=0?0:
                                _mostVisitedCourse.length,
                                itemBuilder: (context, index) {
                                  if(index==0){
                                    return _buildMostVisitedCourseItem(item_marginLeft:20,item_marginRight: 0,response: _mostVisitedCourse[index]);
                                  }
                                  //length
                                  if(index==_mostVisitedCourse.length-1){
                                    return _buildMostVisitedCourseItem(item_marginLeft:30,item_marginRight: 20,response: _mostVisitedCourse[index] );
                                  }

                                  else{
                                    return _buildMostVisitedCourseItem(item_marginLeft:30,item_marginRight: 00,response: _mostVisitedCourse[index] );
                                  }


                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          }

                        },



                        // recommended for you

                        if(_recommendedShimmerStatus)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top:10,left: 20),
                            child:   Flex(direction: Axis.horizontal,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:  Text("Recommended for you",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0),
                            height:230.0,

                            // child: _buildRecentlyAddedCourseItem(),
                            child: ListView.builder(
                              //itemCount: offerDataList == null ? 0 : offerDataList.length,
                              itemCount:7,
                              itemBuilder: (context, index) {

                                if(index==0){
                                  return _buildRecommendedForYouItemShimmer(item_marginLeft:20,item_marginRight: 0);
                                }
                                //length
                                if(index==6){
                                  return _buildRecommendedForYouItemShimmer(item_marginLeft:20,item_marginRight: 20);
                                }
                                else{
                                  return _buildRecommendedForYouItemShimmer(item_marginLeft:20,item_marginRight: 00);
                                }

                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ),

                        }
                        else...{
                        if(_Recommended_for_you.length>0)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top:10,left: 20),
                            child:   Flex(direction: Axis.horizontal,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:  Text("Recommended for you",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0),
                            height:230.0,

                            // child: _buildRecentlyAddedCourseItem(),
                            child: ListView.builder(
                              //itemCount: offerDataList == null ? 0 : offerDataList.length,
                              itemCount: _Recommended_for_you==null||_Recommended_for_you.length<=0?0:
                              _Recommended_for_you.length,
                              itemBuilder: (context, index) {

                                if(index==0){
                                  return _buildRecommendedForYouItem(item_marginLeft:20,item_marginRight: 0,response: _Recommended_for_you[index]);
                                }
                                //length
                                if(index==_Recommended_for_you.length-1){
                                  return _buildRecommendedForYouItem(item_marginLeft:20,item_marginRight: 20,response: _Recommended_for_you[index]);
                                }
                                else{
                                  return _buildRecommendedForYouItem(item_marginLeft:20,item_marginRight: 00,response: _Recommended_for_you[index]);
                                }

                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        }

                        },





                      //best teacher and coach

                      if(_bestTeacherAndCoachShimmerStatus)...{
                        Container(
                          margin:EdgeInsets.only(right: 20.0,top: 00,left: 20),
                          child:   Flex(direction: Axis.horizontal,
                            children: [
                              Align(alignment: Alignment.topLeft,
                                child:  Text("Best Teacher & Coach",
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  // textAlign: TextAlign.left,

                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 0),
                            height:260.0,

                            // child: _buildRecentlyAddedCourseItem(),
                            child: ListView.builder(
                              //itemCount: offerDataList == null ? 0 : offerDataList.length,
                              itemCount:7,
                              itemBuilder: (context, index) {

                                if(index==0){
                                  return _buildBestTeacherAndCoachItemShimmer(item_marginLeft:20,item_marginRight: 0);
                                }
                                //length
                                if(index==6){
                                  return _buildBestTeacherAndCoachItemShimmer(item_marginLeft:20,item_marginRight: 20);
                                }
                                else{
                                  return _buildBestTeacherAndCoachItemShimmer(item_marginLeft:20,item_marginRight: 00);
                                }

                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ),

                        }
                      else...{
                      if(_BestTeacherCourse.length>0)...{
                        Container(
                          margin:EdgeInsets.only(right: 20.0,top: 00,left: 20),
                          child:   Flex(direction: Axis.horizontal,
                            children: [
                              Align(alignment: Alignment.topLeft,
                                child:  Text("Best Teacher & Coach",
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  // textAlign: TextAlign.left,

                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin:const EdgeInsets.only(top:00),
                          height:260.0,
                          child: ListView.builder(
                            //itemCount: offerDataList == null ? 0 : offerDataList.length,
                            itemCount: _BestTeacherCourse==null||_BestTeacherCourse.length<=0?0:
                            _BestTeacherCourse.length,
                            itemBuilder: (context, index) {
                              if(index==0){
                                return _buildBestTeacherAndCoachItem(item_marginLeft:20,item_marginRight: 0,response: _BestTeacherCourse[index]);
                              }
                              //length
                              if(index==_BestTeacherCourse.length-1){
                                return _buildBestTeacherAndCoachItem(item_marginLeft:20,item_marginRight: 20,response: _BestTeacherCourse[index]);
                              }

                              else{
                                return _buildBestTeacherAndCoachItem(item_marginLeft:20,item_marginRight: 00,response: _BestTeacherCourse[index]);
                              }

                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      }

                      },


                        // _topCategoriesShimmerStatus

                        // top categories

                        if(_topCategoriesShimmerStatus)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top: 00,left: 20),
                            child:Flex(direction: Axis.horizontal,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:  Text("Top Categories",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,

                                  ),
                                ),


                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height:170.0,
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

                        }
                        else...{
                        if(_topCategory.length>0)...{
                          Container(
                            margin:EdgeInsets.only(right: 20.0,top: 00,left: 20),
                            child:Flex(direction: Axis.horizontal,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:  Text("Top Categories",
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.left,

                                  ),
                                ),

                                Align(alignment: Alignment.topLeft,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(" (",
                                        style: TextStyle(
                                            color:intello_search_view_hint_color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        // textAlign: TextAlign.left,

                                      ),
                                      Text(_topCategory==null||_topCategory.length<=0?"0":
                                      _topCategory.length.toString(),
                                        style: TextStyle(
                                            color:intello_search_view_hint_color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        // textAlign: TextAlign.left,

                                      ),
                                      Text(")",
                                        style: TextStyle(
                                            color:intello_search_view_hint_color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        // textAlign: TextAlign.left,

                                      ),

                                    ],
                                  ) ,

                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height:170.0,

                            // child: _buildRecentlyAddedCourseItem(),
                            child: ListView.builder(
                              //itemCount: offerDataList == null ? 0 : offerDataList.length,
                              itemCount: _topCategory==null||_topCategory.length<=0?0:
                              _topCategory.length,
                              itemBuilder: (context, index) {
                                if(index==0){
                                  return _buildTopCategoriesItem(item_marginLeft:20,item_marginRight: 0,response: _topCategory[index]);
                                }
                                //length
                                if(index==_topCategory.length-1){
                                  return _buildTopCategoriesItem(item_marginLeft:15,item_marginRight: 20,response: _topCategory[index]);
                                }

                                else{
                                  return _buildTopCategoriesItem(item_marginLeft:15,item_marginRight: 00,response: _topCategory[index]);
                                }

                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        }

                        },



                      Container(
                          margin:EdgeInsets.only(right: 20.0,top: 10,left: 20),
                          child:  Flex(direction: Axis.horizontal,
                            children: [
                              Align(alignment: Alignment.topLeft,
                                child:  Text("Add in you interest",
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ? intello_easylearn_bold_text_color_:Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  // textAlign: TextAlign.left,

                                ),
                              ),
                              Align(alignment: Alignment.topLeft,
                                child:  Text("(650)",
                                  style: TextStyle(
                                      color:intello_search_view_hint_color,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  // textAlign: TextAlign.left,

                                ),
                              ),
                            ],
                          ),
                        ),

                      // Wrap(
                      //
                      //     direction: Axis.horizontal,
                      //     children: [
                      //       _generateItem(index: 0),
                      //
                      //
                      //       _generateItem(index: 1),
                      //       _generateItem(index: 2),
                      //       _generateItem(index: 3)
                      //
                      //     ],
                      //   ),
                        SizedBox(height: 20,),
                        Wrap(
                         runSpacing: 10,
                          children: <Widget>[
                            Container(
                             // height: 36,
                              margin: EdgeInsets.only(right: 10,top: 0),
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
                              decoration: new BoxDecoration(
                                  color: _darkOrLightStatus==1?tabColor:intello_list_item_color_for_dark,
                                  // intello_subscription_card_border_color

                                  //border:Border.all(color: intello_payment_card_type_list_item_border,width: 1),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(18),
                                  )
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Image.asset(
                                    _darkOrLightStatus==1?
                                    "assets/images/digital_marketing_dark.png":
                                    "assets/images/digital_marketing_light.png",
                                    width: 13,
                                    height: 13,

                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Social Media Marketing",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:_darkOrLightStatus==1? intello_level_color_for_dark_for_dark:Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // height: 36,
                              margin: EdgeInsets.only(right: 10,top: 00),
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
                              decoration: new BoxDecoration(
                                  color: _darkOrLightStatus==1?tabColor:intello_list_item_color_for_dark,
                                  // intello_subscription_card_border_color

                                  //border:Border.all(color: intello_payment_card_type_list_item_border,width: 1),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(18),
                                  )
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Image.asset(
                                    _darkOrLightStatus==1?"assets/images/icon_interior_light.png":
                                    "assets/images/icon_interior_dark.png",
                                    width: 13,
                                    height: 13,

                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Interior Designing",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:_darkOrLightStatus==1? intello_level_color_for_dark_for_dark:Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // height: 36,
                              margin: EdgeInsets.only(right: 10,top: 00),
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
                              decoration: new BoxDecoration(
                                  color: _darkOrLightStatus==1?tabColor:intello_list_item_color_for_dark,
                                  // intello_subscription_card_border_color

                                  //border:Border.all(color: intello_payment_card_type_list_item_border,width: 1),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(18),
                                  )
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Image.asset(
                                    _darkOrLightStatus==1?"assets/images/icon_video_editing_light.png":
                                    "assets/images/icon_video_editing_dark.png",
                                    width: 13,
                                    height: 13,

                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Video Editing",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:_darkOrLightStatus==1? intello_level_color_for_dark_for_dark:Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // height: 36,
                              margin: EdgeInsets.only(right: 10,top: 00),
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
                              decoration: new BoxDecoration(
                                  color: _darkOrLightStatus==1?tabColor:intello_list_item_color_for_dark,
                                  // intello_subscription_card_border_color

                                  //border:Border.all(color: intello_payment_card_type_list_item_border,width: 1),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(18),
                                  )
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Image.asset(
                                    _darkOrLightStatus==1?"assets/images/icon_marketing_light.png":
                                    "assets/images/icon_marketing_dark.png",
                                    width: 15,
                                    height: 15,

                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Marketing",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:_darkOrLightStatus==1? intello_level_color_for_dark_for_dark:Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // height: 36,
                              margin: EdgeInsets.only(right: 10,top: 00),
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
                              decoration: new BoxDecoration(
                                  color: _darkOrLightStatus==1?tabColor:intello_list_item_color_for_dark,
                                  // intello_subscription_card_border_color

                                  //border:Border.all(color: intello_payment_card_type_list_item_border,width: 1),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(18),
                                  )
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Image.asset(
                                    _darkOrLightStatus==1?"assets/images/icon_digital_light.png":
                                    "assets/images/icon_digital_dark.png",
                                    width: 13,
                                    height: 13,

                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Digital",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:_darkOrLightStatus==1? intello_level_color_for_dark_for_dark:Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),


                          ],
                        ),

                      SizedBox(height: 20,),
                      ],
                    ),


                  )
                ],
              ),
            ],
          ),
        ),

        /* add child content here */
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  SearchFileScreen()));
      },
      child: Card(
          elevation: 0,
          color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(

            height: 55,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: 15,
                ),

                Expanded(
                  child: Text(
                    "Search for new course!",
                    style: TextStyle(fontSize: 16, color: intello_search_view_hint_color),
                  ),

                ),
                Align( alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.search,
                    color: intello_search_view_hint_color,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildCategoriesField() {
    return  Container(
        padding: const EdgeInsets.only(left: 10.0, right: 00.0,top: 20,bottom: 20),
        decoration: BoxDecoration(
          color:_darkOrLightStatus==1? intello_categoriesBox_bg_color:intello_bg_color_for_darkMode,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: 15,
            ),

            Expanded(
              child: Align(alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Align(alignment: Alignment.topLeft,
                      child:  Text("Start learning\nnew staff",
                        style: TextStyle(
                            color:_darkOrLightStatus==1?intello_easylearn_bold_text_color_:Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,

                      ),
                    ),

                    SizedBox(height: 10,),
                    _buildCategoriesButton()


                  ],
                ),
              ),

            ),
            SizedBox(
              width: 10,
            ),
            Align( alignment: Alignment.centerRight,
              child: Image.asset(
                _darkOrLightStatus==1?
                "assets/images/undraw_researching.png":"assets/images/undraw_researching_for_dark.png",
                width: 120,
                height: 66,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        )
    );
  }

  Widget _buildCategoriesButton() {
    return Container(
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
              gradient: LinearGradient(colors: [intello_button_color_green,intello_button_color_green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(7.0)
          ),
          child: Container(

            height: 40,
            alignment: Alignment.center,
            child:  Wrap(
              children: [
                Text(
                  "Categories",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PT-Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 22.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyAddedCourseItem({required double item_marginLeft,required double item_marginRight, required var response }) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
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
                                              image: "$BASE_URL"+response["channel_name"]["channel_name_logo"].toString(),
                                              imageErrorBuilder: (context, url, error) =>
                                                  Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.fill,
                                                  ),
                                            )
                                        ),

                                      ),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: Container(
                                          padding:
                                          EdgeInsets.only(right: 5.0),
                                          child: Text(
                                              response["channel_name"]["channel_name"].toString(),
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
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(.15),
                //     blurRadius: 20.0, // soften the shadow
                //     spreadRadius: 0.0, //extend the shadow
                //     offset: Offset(
                //       2.0, // Move to right 10  horizontally
                //       1.0, // Move to bottom 10 Vertically
                //     ),
                //   )
                // ],
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

                          SizedBox(width: 4,),

                          if(response['course_price'].length>0)...{
                            Text(
                              "\$"+response['course_price'][0]["new_price"].toString()!=
                                  null?response['course_price'][0]["new_price"].toString():"0.0",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1? intello_bg_color:Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              softWrap: false,
                              maxLines:1,
                            )




                          }
                          else...{
                            Text(
                              "\$0.0",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1? intello_bg_color:Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              softWrap: false,
                              maxLines:1,
                            )

                          }




                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                RatingBarIndicator(
                                  // rating:response["avg_rating"],
                                  rating:double.parse(response["avg_rating"].toString()
                                  ),
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
                                    color:intello_hint_color,
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
                                  child:

                                  Image.asset('assets/images/icon_level.png',
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
                                onTap: (){
                                //  _showToast(response["course_id"].toString());
                                  _addFavouriteDataList(courseId: response["course_id"].toString());
                                },
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
                                    onTap: (){
                                     // _showToast("qwe");
                                    },
                                    child:Container(
                                      padding: EdgeInsets.only(top: 7,bottom: 7),
                                      width: 60,
                                     // height: 25,
                                      decoration: new BoxDecoration(
                                        color:_darkOrLightStatus == 1 ?intello_bg_color:intello_bg_color,
                                        borderRadius: BorderRadius.circular(3),
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
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.withOpacity(.15),
                                        //     blurRadius: 20.0, // soften the shadow
                                        //     spreadRadius: 0.0, //extend the shadow
                                        //     offset: Offset(
                                        //       2.0, // Move to right 10  horizontally
                                        //       1.0, // Move to bottom 10 Vertically
                                        //     ),
                                        //   )
                                        // ],
                                      ),

                                      alignment: Alignment.center,
                                      child: Text("Enroll Now",

                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 9,
                                        color: Colors.white

                                      ),
                                        ),
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

  Widget _buildMostVisitedCourseItem({required double item_marginLeft,required double item_marginRight , required var response}) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
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
                                              image: "$BASE_URL"+response["channel_name"]["channel_name_logo"].toString(),
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
                                            response["channel_name"]["channel_name"],
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
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(.15),
                //     blurRadius: 20.0, // soften the shadow
                //     spreadRadius: 0.0, //extend the shadow
                //     offset: Offset(
                //       2.0, // Move to right 10  horizontally
                //       1.0, // Move to bottom 10 Vertically
                //     ),
                //   )
                // ],
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


                          if(response['course_price'].length>0)...{
                            Text(
                              "\$"+response['course_price'][0]["new_price"].toString()!=
                                  null?response['course_price'][0]["new_price"].toString():"0.0",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1? intello_bg_color:Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              softWrap: false,
                              maxLines:1,
                            )




                          }
                          else...{
                            Text(
                              "\$0.0",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:_darkOrLightStatus == 1? intello_bg_color:Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              softWrap: false,
                              maxLines:1,
                            )

                          }



                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                RatingBarIndicator(
                                  // rating:response["avg_rating"],
                                  rating:double.parse(response["avg_rating"].toString()
                                  ),
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
                                    color:intello_hint_color,
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
                                onTap: (){
                                  _addFavouriteDataList(courseId: response["course_id"].toString());
                                },
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
                                    onTap: (){
                                      // _showToast("qwe");
                                    },
                                    child:Container(
                                      padding: EdgeInsets.only(top: 7,bottom: 7),
                                      width: 60,
                                      // height: 25,
                                      decoration: new BoxDecoration(
                                        color:_darkOrLightStatus == 1 ?intello_bg_color:intello_bg_color,
                                        borderRadius: BorderRadius.circular(3),
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
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.withOpacity(.15),
                                        //     blurRadius: 20.0, // soften the shadow
                                        //     spreadRadius: 0.0, //extend the shadow
                                        //     offset: Offset(
                                        //       2.0, // Move to right 10  horizontally
                                        //       1.0, // Move to bottom 10 Vertically
                                        //     ),
                                        //   )
                                        // ],
                                      ),

                                      alignment: Alignment.center,
                                      child: Text("Enroll Now",

                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 9,
                                            color: Colors.white

                                        ),
                                      ),
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
  
  Widget _buildRecommendedForYouItem({required double item_marginLeft,required double item_marginRight, required var response}) {
    return InkResponse(
      onTap: (){

        Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen(teacherId: response["user_id"].toString() ,)));

      },
      child: Container(
        margin:  EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 30,top: 30),
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
          margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 15,left: 10),
          // height: double.infinity,
          // width: double.infinity,

          child: Center(
            child: Column(
              children: [


                Align(
                  alignment: Alignment.topCenter,

                  child: Image.network(
                    response["channel_name_logo"].toString(),
                    width: 65,
                    height: 65,
                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    response["channel_name"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines:1,
                  ),
                ),
                SizedBox(height: 5,),


                Text(
                  "Discover a popular language center for you",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:intello_hint_color,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                  softWrap: false,
                  maxLines:2,
                )

              ],
            ),
          ),
        ) ,
      ),
      // Container(
      //   width: 100,
      //   height: 100,
      //   decoration: new BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(12),
      //     boxShadow: [
      //       BoxShadow(
      //         // color: Colors.black.withOpacity(0.1),
      //         color: Colors.grey.withOpacity(.2),
      //         blurRadius: 20.0, // soften the shadow
      //         spreadRadius: 0.0, //extend the shadow
      //         offset: Offset(
      //           1.0, // Move to right 10  horizontally
      //           3.0, // Move to bottom 10 Vertically
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildBestTeacherAndCoachItem({required double item_marginLeft,required double item_marginRight, required var response}) {
    return InkResponse(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherProfileViewScreen(teacherId: response["id"].toString() ,)));

      },
      child: Container(
        margin:  EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 20,top: 30),
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
          margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 15,left: 10),
          // height: double.infinity,
          // width: double.infinity,

          child: Center(
            child: Column(
              children: [


                Align(
                  alignment: Alignment.topCenter,

                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        color:Colors.white,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/empty.png',
                          image: "$BASE_URL"+response["image"].toString(),
                          imageErrorBuilder: (context, url, error) =>
                              Image.asset(
                                'assets/images/empty.png',
                                fit: BoxFit.fill,
                              ),
                        )),

                  ),

                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    response["surname"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1?intello_bold_text_color:Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    softWrap: false,
                    maxLines:1,
                  ),
                ),
                SizedBox(height: 5,),

                Text(
                  "1.5M Followers",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:intello_hint_color,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                  softWrap: false,
                  maxLines:2,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      RatingBarIndicator(
                        rating:double.parse(response["avg_rating"].toString()
                        ),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color:intello_star_color,
                        ),
                        itemCount: 5,
                        itemSize: 14.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        response["avg_rating"].toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color:intello_hint_color,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                _buildSeeProfileButton(),


              ],
            ),
          ),
        ) ,
      ),
      // Container(
      //   width: 100,
      //   height: 100,
      //   decoration: new BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(12),
      //     boxShadow: [
      //       BoxShadow(
      //         // color: Colors.black.withOpacity(0.1),
      //         color: Colors.grey.withOpacity(.2),
      //         blurRadius: 20.0, // soften the shadow
      //         spreadRadius: 0.0, //extend the shadow
      //         offset: Offset(
      //           1.0, // Move to right 10  horizontally
      //           3.0, // Move to bottom 10 Vertically
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildSeeProfileButton() {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: InkResponse(
        onTap: () {

          // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
        },

        child:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [intello_bd_color, intello_bd_color],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.0)
          ),
          height: 30,
          width: 100,
          alignment: Alignment.center,
          child:  Wrap(
            children: [
              Text(
                "See Profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PT-Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCategoriesItem({required double item_marginLeft,required double item_marginRight,required var response}) {
    return Container(
      margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10),
      width: 150,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.assetNetwork(
                height: 120,
                fit: BoxFit.fill,
                placeholder: 'assets/images/loading.png',
                image: response["category_preview_img"],
                imageErrorBuilder: (context, url, error) =>
                    Image.asset(
                      'assets/images/loading.png',
                      fit: BoxFit.fill,
                    ),
              )
          ),

          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 5.0,top: 15),
            child:  Text(
              response["category_name"],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
              softWrap: false,
              maxLines:1,
            ),
          )

        ],
      ) ,
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

  void openCloseSideMenu() {
    NavigationBarScreen.openCloseSideMenu();
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
         // _showToast(response.statusCode.toString());

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

  _getTopCategoryDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _topCategoriesShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_TopCategory'),
            headers: {
              //"Authorization": "Token $accessToken",
            },
          );
         // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _topCategoriesShimmerStatus = false;
              var data = jsonDecode(response.body);
              _topCategory = data["data"];
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

  _getRecently_added_courseList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _recentlyAddedShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Recently_added_course'),
            headers: {
              //"Authorization": "Token $accessToken",


            },
          );
         // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _recentlyAddedShimmerStatus = false;
              var data = jsonDecode(response.body);
              _Recently_added_course = data["data"];
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

  _mostVisitedCourseList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         _mostVisitedShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Recently_added_course'),
            headers: {
              //"Authorization": "Token $accessToken",


            },
          );
         // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _mostVisitedShimmerStatus = false;
              var data = jsonDecode(response.body);
              _mostVisitedCourse = data["data"];
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

  _BestTeacherAndCoachList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _bestTeacherAndCoachShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Best_teacher_and_coach'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
        //  _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _bestTeacherAndCoachShimmerStatus = false;
              var data = jsonDecode(response.body);
              _BestTeacherCourse = data["data"];
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

  _Recommended_for_youList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _recommendedShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Best_Recommended_for_you'),
            headers: {
              //"Authorization": "Token $accessToken",
              // "Accept-Language": languageStatus,

            },
          );
         // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _recommendedShimmerStatus = false;
              var data = jsonDecode(response.body);
              _Recommended_for_you = data["data"];
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
    setState(() {
      _userId = sharedPreferences.getString(pref_user_id)!;
      _accessToken = sharedPreferences.getString(pref_user_access_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
      _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
    });
  }

  //shimmer
  Widget _buildRecentlyAddedCourseItemShimmer({required double item_marginLeft,required double item_marginRight}) {
    return Container(
      margin: EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 10),
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

  Widget _buildRecommendedForYouItemShimmer({required double item_marginLeft,required double item_marginRight}) {
    return Container(
      margin:  EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 30,top: 30),
      width: 180,
      decoration: new BoxDecoration(
        color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark1,
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
        margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 15,left: 10),
        // height: double.infinity,
        // width: double.infinity,

        child: Center(
          child: Column(
            children: [


              Align(
                alignment: Alignment.topCenter,

                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.5),

                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 15,
                    margin:  EdgeInsets.only(left: 25.0, right: 25.0),
                  //  width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),


              Shimmer.fromColors(
                baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                child:Container(
                  height: 45,
                  //  width: 65,
                  decoration: BoxDecoration(
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),

                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ) ,
    );
  }

  Widget _buildBestTeacherAndCoachItemShimmer({required double item_marginLeft,required double item_marginRight}) {
    return Container(
      margin:  EdgeInsets.only(left: item_marginLeft, right: item_marginRight,bottom: 20,top: 30),
      width: 180,
      decoration: new BoxDecoration(
        color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark1,
        // color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
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
        margin: EdgeInsets.only(right: 10.0,top: 15,bottom: 15,left: 10),
        // height: double.infinity,
        // width: double.infinity,

        child: Center(
          child: Column(
            children: [


              Align(
                alignment: Alignment.topCenter,

                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.5),

                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 15,
                    margin:  EdgeInsets.only(left: 25.0, right: 25.0),
                    //  width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 12,
                    margin:  EdgeInsets.only(left: 15.0, right: 15.0),
                    //  width: 65,
                    decoration: BoxDecoration(
                      color: shimmer_baseColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3,),
              Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 12,
                    margin:  EdgeInsets.only(left: 15.0, right: 15.0),
                    //  width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                  highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                  child:Container(
                    height: 34,
                    margin:  EdgeInsets.only(left: 25.0, right: 25.0),
                    //  width: 65,
                    decoration: BoxDecoration(
                      color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                      borderRadius: BorderRadius.all(
                        Radius.circular(17.0),

                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
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

          SizedBox(height: 15,),
          Align(
            alignment: Alignment.topCenter,
            child: Shimmer.fromColors(
              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
              child:Container(
                height: 15,
                margin:  EdgeInsets.only(left: 10.0, right: 10.0),
                //  width: 65,
                decoration: BoxDecoration(
                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),

                  ),
                ),
              ),
            ),
          ),

        ],
      ) ,
    );
  }

}
