import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/sharePreferenceDataSaveName.dart';

class VideoPlayDetailsPageScreen extends StatefulWidget {
  const VideoPlayDetailsPageScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayDetailsPageScreen> createState() => _VideoPlayDetailsPageScreenState();
}

class _VideoPlayDetailsPageScreenState extends State<VideoPlayDetailsPageScreen> {

  int _darkOrLightStatus=1;
  var list_name = List.generate(100, (index) => 0);
  int allExpandedCollapseStatus=1;



  Color topicsTextColor = Colors.white;
  Color materialsTextColor = Colors.black;
  Color itemsTextColor = Colors.black;
  Color topicsTabColor =intello_bg_color;
  Color materialsTabColor =tabColor;
  Color itemsTabColor = tabColor;
  int des_rev_less_status = 1;

  Color favoriteColor = Colors.pink;


  @protected
  @mustCallSuper
  void initState() {
    if(_darkOrLightStatus==1){
      topicsTextColor = Colors.white;
      materialsTextColor = Colors.black;
      itemsTextColor = Colors.black;
      topicsTabColor = intello_bd_color;
      materialsTabColor = tabColor;
      itemsTabColor = tabColor;
      des_rev_less_status = 1;
    }
    else{
      topicsTextColor = Colors.white;
      materialsTextColor = Colors.white;
      itemsTextColor = Colors.white;
      topicsTabColor = intello_bd_color;
      materialsTabColor = intello_bg_color_for_darkMode;
      itemsTabColor = intello_bg_color_for_darkMode;
      des_rev_less_status = 1;
    }

    // loadUserIdFromSharePref().then((_) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Flex(
          direction: Axis.vertical,
          children: [
           Expanded(child:
           Stack(
             children: [

               Container(
                 height: 330,
                 width:MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image: NetworkImage('https://mernlmsassets.s3.ap-south-1.amazonaws.com/Thumbnails/Competitive%20Programming%20-Thumbnail.png'),
                     fit: BoxFit.fill,
                   ),
                 ),
                 child: Center(
            child: Image.asset(
              "assets/images/play2.png",
              height: 70,
              width: 70,
              fit: BoxFit.fill,
            ),
          ),
               ),
               _buildBottomDesign()

             ],
           )),

          ],
        ) /* add child content here */,
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
      margin: EdgeInsets.only(top: 300),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 00, top: 10, right: 00, bottom: 0),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 6,
                  width: 80,
                 // color:ig_inputBoxBackGroundColor_for_dark,
                  decoration: BoxDecoration(
                    color:_darkOrLightStatus == 1 ? intello_bottom_close_color_for_light:ig_inputBoxBackGroundColor_for_dark,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        margin:EdgeInsets.only(left: 20,right: 20) ,
                        child: Text(
                          "Learn how to pitch and grow your business, how to make your ideas speak!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color:_darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                              // color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),

                      ),

                      Container(
                        margin:EdgeInsets.only(left: 20,right: 20) ,
                        child: _buildTrainerInfoSection(),

                      ),
                      SizedBox(height: 25,),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Container(
                              height: 20,
                              width: 20,
                              child:allExpandedCollapseStatus==1?
                              InkResponse(
                                onTap: (){
                                  setState(() {
                                    allExpandedCollapseStatus=2;
                                    list_name = List.generate(100, (index) => 1);
                                  });

                                },
                                child:Image.asset(
                                  "assets/images/expand.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ) ,
                              ) : InkResponse(
                                onTap: (){
                                  setState(() {
                                    allExpandedCollapseStatus=1;
                                    list_name = List.generate(100, (index) => 0);
                                  });

                                },
                                child:Image.asset(
                                  "assets/images/icon_collapse.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
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
                                  child: Text(
                                    "Expand / Collapse All",
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

                      ListView.builder(
                        itemCount: 5,

                        // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildLessonListItem(index);
                        },
                      ),
                    ],
                  ),
                )),

                _buildTabButton()

              ],
            )));
  }

  Widget _buildTrainerInfoSection() {
    return Container(
        width: double.infinity,
        alignment: Alignment.topLeft,
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          padding:
          const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 0),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [

                  InkResponse(
                    onTap: () {

                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                          height: 28,
                          width: 28,
                          color:intello_bg_color,
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/images/empty.png',
                            image:"https://images.thedailystar.net/sites/default/files/styles/big_202/public/feature/images/hero_alam-web.jpg",
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
                            "Mario rossi  •  Trainer and Speaker",
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

  Widget _buildLessonListItem( int indexs) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: '10',)));
      },
      child:
      Container(
        margin: EdgeInsets.only(right: 20.0, top: 0, bottom: 15, left: 20),
        //width: 180,
        decoration: new BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(

            color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.2):intello_bg_color_for_darkMode,
            //  blurRadius: 20.0, // soften the shadow
            blurRadius: _darkOrLightStatus == 1?15:0, // soften the shadow
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
            padding: EdgeInsets.only(right: 15.0, top: 20, bottom: 20, left: 15),
            child: Column(
              children: [
                Flex(direction: Axis.horizontal,
                children: [
                  Expanded(child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      "Chapter $indexs : Allow people to comment",

                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                      softWrap: false,
                      maxLines: 2,
                    ),
                  )),
                  if(list_name[indexs]==1)...{
                    InkResponse(
                      onTap: (){
                      setState(() {
                        list_name[indexs]=0;
                        });

                      },
                      child:Image.asset("assets/images/icon_collapse.png",
                        width: 20,
                        height: 20,

                      ),
                    ),

                  }else...{
                    InkResponse(
                      onTap: (){

                        setState(() {
                          list_name[indexs]=1;
                        });
                      },
                      child:Image.asset("assets/images/expand.png",
                        width: 20,
                        height: 20,
                      ),
                    ),

                  }
                ],
                ),
                if(list_name[indexs]==1)...{
                  ListView.builder(
                    itemCount: indexs+1,

                    // itemCount: orderRoomList == null ? 0 : orderRoomList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

                      if(index==0){
                        return Column(
                          children: [
                            Container(height: 1,
                              margin: EdgeInsets.only(top: 20),
                              color: intello_bottom_close_color_for_light,
                            ),
                            _buildLessonListItem1(index),
                          ],

                        );
                      }
                      else{
                        return Column(
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                SizedBox(width: 5,),
                                Align(alignment: Alignment.topLeft,
                                  child:Container(
                                  //  margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.center,
                                    width: 24,
                                    child: Image.asset(
                                      _darkOrLightStatus==1?
                                      "assets/images/icon_dots.png":"assets/images/icon_dots_dark.png",
                                     // color:  Colors.white,
                                      //color:_darkOrLightStatus==1?intello_course_topic_sl_bg_for_light:intello_bg_color,
                                      height:30 ,
                                      width:4 ,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Container(),
                                ),

                              ],
                            ),
                            _buildLessonListItem1(index),
                          ],

                        );
                      }

                    },
                  ),

                }



              ],
            ),


          ),
        ),
      ),





    );
  }

  Widget _buildLessonListItem1(int index) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: '10',)));
      },
      child: Container(
        padding: EdgeInsets.only(right: 5.0, top: 15, bottom: 5, left: 5),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Align(alignment: Alignment.topLeft,
                  child:Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                        color:index%2==0? _darkOrLightStatus==1?intello_course_topic_sl_bg_for_light:intello_bg_color:
                        _darkOrLightStatus==1?intello_course_topic_sl_bg_for_light2:intello_color_green,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    height: 24,
                    width: 24,
                    child: Text(index.toString(),
                    style: TextStyle(
                        color:index%2==0? _darkOrLightStatus==1?intello_bg_color:Colors.white:
                        _darkOrLightStatus==1?intello_color_green:Colors.white,

                     // color:_darkOrLightStatus==1?intello_bg_color:Colors.white,
                      fontWeight: FontWeight.w500

                    ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),

                Expanded(
                  child:  Flex(
                    direction: Axis.vertical,
                    children: [


                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Introduction",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 5,),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Flex(direction: Axis.horizontal,
                          children: [
                            Text(
                              "1 hours 35 minutes",
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  value(index)+"%"
                 ,
                  style: TextStyle(
                      color:_darkOrLightStatus==1?intello_text_color:Colors.white,
                      //color: intello_text_color,
                      fontWeight: FontWeight.w500

                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: CircularPercentIndicator(
                    radius: 17.0,
                    lineWidth: 2.0,
                    percent: (1/(index+1))/2,
                    center: Container(
                      margin: const EdgeInsets.all(1),
                      child: Image.asset("assets/images/play2.png"),
                    ),
                    backgroundColor: Colors.transparent,
                    progressColor:intello_bg_color,
                  ),
                )


              ],
            ),
          ],

        ),
      ),

    );
  }

  Widget _buildTabButton() {
    return Container(

      decoration: new BoxDecoration(
        color: _darkOrLightStatus == 1 ?Colors.white:intello_bottom_bg_color_for_dark,
        // color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(

          color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.2):intello_bg_color_for_darkMode,
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
                    topicsTextColor = Colors.white;
                    materialsTextColor = Colors.black;
                    itemsTextColor = Colors.black;
                    topicsTabColor = intello_bd_color;
                    materialsTabColor = tabColor;
                    itemsTabColor = tabColor;
                    des_rev_less_status = 1;
                  }
                  else{
                    topicsTextColor = Colors.white;
                    materialsTextColor = Colors.white;
                    itemsTextColor = Colors.white;
                    topicsTabColor = intello_bd_color;
                    materialsTabColor = intello_bg_color_for_darkMode;
                    itemsTabColor = intello_bg_color_for_darkMode;
                    des_rev_less_status = 1;
                  }

                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                margin: const EdgeInsets.only(left: 10.0, right: 5.0),
                decoration: BoxDecoration(
                  color: topicsTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Topics",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: topicsTextColor,
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
                    topicsTextColor = Colors.black;
                    materialsTextColor = Colors.white;
                    itemsTextColor = Colors.black;
                    topicsTabColor = tabColor;
                    materialsTabColor =intello_bg_color;
                    itemsTabColor = tabColor;
                    des_rev_less_status = 2;
                  }
                  else{
                    topicsTextColor = Colors.white;
                    materialsTextColor = Colors.white;
                    itemsTextColor = Colors.white;
                    topicsTabColor = intello_bg_color_for_darkMode;
                    materialsTabColor = intello_bd_color;
                    itemsTabColor = intello_bg_color_for_darkMode;
                    des_rev_less_status = 2;
                  }


                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: materialsTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Materials",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: materialsTextColor,
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
                    topicsTextColor = Colors.black;
                    materialsTextColor = Colors.black;
                    itemsTextColor = Colors.white;
                    topicsTabColor = tabColor;
                    materialsTabColor = tabColor;
                    itemsTabColor = intello_bg_color;
                    des_rev_less_status = 3;
                  }
                  else{
                    topicsTextColor = Colors.white;
                    materialsTextColor = Colors.white;
                    itemsTextColor = Colors.white;
                    topicsTabColor = intello_bg_color_for_darkMode;
                    materialsTabColor = intello_bg_color_for_darkMode;
                    itemsTabColor = intello_bd_color;
                    des_rev_less_status = 3;
                  }


                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 5.0, right: 10.0),
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: itemsTabColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Text(
                  "Items",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: itemsTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),

          Container(
            // width: 30,
            // height: 30,
           margin: EdgeInsets.only(left: 0.0, right: 10.0),
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10, top: 10),
            decoration: BoxDecoration(
              color: itemsTabColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0)),
            ),
            child:Image.asset(
              "assets/images/group_icon.png",
              width: 20,
              height: 20,
              // fit: BoxFit.fill,
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 10),
          //   child:Image.asset(
          //     "assets/images/group_icon.png",
          //     width: 30,
          //     height: 25,
          //    // fit: BoxFit.fill,
          //   ),
          // )
        ],
      ),
    );
  }

  String  value(int  index){
    int a= (((1/(index+1))/2)*100).toInt();
    return a.toString();
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



}


