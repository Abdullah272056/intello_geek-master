import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/registration/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import 'course_details.dart';

class MostVisitedCourseSeeMoreScreen extends StatefulWidget {
  const MostVisitedCourseSeeMoreScreen({Key? key}) : super(key: key);

  @override
  State<MostVisitedCourseSeeMoreScreen> createState() =>
      _MostVisitedCourseSeeMoreScreenState();
}

class _MostVisitedCourseSeeMoreScreenState extends State<MostVisitedCourseSeeMoreScreen> {
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  Color businessAndCompanyTextColor = Colors.white;
  Color financeTextColor = Colors.black;
  Color iAAndBigDataTextColor = Colors.black;
  Color digitalMarketingTextColor = Colors.black;

  Color businessAndCompanyTabColor = intello_bd_color;
  Color financeTabColor = tabColor;
  Color iAAndBigDataTabColor = tabColor;
  Color digitalMarketingTabColor =tabColor;

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";




  String languageStatus="en";
  bool _shimmerStatus = true;
  List _mostVisitedCourse = [];

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;

  @override
  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      _getMostVisitedCourseDataList();
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
              height: MediaQuery.of(context).size.height / 16,
              // height: 50,
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
                      margin: new EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Most Visited",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),


                Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: InkWell(

                    onTap: () {

                      if(list_grid_status==1){
                        setState(() {
                          list_grid_status=2;
                          list_grid_image_icon_link = "assets/images/grid.png";
                        });


                      }
                      else {
                        setState(() {
                          list_grid_status=1;
                          list_grid_image_icon_link = "assets/images/icon_list.png";
                        });

                      }

                    },
                    child: Image.asset(
                      list_grid_image_icon_link,
                      width: 25,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
              // height: 30,
            ),

            // Expanded(
            //       child: _buildBottomDesignForGrid(),
            //     ),
            if(_shimmerStatus)...[
              Expanded(
                child: _buildBottomDesignForGridShimmer(),
              ),
            ]else...[
              if (list_grid_status == 1) ...{
                Expanded(
                  child: _buildBottomDesignForGrid(),
                ),
              }
              else if (list_grid_status == 2) ...{
                Expanded(
                  child: _buildBottomDesignForList(),
                ),
              }
              else ...{
                  Expanded(
                    child: _buildBottomDesignForGrid(),
                  ),
                },
            ]


          ],
        ),

        /* add child content here */
      ),
    );
  }


  Widget _buildBottomDesignForGrid() {
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
            padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      itemCount: _mostVisitedCourse==null||_mostVisitedCourse.length<=0?0:
                      _mostVisitedCourse.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          mainAxisExtent: 230),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildMostVisitedCourseItemForGrid(_mostVisitedCourse[index]);
                      }),
                )
              ],
            )));
  }

  Widget _buildMostVisitedCourseItemForGrid(var response) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: SizedBox(
                height: 150,
                child: Stack(children: <Widget>[
                  FadeInImage.assetNetwork(
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: 'assets/images/loading.png',
                    image:
                    "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                    imageErrorBuilder: (context, url, error) => Image.asset(
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
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 2),
                        child: Column(
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(17.0),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      color: Colors.white,
                                      child: FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder: 'assets/images/empty.png',
                                        image:
                                        "$BASE_URL"+response["channel_name"]["channel_name_logo"].toString(),
                                        imageErrorBuilder:
                                            (context, url, error) =>
                                            Image.asset(
                                              'assets/images/empty.png',
                                              fit: BoxFit.fill,
                                            ),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      response["channel_name"]["channel_name"].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                  response["course_duration"].toString()+"min",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
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
              )),
          Container(

            margin:  EdgeInsets.only(left: 5.0, right: 5.0,top: 100),

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
              //color: Colors.white,
              color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,

              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        response["course_title"].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                            //color: Colors.intello_bold_text_color,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        softWrap: false,
                        maxLines:2,
                      ),
                    ),

                    SizedBox(height: 5,),
                    Flex(direction: Axis.horizontal,
                      children:  [
                        Expanded(child: Text(
                          "72 Participants",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color:intello_hint_color,
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

                                color:_darkOrLightStatus == 1 ?intello_bg_color:Colors.white,
                                // color: intello_bd_color_deep,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            softWrap: false,
                            maxLines:1,
                          ),


                        }
                        else...{
                          Text(
                            "\$"+"0.0",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:_darkOrLightStatus == 1 ? intello_bg_color:Colors.white,

                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            softWrap: false,
                            maxLines: 2,
                          ),

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
                              rating:double.parse(response["avg_rating"].toString()),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color:intello_star_color,
                                ),
                                itemCount: 5,
                                itemSize: 17.0,
                                // unratedColor: intello_bd_color_deep,
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
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkResponse(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/icon_level.png',
                              width: MediaQuery.of(context).size.width / 22,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkResponse(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/icon_share.png',
                              width: MediaQuery.of(context).size.width / 22,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkResponse(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/icon_certificate.png',
                              width: MediaQuery.of(context).size.width / 22,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkResponse(
                                      onTap: () {
                                        _addFavouriteDataList(courseId: response["course_id"].toString());
                                      },
                                      child: Image.asset(
                                        'assets/images/heart.png',
                                        width:
                                        MediaQuery.of(context).size.width /
                                            22,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Align(
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
                                                  padding: EdgeInsets.only(top: 5,bottom: 5),
                                                 // width: 60,
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
                                                        fontSize: 7,
                                                        color: Colors.white

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),


                                      // Align(
                                      //   alignment: Alignment.centerRight,
                                      //   child: Container(
                                      //     margin: const EdgeInsets.only(right: 0),
                                      //     child: InkResponse(
                                      //       onTap: () {},
                                      //       child: Image.asset(
                                      //         'assets/images/btn_enroll.png',
                                      //         // width: MediaQuery.of(context).size.width/8,
                                      //         //height: 20,
                                      //         fit: BoxFit.fill,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )

                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ) ,
          ),

        ],
      ),
    );
  }



  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: intello_bg_color,
        textColor: Colors.white,
        fontSize: 16.0);
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
            padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _mostVisitedCourse==null||_mostVisitedCourse.length<=0?0:
                      _mostVisitedCourse.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildMostVisitedCourseItemForList(_mostVisitedCourse[index]);
                      }),
                )
              ],
            )));
  }
  // Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen()));

  Widget _buildMostVisitedCourseItemForList(var response) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
        Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: response["course_id"].toString(),)));
      },
      child:
      Container(
        margin: EdgeInsets.only(right: 20.0, top: 0, bottom: 10, left: 20),
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
        child:Container(
          margin: EdgeInsets.only(right: 10.0, top: 10, bottom: 10, left: 10),
          //color: Colors.white,
          child: SizedBox(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(children: <Widget>[
                        FadeInImage.assetNetwork(
                          height: 120,
                          width: 120,
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
                        Center(
                          child: Image.asset(
                            "assets/images/play.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 2),
                              child: Column(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        child: Container(
                                            height: 20,
                                            width: 20,
                                            color: Colors.white,
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              placeholder:
                                              'assets/images/empty.png',
                                              image:
                                              "$BASE_URL"+response["channel_name"]["channel_name_logo"].toString(),
                                              imageErrorBuilder:
                                                  (context, url, error) =>
                                                  Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.fill,
                                                  ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding:
                                          EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            response["channel_name"]["channel_name"].toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.w500),
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
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text(
                                              response["course_duration"].toString()+"min",
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.w500),
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
                    )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child:Container(
                      height: 120,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // direction: Axis.vertical,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Flex(
                              direction: Axis.horizontal,
                              children:  [
                                Expanded(
                                  child: Text(
                                    response["course_title"].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    softWrap: false,
                                    maxLines: 1,
                                  ),


                                ),
                                SizedBox(width: 5,),

                                if(response['course_price'].length>0)...{
                                  Text(
                                    "\$"+response['course_price'][0]["new_price"].toString()!=
                                        null?response['course_price'][0]["new_price"].toString():"0.0",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_bg_color:Colors.white,

                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    softWrap: false,
                                    maxLines: 2,
                                  )



                                }
                                else...{
                                  Text(
                                    "\$0.0",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:_darkOrLightStatus == 1 ? intello_bg_color:Colors.white,

                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    softWrap: false,
                                    maxLines: 2,
                                  )

                                }


                              ],
                            ),

                          ),


                          Flex(
                            direction: Axis.horizontal,
                            children: const [
                              Expanded(
                                  child: Text(
                                    "72 Participants",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:intello_hint_color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    softWrap: false,
                                    maxLines: 1,
                                  )),

                            ],
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating:double.parse(response["avg_rating"].toString()),
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

                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: InkResponse(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/icon_level.png',
                                    width:
                                    MediaQuery.of(context).size.width / 18,
                                    height: 25,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: InkResponse(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/icon_share.png',
                                    width:
                                    MediaQuery.of(context).size.width / 18,
                                    height: 25,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: InkResponse(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/icon_certificate.png',
                                    width:
                                    MediaQuery.of(context).size.width / 18,
                                    height: 25,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          child: InkResponse(
                                            onTap: () {
                                              _addFavouriteDataList(courseId: response["course_id"].toString());
                                            },
                                            child: Image.asset(
                                              'assets/images/heart.png',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  18,
                                              height: 25,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                margin: const EdgeInsets.only(right: 3),
                                                child: InkResponse(
                                                  onTap: (){
                                                    // _showToast("qwe");
                                                  },
                                                  child:Container(
                                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                                    // width: 60,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        6,
                                                    height: 25,
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
                                                          fontSize: 8,
                                                          color: Colors.white

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              // Container(
                                              //   margin: const EdgeInsets.only(right: 0),
                                              //   child: InkResponse(
                                              //     onTap: () {},
                                              //     child: Image.asset(
                                              //       'assets/images/btn_enroll.png',
                                              //       width: MediaQuery.of(context)
                                              //           .size
                                              //           .width /
                                              //           6,
                                              //       height: 25,
                                              //       fit: BoxFit.fill,
                                              //     ),
                                              //   ),
                                              // ),
                                            )),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  _getMostVisitedCourseDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // offerShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_Most_visited_course_see_more'),
            headers: {
              //"Authorization": "Token $accessToken",


            },
          );
         // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
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

  Widget _buildBottomDesignForGridShimmer() {
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
            padding: const EdgeInsets.only(left: 10, top: 00, right: 10, bottom: 20),
            child: Column(
              children: [

                Expanded(
                  child: GridView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 20.0,
                          mainAxisExtent: 230),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildRecentlyAddedCourseDataListShimmer();
                      }),
                )
              ],
            )));
  }

  Widget _buildRecentlyAddedCourseDataListShimmer() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            //width: 180,
              margin: EdgeInsets.only(right: 10.0, top: 0, bottom: 10, left: 10),
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
                        margin: EdgeInsets.only(right: 5.0,left: 5,bottom: 10),
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
                            left: 5, right: 5, top: 5, bottom: 2),
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

            margin:  EdgeInsets.only(left: 15.0, right: 15.0,top: 100),

            //width: 180,
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
              // color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,

              child: Center(
                child:Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child:  Shimmer.fromColors(
                        // baseColor:shimmer_baseColor,
                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                        child:Container(
                          margin: EdgeInsets.only(right: 10.0,),

                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          height: 12,
                          width: double.infinity,


                        ),
                      ),


                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Shimmer.fromColors(
                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                        child:Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          height: 14,
                          width: double.infinity,


                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Shimmer.fromColors(
                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                        child:Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          height: 14,
                          width: double.infinity,


                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Shimmer.fromColors(
                        baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                        highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                        child:Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                          height: 14,
                          width: double.infinity,


                        ),
                      ),
                    ),
                    SizedBox(height: 5,),

                    Expanded(child: Center(
                      child:   Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                            child:Container(
                              margin: const EdgeInsets.only(right: 5),
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              height: 20,
                              width: 20,


                            ),
                          ),

                          Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                            child:Container(
                              margin: const EdgeInsets.only(right: 5),
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              height: 20,
                              width: 20,


                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                            child:Container(
                              margin: const EdgeInsets.only(right: 5),
                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                              height: 20,
                              width: 20,


                            ),
                          ),
                          Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                      highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                      child:Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                        height: 20,
                                        width: 20,


                                      ),
                                    ),
                                    Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child:  Shimmer.fromColors(
                                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark1,
                                            child:Container(
                                              margin: const EdgeInsets.only(right: 5),
                                              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark1,
                                              height: 20,
                                              width: 40,


                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ))

                  ],
                ),
              ),
            ) ,
          ),
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
