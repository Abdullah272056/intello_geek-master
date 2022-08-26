
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



class CartPageScreen extends StatefulWidget {

  int darkOrLightStatus;
  CartPageScreen(this.darkOrLightStatus);

  @override
  State<CartPageScreen> createState() =>
      _CartPageScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _CartPageScreenState extends State<CartPageScreen> {
  int _darkOrLightStatus;


  _CartPageScreenState(this._darkOrLightStatus);

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
              height: MediaQuery.of(context).size.height / 15,
              // height: 50,
            ),
            Container(
              height: 55,
              child: Flex(
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
                            "Cart items",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),

                  Stack(
                    children: [
                     Container(
                       height: 37,
                       width: 37,
                       margin: const EdgeInsets.only(right: 20,
                         //top: 20,
                       ),
                       child:Stack(
                         children: [
                           Align(
                             alignment: Alignment.bottomLeft,
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
                                 child:Image.asset("assets/images/iconly_light_bag.png",
                                   height: 15,
                                   width: 15,
                                 ),
                               ),
                             ),
                           ),
                           Align(
                             alignment: Alignment.topRight,
                             child: Container(

                               height: 15,
                               width: 15,
                               decoration: new BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: new BorderRadius.all(
                                     Radius.circular(7.50),
                                   )
                               ),
                               child: Container(
                                 margin: const EdgeInsets.all(1.5),

                                 decoration: new BoxDecoration(
                                     color: intello_bg_color,
                                     borderRadius: new BorderRadius.all(
                                       Radius.circular(6),
                                     )

                                 ),
                                 child:Align(
                                   alignment: Alignment.center,
                                   child: Text(
                                     "5",
                                     overflow: TextOverflow.clip,
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 8,
                                         fontWeight:
                                         FontWeight.w600),
                                     softWrap: false,
                                     maxLines: 1,
                                   ),
                                 ),

                               ),

                             ),
                           ),
                         ],
                       )


                     ),
                    ],
                  )

                ],
              ),
            ),


            SizedBox(
              height: 17,
              // height: 30,
            ),




            Expanded(
              child: _buildBottomDesignForList(),
            ),


          ],
        ),

        /* add child content here */
      ),
    );
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
            padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 00),

            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCartItemForList();
                      }),
                ),

                // if(_shimmerStatus)...[
                //   Expanded(
                //     child: myCourseListShimmer(),
                //   ),
                // ]else...[
                //   Expanded(
                //     child: ListView.builder(
                //         padding: EdgeInsets.zero,
                //         itemCount: _MyCourse==null||_MyCourse.length<=0?0:
                //         _MyCourse.length,
                //         shrinkWrap: true,
                //         physics: ClampingScrollPhysics(),
                //         itemBuilder: (BuildContext context, int index) {
                //           return _buildMYCourseItemForList();
                //         }),
                //   )
                // ]

                _buildEnrollNowField()

              ],
            )));
  }

  Widget _buildCartItemForList() {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
       // Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: response["course_id"].toString(),)));
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
                      height: 90,
                      width: 90,
                      child: Stack(children: <Widget>[
                        FadeInImage.assetNetwork(
                          height: 90,
                          width: 90,
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
                            height: 40,
                            width: 40,
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
                                        BorderRadius.circular(8.0),
                                        child: Container(
                                            height: 16,
                                            width: 16,
                                            color: Colors.white,
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              placeholder:
                                              'assets/images/empty.png',
                                              image:
                                            //  "$BASE_URL"+response["channel_name"]["channel_name_logo"],
                                              "https://www.arenawebsecurity.net/static/media/mainLogo.7e69599a.png",
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
                                            "ABC Learning Center",
                                           // response["channel_name"]["channel_name"],
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
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
                                              "45 mins",
                                              // response["course_duration"].toString()+"min",
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6,
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
                    child:Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // direction: Axis.vertical,
                      //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Flex(
                            direction: Axis.horizontal,
                            children:  [
                              Expanded(
                                child: Text(
                                  "Ultimate Google Ads Training Online Now",
                                  // response["course_title"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  maxLines: 2,
                                ),


                              ),
                              Text(
                                "\$4.99",
                                // "\$"+response["course_price"][0]["new_price"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:_darkOrLightStatus == 1 ? intello_color_green:intello_bg_color,

                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                softWrap: false,
                                maxLines: 1,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 5,left: 10),
                                child: InkResponse(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/group_icon.png',
                                    width: 4,
                                    height: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "77 Participants | ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:intello_hint_color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                              softWrap: false,
                              maxLines: 1,
                            ),
                            Text(
                              "32 Total Hours | ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:intello_hint_color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                              softWrap: false,
                              maxLines: 1,
                            ),
                            Expanded(
                                child: Text(
                                  "3 Module",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:intello_hint_color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                  softWrap: false,
                                  maxLines: 1,
                                )
                            ),


                          ],
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating:4,
                              // rating:double.parse(response["avg_rating"].toString()),
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
                              "(4.6)",
                              // response["avg_rating"].toString(),
                              style: TextStyle(
                                fontSize: 13,
                                color:intello_hint_color,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 2,
                            ),
                            Expanded(child: Container()),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: InkResponse(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/iconly_light_delete.png',
                                  width: 17,
                                  height: 17,
                                ),
                              ),
                            ),
                            SizedBox(width: 6,),
                            Container(
                              margin: const EdgeInsets.only(right: 5,top: 2),
                              child: InkResponse(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/iconly_light_heart.png',
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),


                      ],
                    )
                ),
              ],
            ),
          ),
        ),
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
