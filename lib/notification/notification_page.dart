
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../home_page/course_details.dart';
import '../home_page/navigation_bar_page.dart';


class NotificationsScreen extends StatefulWidget {
  int darkOrLightStatus;


  NotificationsScreen(this.darkOrLightStatus);

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _NotificationsScreenState sss=new _NotificationsScreenState(this.darkOrLightStatus);
     // sss.colorStatus();

   }

}

class _NotificationsScreenState extends State<NotificationsScreen> {

  int _darkOrLightStatus;
  _NotificationsScreenState(this._darkOrLightStatus);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";

  int searchBoxVisible=0;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _darkOrLightToggleModeStatus=1;
  String _darkOrLightToggleButtonImageLink="";


  bool _shimmerStatus = false;
  List _MyCourse = [];
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  List _notificationList = [];
  bool _notificationShimmerStatus = true;

  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      _getNotificationDataList();
      });

  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,

      background:_darkOrLightStatus==1?intello_bg_color:intello_slide_bg_color_for_darkMode,
      menu: customMenu(),
      maxMenuWidth: 320,

      type: SideMenuType.shrinkNSlide,
      child:  Scaffold(
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
                      margin: new EdgeInsets.only(left: 20),
                      child: InkResponse(
                        onTap: () {
                          // Navigator.of(context).pop();
                          openCloseSideMenu();
                        },

                        child:Image.asset(
                          'assets/images/icon_menu_noti.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.fill,
                        ),


                      ),
                    ),
                    Expanded(child: Container(
                      margin: new EdgeInsets.only(right: 50),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Notifications",
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
                Expanded(child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:1,
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          if(_notificationShimmerStatus)...[
                            notificationListShimmer(),
                          ]else...[

                            ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _notificationList==null||_notificationList.length<=0?0:
                                _notificationList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return notificationDateWiseSectionDesign(_notificationList[index]);
                                }),

                            // if(_notificationList.length>0)...{
                            //   Align(
                            //     alignment: Alignment.centerLeft,
                            //     child:Container(
                            //       padding: EdgeInsets.only(left: 20, top: 00, right: 0, bottom: 10),
                            //       child: Text(
                            //         "Today",
                            //         style: TextStyle(
                            //             color:_darkOrLightStatus==1?intello_input_text_color:Colors.white,
                            //             fontSize: 15,
                            //             decoration: TextDecoration.none,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // },
                            //
                            // ListView.builder(
                            //     padding: EdgeInsets.zero,
                            //     itemCount: _notificationList==null||_notificationList.length<=0?0:
                            //     _notificationList.length,
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return notificationItemDesign(_notificationList[index]);
                            //     }),
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child:Container(
                            //     padding: EdgeInsets.only(left: 20, top: 00, right: 0, bottom: 10),
                            //     child: Text(
                            //       "Yesterday",
                            //       style: TextStyle(
                            //           color: _darkOrLightStatus==1?intello_input_text_color:Colors.white,
                            //           fontSize: 15,
                            //           decoration: TextDecoration.none,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // ListView.builder(
                            //     padding: EdgeInsets.zero,
                            //     itemCount:4,
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return notificationItemDesign1();
                            //     }),


                          ]

                        ],
                      );
                    }),


                )

              ],
            )));
  }

  Widget notificationDateWiseSectionDesign(var response) {
    return Column(
      children: [
       Align(alignment: Alignment.topLeft,
       child:Container(
         margin: EdgeInsets.only(left: 30),
         child: Text(
         response["day"].toString()!="Others"?response["day"].toString():response["date"].toString(),
         style: TextStyle(
             color:_darkOrLightStatus==1?intello_input_text_color:Colors.white,
             fontSize: 15,
             decoration: TextDecoration.none,
             fontWeight: FontWeight.bold),
       )
       ),
       ),
        ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: response["data"]==null||response["data"].length<=0?0:
        response["data"].length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
        return notificationItem(response["data"][index]);
        })
      ],
    );




  }

  Widget notificationItem(var response){
    return  SlidableAutoCloseBehavior(
      child: Slidable(

        // Specify a key if the Slidable is dismissible.
        key: ValueKey(0),


        endActionPane:ActionPane(
          extentRatio: .45,
          motion:DrawerMotion(),
          children: [

            SlidableAction(
              autoClose: true,

              padding: EdgeInsets.only(left: 10,right: 10),
              onPressed: (BuildContext context) {

                setState(() {
                  // _showToast("Delete");
                });

              },
              flex: 1,
              backgroundColor: intello_bg_color,
              foregroundColor: Colors.white,
              icon: Icons.archive_outlined,
              label: 'Archive',
            ),

            SlidableAction(
              autoClose: true,

              padding: EdgeInsets.only(left: 10,right: 10),
              onPressed: (BuildContext context) {

                setState(() {
                 // _showToast(response["notification_id"].toString());
                  _deleteNotificationDataList(response["notification_id"].toString());

                });

              },
              flex: 1,
              backgroundColor: intello_notification_delete_button_color,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
            ),
          ],
        ),


        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child:  Padding(padding: EdgeInsets.only(right:20,top: 10,left: 20,bottom: 20),
          child:  Flex(
            direction: Axis.horizontal,
            children: [

              Container(
                width: 56,
                height: 56,


                margin:const EdgeInsets.only(left:0, top: 00, right: 22, bottom: 00),
                // padding:const EdgeInsets.only(left:10, top: 10, right: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                        height: 56,
                        width: 56,
                        color:hint_color,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.fill,
                          placeholder: 'assets/images/empty.png',
                          image:BASE_URL_API+response["receiver_information"]["image"],
                          imageErrorBuilder: (context, url, error) =>
                              Image.asset(
                                'assets/images/empty.png',
                                fit: BoxFit.fill,
                              ),
                        )),
                  ),
                ),

              ),

              Expanded(child:Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                      response['receiver_information']["username"].toString()
                     ,
                      style: TextStyle(
                          color:_darkOrLightStatus==1?intello_input_text_color:Colors.white,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                      response["content"].toString(),
                    //  "Sed ut perspic unde omnis iste natus error."+"Sed ut perspic unde omnis iste natus error.Sed ut perspic unde omnis iste natus error.",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: intello_hint_color,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: hint_color,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          response["whenpublished"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: intello_hint_color,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  )


                ],
              ),),

            ],
          ),
        ),
      ),

    );
  }



  Widget customMenu() {
    return Container(
      child: ListView(
        children: [

          customMenuHeaderSection(),

          InkResponse(
            onTap: (){},
            child: customMenuItem(
                text_value: "Pro",
                image_link:"assets/images/icon_pro.png",
                icon_height: 18,
                icon_width: 13,
                margin_right:24
            ),
          ),

          InkResponse(
            onTap: (){},
            child: customMenuItem(
                text_value: "Contact Support",
                image_link:"assets/images/icon_contact.png",
                icon_height: 18,
                icon_width: 18,
                margin_right:19
            ),
          ),

          InkResponse(
            onTap: (){},
            child: customMenuItem(
                text_value: "Teach on IG Learn",
                image_link:"assets/images/icon_teach.png",
                icon_height: 18,
                icon_width: 13,
                margin_right:24
            ),
          ),

          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "Notifications",
                image_link:"assets/images/icon_notifications.png",
                icon_height: 18,
                icon_width: 16,
                margin_right:21
            ),
          ),

          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "Our Partners",
                image_link:"assets/images/icon_partners.png",
                icon_height: 13,
                icon_width: 18,
                margin_right:19
            ),
          ),

          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "Settings",
                image_link:"assets/images/icon_settings.png",
                icon_height: 18,
                icon_width: 18,
                margin_right:19
            ),
          ),

          InkResponse(
            onTap: (){},
            child: customMenuItem(
                text_value: "Log out",
                image_link:"assets/images/icon_logout.png",
                icon_height: 18,
                icon_width: 16,
                margin_right:21
            ),
          ),


          customMenuItemWithoutIcon(text_value: 'About Us'),
          customMenuItemWithoutIcon(text_value: 'Terms & Conditions'),
          customMenuItemWithoutIcon(text_value: 'Privacy Policy'),


          customMenuToggleButton(),


        ],
      ),

    );
  }

  Widget customMenuItem({required String text_value,required String image_link,
    required double icon_height,required double icon_width,required double margin_right}) {
    return InkResponse(
      onTap: (){

      },
      child: Container(
        padding:EdgeInsets.only(left: 40.0, right: 20.0,top: 15,bottom: 15),
        child: Flex(direction: Axis.horizontal,
          children: [
            Image.asset(image_link,
                height:icon_height,
                width: icon_width,
                fit: BoxFit.fill
            ),
            Container(width: margin_right,),
            Text(text_value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],

        ),

      ),
    );
  }

  Widget customMenuItemWithoutIcon({required String text_value}) {
    return Container(
      padding:EdgeInsets.only(left: 40.0, right: 20.0,top: 15,bottom: 15),
      child: Flex(direction: Axis.horizontal,
        children: [
          Text(text_value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          )
        ],

      ),

    );
  }

  Widget customMenuToggleButton() {
    return Container(
      padding:EdgeInsets.only(left: 40.0, right: 20.0,top: 40,bottom: 15),
      child: Flex(direction: Axis.horizontal,
        children: [
          Text("Light",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
           width: 15,
          ),
          InkResponse(
            onTap: (){
              if(_darkOrLightToggleModeStatus==1){
                setState(() {
                  _darkOrLightToggleModeStatus=2;
                  _darkOrLightStatus=2;
                });

              }else{
                setState(() {
                  _darkOrLightToggleModeStatus=1;
                  _darkOrLightStatus=1;
                });
              }
            },
            child:  Image.asset(
                _darkOrLightToggleModeStatus==1? 'assets/images/btn_light.png':'assets/images/btn_dark.png',
                height:35,
                width: 65,
                fit: BoxFit.fill
            ),
          ),

          SizedBox(
            width: 15,
          ),
          Text("Dark",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],

      ),

    );
  }
  
  Widget customMenuHeaderSection() {
    return Container(
      padding:EdgeInsets.only(left: 40.0, right: 10.0,top: 00,bottom: 40),
      child: Flex(direction: Axis.horizontal,
        children: [
          InkResponse(
            onTap: () {
              //_showToast("Pik clicked");
            },
            child: Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage('https://i.pinimg.com/236x/44/59/80/4459803e15716f7d77692896633d2d9a--business-headshots-professional-headshots.jpg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all( Radius.circular(26.0)),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),


          ),
          SizedBox(width: 12,),
          Expanded(child: Flex(direction: Axis.vertical,

            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text("Simon Lewis",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child:  Text("simon.lewis@gmail.com",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              )


            ],

          ))
        ],

      ),

    );
  }

  void openCloseSideMenu1() {
    if (_sideMenuKey.currentState!.isOpened) {
      _sideMenuKey.currentState!.closeSideMenu();
    } else {
      _sideMenuKey.currentState!.openSideMenu();
    }
  }

  void openCloseSideMenu() {
    NavigationBarScreen.openCloseSideMenu();
  }

   void colorStatus() {
    if (_darkOrLightStatus==1) {
      setState(() {
        _darkOrLightStatus=2;
      });
    } else {
      setState(() {
        _darkOrLightStatus=1;
      });
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

  Future<int> loadUserIdFromSharePref1() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(pref_user_dark_light_status)!;
  }




  _getNotificationDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _notificationShimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_MY_NOTIFICATION_LIST$_userId/'),
            headers: {
              //"Authorization": "Token $accessToken",
            },
          );
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _notificationShimmerStatus = false;
              var data = jsonDecode(response.body);
              _notificationList = data["data"];
              //_showToast(_notificationList.length.toString());
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

  _deleteNotificationDataList(String notificationId) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //  _notificationShimmerStatus = true;
        try {
          var response = await delete(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_DELETE_NOTIFICATION_LIST$notificationId/'),
            headers: {
              //"Authorization": "Token $accessToken",
            },
          );
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            setState(() {
              _getNotificationDataList();
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
  Widget notificationItemShimmer() {
    return Padding(padding: EdgeInsets.only(right:20,top: 10,left: 20,bottom: 20),
      child:  Flex(
        direction: Axis.horizontal,
        children: [
          Shimmer.fromColors(
            baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
            highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
            child:Container(
              width: 56,
              height: 56,


              margin:const EdgeInsets.only(left:0, top: 00, right: 22, bottom: 00),
              // padding:const EdgeInsets.only(left:10, top: 10, right: 10, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                      height: 56,
                      width: 56,
                    color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,

                  ),
                ),
              ),

            ),
          ),


          Expanded(child:Column(
            children: [
            Shimmer.fromColors(
              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
            child:Container(
              margin: const EdgeInsets.only(left: 0.0, right: 40.0),
              height: 15,
              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
            ),
            ),
              SizedBox(
                height: 5,
              ),
            Shimmer.fromColors(
              baseColor:_darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
              highlightColor:_darkOrLightStatus==1? shimmer_highlightColor:shimmer_highlightColorDark,
            child:Container(
              height: 35,
              color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
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
                  width: 130,
                  color: _darkOrLightStatus==1? shimmer_baseColor:shimmer_baseColorDark,
                ),
              ),
              )

            ],
          ),),

        ],
      ),
    );
  }

  Widget notificationListShimmer() {
    return  ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return notificationItemShimmer();
        });
  }




}
