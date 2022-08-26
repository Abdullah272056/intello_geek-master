
import 'dart:convert';
import 'dart:io';

import 'package:delayed_widget/delayed_widget.dart';
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
import 'my_course_details.dart';


class MyCourseScreen extends StatefulWidget {

  int darkOrLightStatus;
  MyCourseScreen(this.darkOrLightStatus);

  @override
  State<MyCourseScreen> createState() =>
      _MyCourseScreenState(this.darkOrLightStatus);

   static void colorStatusChange() {
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _MyCourseScreenState extends State<MyCourseScreen> {
  int _darkOrLightStatus;


  _MyCourseScreenState(this._darkOrLightStatus);

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
    return SideMenu(
      key: _sideMenuKey,

      background:_darkOrLightToggleModeStatus==1?intello_bg_color:intello_slide_bg_color_for_darkMode,
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
              if(searchBoxVisible==0)...{
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
                          child: Icon(
                            Icons.menu_rounded,
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
                                "My Courses",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )),


                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: InkWell(

                          onTap: () {
                            setState(() {
                              searchBoxVisible=1;
                            });
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
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              }
              else...{
                DelayedWidget(

                  delayDuration: Duration(milliseconds: 100),// Not required
                  animationDuration: Duration(milliseconds: 500),// Not required
                  animation: DelayedAnimations.SLIDE_FROM_RIGHT,// Not required
                  child: userInputSearchField(_emailController!, 'Search courses', TextInputType.text),
                ),

              },


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

  Widget userInputSearchField(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: new EdgeInsets.only(left: 20,right: 20),
      decoration: BoxDecoration(
          color: _darkOrLightStatus==1?Colors.white:
          intello_bottom_bg_color_for_dark,

          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, top: 0,bottom: 0, right: 10),
        child: TextFormField(
          controller: userInput,
          textInputAction: TextInputAction.search,
          autofocus: true,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color: Colors.white,
          style: TextStyle(color:_darkOrLightStatus==1?intello_hint_color: Colors.white,),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: IconButton(
               // color: Colors.intello_input_text_color,
                icon: Icon(
                  Icons.search,
                  color:_darkOrLightStatus==1?intello_hint_color: Colors.white,

                  //color: Colors.intello_hint_color,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    searchBoxVisible=0;
                    _getMyCourseCourseDataList();
                  });
                }),

            // suffixIconConstraints: BoxConstraints(
            //   minHeight: 15,
            //   minWidth: 15,
            // ),
            // suffixIcon: Image(
            //   image: AssetImage(
            //     'assets/images/icon_email.png',
            //   ),
            //   height: 18,
            //   width: 22,
            //   fit: BoxFit.fill,
            // ),

            hintText: hintTitle,

            hintStyle:  TextStyle(fontSize: 17,
                color:_darkOrLightStatus==1?intello_hint_color: Colors.white,
               // color: Colors.intello_hint_color,
                fontStyle: FontStyle.normal),
          ),
          onChanged: (value){
            if(value.isEmpty){
              _getMyCourseCourseDataList();
            }

          },
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              _search_courseList(value);
              // _showToast(value);
             /// Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchResultFileScreen(inputValue: value,)));
            }
          },

          keyboardType: keyboardType,
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
               if(_shimmerStatus)...[
                 Expanded(
                   child: myCourseListShimmer(),
                 ),
               ]else...[
                 Expanded(
                   child: ListView.builder(
                       padding: EdgeInsets.zero,
                       itemCount: _MyCourse==null||_MyCourse.length<=0?0:
                       _MyCourse.length,
                       shrinkWrap: true,
                       physics: ClampingScrollPhysics(),
                       itemBuilder: (BuildContext context, int index) {
                         return _buildMYCourseItemForList(_MyCourse[index]);
                       }),
                 )
               ]



              ],
            )));
  }

  Widget _buildMYCourseItemForList(var response) {
    return
      InkResponse(
        onTap: (){

          Navigator.push(context,MaterialPageRoute(builder: (context)=>MyCourseDetailsScreen(courseId: response["course_id"].toString() ,)));

        },
        child:
        Container(
          margin: EdgeInsets.only(right: 20.0, top: 0, bottom: 20, left: 20),
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
          child:ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                child:Slidable(

                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(0),


                  endActionPane:ActionPane(
                     //extentRatio: .40,
                    motion:ScrollMotion(),
                    children: [

                      Expanded(child:  InkWell(

                        onTap: () {},
                        child: Container(
                         // padding: EdgeInsets.only(left: 10,right: 10),
                          color: intello_bg_color_deep,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Container(
                               width: 20,
                               height: 18,
                               child:  Image.asset(
                                 'assets/images/archive.png',
                                 fit: BoxFit.fill,
                                 color: Colors.white,

                               ),
                             ),
                              SizedBox(height: 8,),

                              Text(
                                'Archive',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),),
                      Expanded(child:  InkWell(
                        onTap: () {},
                        child: Container(
                        //  padding: EdgeInsets.only(left: 10,right: 10),
                          color: intello_button_color_green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save_alt,
                                size: 22,
                                color: Colors.white,

                              ),

                              SizedBox(height: 8,),

                              Text(
                                'Download',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),),


                    ],
                  ),


                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Container(
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
                                                        "45 mins",
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
                              child: Align(
                                alignment: Alignment.center,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children:  [
                                          Expanded(
                                            child: Text(
                                              response["course_info"]["course_title"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(

                                                  color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                                  // color: Colors.intello_text_color,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              softWrap: false,
                                              maxLines: 2,
                                            ),


                                          ),
                                        ],
                                      ),

                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        if(response["course_info"]["course_created"]["about_info"]!=null &&
                                            response["course_info"]["course_created"]["about_info"].length>0)...{
                                          Expanded(
                                              child: Text(
                                                response["course_info"]["course_created"]["surname"]+", "+ response["course_info"]["course_created"]["about_info"][0]["about_title"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:intello_hint_color,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400),
                                                softWrap: false,
                                                maxLines: 1,
                                              )),
                                        }
                                        else...[
                                          Expanded(
                                              child: Text(
                                                response["course_info"]["course_created"]["surname"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:intello_hint_color,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400),
                                                softWrap: false,
                                                maxLines: 1,
                                              )),
                                        ]



                                      ],
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
                                                  child:  Text(
                                                    "34 / 98 Module",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color:intello_hint_color,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w400),
                                                    softWrap: false,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child:Flex(direction: Axis.horizontal,
                                                      children: [
                                                        Expanded(child:  LinearPercentIndicator(
                                                          // width: MediaQuery.of(context).size.width/3.9,
                                                          animation: true,
                                                          lineHeight: 10.0,
                                                          animationDuration: 700,
                                                          percent: 0.73,
                                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                                          backgroundColor: _darkOrLightStatus == 1 ? intello_Indicator_bg_color_for_light:intello_Indicator_bg_color_for_dark,
                                                          progressColor: _darkOrLightStatus == 1 ? intello_color_green:intello_bg_color,

                                                        ),),
                                                        Text(
                                                          "73%",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                        SizedBox(width: 7,)
                                                      ],
                                                    )
                                                ),

                                              ],
                                            )),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 10, top: 10, bottom: 0),
                                          child:  ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: InkResponse(
                                                onTap: (){

                                                  //  _showToast("clicked");


                                                },
                                                child: Align(alignment: Alignment.bottomRight,
                                                  child: Container(
                                                    height: 25,
                                                    width: 70,
                                                    color:intello_bg_color,
                                                    child: Align(alignment: Alignment.center,
                                                      child:  Text("Resume Course",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 8,
                                                              fontWeight: FontWeight.w400)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
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
                ),
              )),


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

  _search_courseList(String searchValue) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _shimmerStatus = true;
        try {
          var response = await post(
              Uri.parse(
                  '$BASE_URL_API$SUB_URL_API_MY_COURSE_SEARCH'),
              headers: {
                //"Authorization": "Token $accessToken",


              },
              body: {
                "search_key":searchValue,
                "student_id":_userId,
              }
          );
           _showToast(response.statusCode.toString());

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
      _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
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
