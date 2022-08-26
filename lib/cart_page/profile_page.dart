
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../course/my_course_details.dart';
import '../home_page/course_details.dart';
import '../home_page/navigation_bar_page.dart';



class ProfilePageScreen extends StatefulWidget {

  int darkOrLightStatus;
  ProfilePageScreen(this.darkOrLightStatus);

  @override
  State<ProfilePageScreen> createState() =>
      _ProfilePageScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  int _darkOrLightStatus;


  _ProfilePageScreenState(this._darkOrLightStatus);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";

  int searchBoxVisible=0;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _darkOrLightToggleModeStatus=1;
  String _darkOrLightToggleButtonImageLink="";



  List _MyCourse = [];
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";

  bool _shimmerStatus = true;

  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      //_showToast(_userId.toString());
      _getMyCourseCourseDataList();
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ? intello_bg_color:
          intello_bg_color_for_darkMode,
        ),
        child: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              children: [

                Container(
                  height: 136,

                ),

                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(
                      color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),

                  ),
                ),


              ],
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                SizedBox(
                  height: 90,
                  // height: 30,
                ),
                Container(
                 height: 94,
                 child:  Flex(direction: Axis.horizontal,
                   children: [
                     Container(

                       height: 92,
                       width: 92,
                       margin: const EdgeInsets.only(right: 20,
                         left: 35,
                         //top: 20,
                       ),
                       decoration:  BoxDecoration(
                         color: Colors.amberAccent,
                         border: Border.all(
                             color: Colors.white,
                             width: 4
                         ),
                         borderRadius: BorderRadius.all(
                           Radius.circular(46.0),

                         ),
                       ),
                       child:ClipRRect(
                         borderRadius: BorderRadius.circular(46.0),
                         child: Container(
                             height: 92,
                             width: 92,
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
                     Expanded(child: Column(
                       children: [
                         Expanded(child: Container(
                           margin: EdgeInsets.only(right: 20),
                          // color: Colors.amberAccent,
                           child:  Align(
                             alignment: Alignment.topRight,
                             child: Container(

                               height: 32,
                               width: 32,
                               decoration: new BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: new BorderRadius.all(
                                     Radius.circular(8.0),
                                   )
                               ),
                               child:  Container(
                                 margin: const EdgeInsets.all(7),
                                 child:Image.asset("assets/images/icon_profile_edit.png",
                                   height: 15,
                                   width: 15,
                                 ),
                               ),
                             ),
                           ),
                         )),
                         Expanded(child: Container(
                           margin: EdgeInsets.only(right: 20,bottom: 5),
                           // color: Colors.amberAccent,
                           child:  Align(
                             alignment: Alignment.bottomRight,
                             child: Wrap(
                               direction: Axis.horizontal,
                               children: [
                                 Image.asset("assets/images/icon_trophy.png",
                                   height: 20,
                                   width: 20,
                                 ),
                                 SizedBox(width: 15,),
                                 Text("Reward",
                                 style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                   fontSize: 15,
                                   color: intello_text_color
                                 ),
                                 ),
                               ],
                             ),
                           ),
                         )),
                       ],

                     ))
                   ],
                 ),
               ),
                Flex(direction: Axis.horizontal,
                children: [
                  Expanded(child:
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.topLeft,
                    child: Column(
                      // direction: Axis.vertical,
                      // alignment: WrapAlignment.center,
                      children: [
                        Text("Daniel Snowman",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: intello_text_color
                          ),
                        ),
                        Text("@Dr.Smith",
                          //  textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: intello_level_color
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  Expanded(child:
                  Container(
                    height: 83,
                    margin: EdgeInsets.only(right: 20,top: 15),
                  //  padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.topLeft,

                    decoration:  BoxDecoration(
                      color:intello_categoriesBox_bg_color,

                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),

                      ),
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Column(
                         // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15,top: 15),
                                child:  Image.asset("assets/images/icon_star.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),


                            Align(
                              alignment: Alignment.topLeft,
                              child:  Container(
                                margin: EdgeInsets.only(left: 15,top: 10),
                                child:Text("Great Job",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: intello_text_color
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                        Expanded(child: Container(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child:  Container(
                                  margin: EdgeInsets.only(left: 15,top: 10),
                                  child:Flex(direction: Axis.horizontal,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 7),
                                        alignment: Alignment.center,
                                        height: 15,
                                        width: 15,
                                        decoration:  BoxDecoration(
                                          color: intello_color_green,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7.5),

                                          ),
                                        ),
                                        child: Text(
                                          "+1",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 7,
                                            fontWeight: FontWeight.w600

                                          ),
                                        ),
                                      ),
                                      Text("Intelligence",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color: intello_text_color
                                        ),
                                      )
                                    ],

                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child:  Container(
                                  margin: EdgeInsets.only(left: 15,top: 10),
                                  child:Flex(direction: Axis.horizontal,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 7),
                                        alignment: Alignment.center,
                                        height: 15,
                                        width: 15,
                                        decoration:  BoxDecoration(
                                          color: intello_color_green,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7.5),

                                          ),
                                        ),
                                        child: Text(
                                          "+2",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 7,
                                              fontWeight: FontWeight.w600

                                          ),
                                        ),
                                      ),
                                      Text("Edurance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color: intello_text_color
                                        ),
                                      )
                                    ],

                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child:  Container(
                                  margin: EdgeInsets.only(left: 15,top: 10),
                                  child:Flex(direction: Axis.horizontal,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 7),
                                        alignment: Alignment.center,
                                        height: 15,
                                        width: 15,
                                        decoration:  BoxDecoration(
                                          color: intello_color_green,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7.5),

                                          ),
                                        ),
                                        child: Text(
                                          "+3",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 7,
                                              fontWeight: FontWeight.w600

                                          ),
                                        ),
                                      ),
                                      Text("Strenght",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color: intello_text_color
                                        ),
                                      )
                                    ],

                                  ),
                                ),
                              ),



                            ],
                          ),
                        )),
                      ],

                    ),

                  ),),
                ],
                ),
                SizedBox(
                  height: 60,
                  // height: 30,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(

                      color:_darkOrLightStatus == 1 ?intello_bg_color:intello_bottom_bg_color_for_dark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: _buildBottomDesignForList(),
                  ),
                ),

              ],
            )

          ],
        ),

        /* add child content here */
      ),
    );
  }

  Widget _buildBottomDesignForList() {
    return Container(
      margin: EdgeInsets.only(top: 12),
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 8,
              width: 80,
              // color:ig_inputBoxBackGroundColor_for_dark,
              decoration: BoxDecoration(
                color:_darkOrLightStatus == 1 ? intello_course_topic_sl_bg_for_light:ig_inputBoxBackGroundColor_for_dark,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
            ),

            SizedBox(height: 10,),

            InkResponse(
              onTap: (){},
              child:_buildCartItemForList(text: "Settings",iconLink:'assets/images/icon_settings.png'),
            ),

            InkResponse(
              onTap: (){},
              child:_buildCartItemForList(text: "Billing Details",iconLink:'assets/images/icon_billing_details.png'),
            ),

            InkResponse(
              onTap: (){},
              child:_buildCartItemForList(text: "User Management",iconLink:'assets/images/icon_user_management.png'),
            ),

            Container(
              margin: EdgeInsets.only(top: 20,left: 20,right: 20),
              height: 5,
              decoration:  BoxDecoration(
                color:_darkOrLightStatus == 1 ? tabColor:intello_bottom_bg_color_for_dark,
                borderRadius: BorderRadius.all(
                  Radius.circular(2.0),
                ),
            ),
            ),

            InkResponse(
              onTap: (){},
              child:_buildCartItemForList(text: "Information",iconLink:'assets/images/icon_information.png'),
            ),

            InkResponse(
              onTap: (){},
              child:_buildCartItemForList(text: "Item Menu",iconLink:'assets/images/icon_item_menu.png'),
            )


          ],
        ),
    );
  }

  Widget _buildCartItemForList({required String text,required String iconLink}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child:  Flex(direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20,right: 15),
            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
            decoration:  BoxDecoration(
              // color: tabColor,
              color:_darkOrLightStatus == 1 ? tabColor:intello_bottom_bg_color_for_dark,
              borderRadius: BorderRadius.all(

                Radius.circular(15.0),
              ),
            ),

            height: 41,
            width: 41,
            child: Image.asset(
              iconLink,
              color:intello_text_color ,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: intello_text_color
            ),
          ),),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            child: Icon(
              Icons.arrow_forward_ios,
              color:intello_text_color,
              size: 22.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEnrollNowField() {
    return Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 14, bottom: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                        color: _darkOrLightStatus==1? intello_bg_color:intello_bg_color,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                           Expanded(child:  Text(
                             "\$490 - Checkout",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontFamily: 'PT-Sans',
                               fontSize: 18,
                               fontWeight: FontWeight.w600,
                               color: Colors.white,
                             ),
                           ),),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            SizedBox(width: 20,)
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

  _getMyCourseCourseDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_MY_courese_list$_userId'),
            headers: {
              //"Authorization": "Token $accessToken",


            },
          );
          //   _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _shimmerStatus = false;
              var data = jsonDecode(response.body);
              _MyCourse = data["data"];
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
     // _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
    });
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

  //shimmer design
  Widget myCourseItemShimmer() {
    return Container(
      margin: EdgeInsets.only(right: 20.0, top: 0, bottom: 20, left: 20),
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
                      height: 120,
                      width: 120,
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

                        Align(alignment: Alignment.topLeft,
                          child:  Shimmer.fromColors(
                            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
                            child:Container(
                              height: 15,
                             // width: 130,
                              color:_darkOrLightStatus == 1 ? Colors.white:shimmer_containerBgColorDark,
                            ),
                          ),
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
                                  height: 25,
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
      ),
    );


  }

  Widget myCourseListShimmer() {
    return  ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return myCourseItemShimmer();
        });
  }

}
