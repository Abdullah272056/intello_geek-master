
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



class TermsAndServicePageScreen extends StatefulWidget {

  int darkOrLightStatus;
  TermsAndServicePageScreen(this.darkOrLightStatus);

  @override
  State<TermsAndServicePageScreen> createState() =>
      _TermsAndServicePageScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _TermsAndServicePageScreenState extends State<TermsAndServicePageScreen> {
  int _darkOrLightStatus;


  _TermsAndServicePageScreenState(this._darkOrLightStatus);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";

  int searchBoxVisible=0;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _darkOrLightToggleModeStatus=1;
  String _darkOrLightToggleButtonImageLink="";

  String termsText="Pellentesque habitant morbi tristique senectus et netus "
      "et malesuada fames ac turpis egestas. Ut arcu libero, pulvinar "
      "non massa sed, accumsan scelerisque dui. Morbi purus mauris, vulputate "
      "quis felis nec, fermentum aliquam orci. Quisqueornare iaculis placerat."
      " Class aptent taciti sociosqu ad litora torquent per conubia nostra, per"
      " inceptos himenaeos. In commodo sem arcu, sed fermentum tortor consequat vel."
      " Phasellus lacinia quam quis leo tincidunt vehicula.";



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
                Flex(
                  direction: Axis.horizontal,
                  children: [

                    Expanded(child: Align(alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/note_icon.png",
                          height: 20,
                          width: 18,
                          color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,

                        ),
                      ),
                    )),

                    Expanded(child: Align(alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Image.asset(
                          "assets/images/icon_cross.png",
                          height: 15,
                          width: 15,
                          color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,

                        ),
                      ),
                    )),

                  ],

                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildTermsConditionItemForList(index);
                      }),
                ),

                _buildEnrollNowField()

              ],
            )));
  }


  Widget _buildTermsConditionItemForList(int index) {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
       // Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen(courseId: response["course_id"].toString(),)));
      },
      child:
      Container(
        margin: new EdgeInsets.only(right: 20,left: 20),
        child: Column(
          children: [
            Container(
              margin: new EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (index+1).toString()+"  ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: intello_bg_color_deep,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Agrement",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  termsText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: intello_search_view_hint_color,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            )


          ],

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
                        child:Text(
                          "I Accept",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PT-Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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



}
