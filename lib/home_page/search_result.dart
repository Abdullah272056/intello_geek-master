import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/home_page/search_not_found.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';

class SearchResultFileScreen extends StatefulWidget {
  String inputValue;
  SearchResultFileScreen({required this.inputValue});

  @override
  State<SearchResultFileScreen> createState() => _SearchResultFileScreenState(this.inputValue);
}

class _SearchResultFileScreenState extends State<SearchResultFileScreen>{

  String _inputValue;
  _SearchResultFileScreenState(this._inputValue);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();
  int _darkOrLightStatus=1;

  List _search_result_course = [];

  bool _searchResultShimmerStatus = true;
  String _searchResultCount="0";

  @protected
  @mustCallSuper
  void initState() {
    loadUserIdFromSharePref().then((_) {
      _getRecently_added_courseList(_inputValue);
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
              height: 50,
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
                      "Search Result",
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
              height: 30,
            ),

            if(_searchResultShimmerStatus)...[
              Expanded(
                child: _buildBottomDesignForGridShimmer(),
              ),
            ]else...{
              if(_search_result_course.length>0)...{
                Expanded(
                  child: _buildBottomDesign(),
                ),
              }
              else...{
              }

            }

          ],
        ),

        /* add child content here */
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
        //  color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
            child: Column(
              children: [

              Container(
                margin:  EdgeInsets.only(left: 10.0, right: 20.0,top: 10,bottom: 20),
                child:  Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$_searchResultCount Result for $_inputValue",
                    style: TextStyle(
                        color:_darkOrLightStatus == 1 ? intello_search_result_text_color:
                        Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
                
               Expanded(child:  GridView.builder(
                   padding: EdgeInsets.only(top: 5,),
                   itemCount: _search_result_course==null||_search_result_course.length<=0?0:
                   _search_result_course.length,
                   gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                     crossAxisSpacing: 10.0,
                     mainAxisSpacing: 10.0,
                       mainAxisExtent: 235
                   ),
                   itemBuilder: (BuildContext context, int index) {
                     return _buildSearchResultItem(_search_result_course[index]);
                   }),)

              ],
            )));
  }


  Widget _buildSearchResultItem(var response) {
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
                                        "$BASE_URL"+response["course_information"]["channel_name"]["channel_name_logo"].toString(),
                                        imageErrorBuilder:
                                            (context, url, error) =>
                                            Image.asset(
                                              'assets/images/empty.png',
                                              fit: BoxFit.fill,
                                            ),
                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      response["course_information"]["channel_name"]["channel_name"],
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
                                        response["course_information"]["course_duration"].toInt().toString()+" min",
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
              margin: EdgeInsets.only(right: 10.0,top: 10,bottom: 10,left: 10),
              // height: double.infinity,
              // width: double.infinity,
              //color: Colors.white,
              color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,

              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        response["course_information"]["course_title"].toString(),
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
                        Text(
                          // "ertydefedf",
                          //    response["course_price"]==null?"test":response["course_price"]["teacher_id"].toString(),

                          "\$"+response["new_price"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(

                              color:_darkOrLightStatus == 1 ?intello_bg_color:Colors.white,
                              // color: intello_bd_color_deep,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          softWrap: false,
                          maxLines:1,
                        )

                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            children: [
                              RatingBarIndicator(
                                rating:response['course_information']["avg_rating"].toString()!=null?
                                double.parse(response['course_information']["avg_rating"].toString()):0.0,
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
                              response['course_information']["avg_rating"].toString()!=null?
                                response["course_information"]["avg_rating"].toString():"0.0",
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
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Wrap(
                    //         children: [
                    //           RatingBarIndicator(
                    //             rating:4.5,
                    //             itemBuilder: (context, index) => Icon(
                    //               Icons.star,
                    //               color:intello_star_color,
                    //             ),
                    //             itemCount: 5,
                    //             itemSize: 17.0,
                    //            // unratedColor: intello_bd_color_deep,
                    //             direction: Axis.horizontal,
                    //           ),
                    //           SizedBox(
                    //             width: 4,
                    //           ),
                    //           Text(
                    //             "4.5",
                    //             style: TextStyle(
                    //               fontSize: 13,
                    //               color:intello_hint_color,
                    //               fontWeight: FontWeight.normal,
                    //             ),
                    //             maxLines: 2,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //
                    //   ],
                    // ),

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
                                      onTap: () {},
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
                                                      fontSize: 8,
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
                        return _buildSearchListItemShimmer();
                      }),
                )
              ],
            )));
  }

  Widget _buildSearchListItemShimmer() {
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

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;

      });
    } catch(e) {
      //code
    }

  }


  _getRecently_added_courseList(String searchValue) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _searchResultShimmerStatus = true;
        try {
          var response = await post(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_HOME_SEARCH'),
            headers: {
              //"Authorization": "Token $accessToken",


            },
            body: {
              "search_key":searchValue,
            }
          );
        //  _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _searchResultShimmerStatus = false;
              var data = jsonDecode(response.body);
              _search_result_course = data["data"];
              _searchResultCount=_search_result_course.length.toString();
              if(_search_result_course.length<1){
                Navigator.pop(context);
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SearchNotFoundScreen(inputValue: _inputValue,)));
              }

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

}
