import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/course/my_course_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../api_service/sharePreferenceDataSaveName.dart';
import '../cart_page/profile_page.dart';
import '../notification/notification_page.dart';
import '../registration/log_in.dart';
import 'home_page.dart';

class NavigationBarScreen extends StatefulWidget {
  int _selectedTabIndex;
  //int _selectedPageIndex;
  Widget _selectedPage;


  NavigationBarScreen(this._selectedTabIndex, this._selectedPage);
  // NavigationBarScreen(this._selectedTabIndex, this._selectedPageIndex, {Key? key}) : super(key: key);

  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState(this._selectedTabIndex, this._selectedPage);

  static void openCloseSideMenu() {
    _NavigationBarScreenState.openCloseSideMenu();

  }
}

class _NavigationBarScreenState extends State<NavigationBarScreen> with SingleTickerProviderStateMixin{
  int _selectedTabIndex;
  Widget _selectedPage;
 // int _selectedPageIndex;


  _NavigationBarScreenState(this._selectedTabIndex, this._selectedPage);

  final navigationkey = GlobalKey<CurvedNavigationBarState>();

  int _selectedIndexa = 0;
  // int _selectedTabIndex = 0;
  // int _selectedPageIndex = 0;
  final items1 = <Widget>[
    Image.asset("assets/images/home_icon.png",
        color: Colors.white,
        width: 25, height: 25,),
    Image.asset("assets/images/explore_icon.png",
        width: 25, height: 25, color: Colors.white),
    Image.asset("assets/images/blog_icon.png",
        width: 25, height: 25, color: Colors.white),
    Image.asset("assets/images/cart_icon.png",
        width: 25, height: 25, color: Colors.white),
    Image.asset("assets/images/profile_icon.png",
        width: 25, height: 25, color: Colors.white),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
     // _selectedPageIndex = index;
      if(index==0){
        _selectedPage= HomeScreen(_darkOrLightStatus);
        return;
      }

      if(index==1){
        _selectedPage= MyCourseScreen(_darkOrLightStatus);
        return;
      }

      if(index==2){
        _selectedPage= MyCourseScreen(_darkOrLightStatus);
        return;
      }

      if(index==3){
        _selectedPage= NotificationsScreen(_darkOrLightStatus);
        return;
      }

      if(index==4){
        _selectedPage= ProfilePageScreen(1);
        return;
      }

    });
  }

  List<Widget> _widgetOptions1 = <Widget>[
    // HomeScreen(),
    // MyCourseScreen(),
    // MyCourseScreen(),
    // NotificationsScreen(_darkOrLightStatus),
    // HomeScreen(),
    // RoomDetailsScreen("1"),
    // CartPageScreen()
  ];


  late final TabController _tabcontroller;

  int _darkOrLightStatus=1;
  int _darkOrLightToggleModeStatus=1;
  String _darkOrLightToggleButtonImageLink="";
 static final GlobalKey<SideMenuState> sideMenuKey1 = GlobalKey<SideMenuState>();

  @override
  void initState() {
    _tabcontroller = TabController(length: 5, vsync: this);
    super.initState();

    loadUserIdFromSharePref().then((_) {
      _darkOrLightToggleModeStatus=_darkOrLightStatus;
      //_tabcontroller = TabController(length: 5, vsync: this);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: sideMenuKey1,

      background:_darkOrLightToggleModeStatus==1?intello_bg_color:intello_slide_bg_color_for_darkMode,
      menu: customMenu(),
      maxMenuWidth: 320,

      type: SideMenuType.shrinkNSlide,
      child:  Scaffold(
        //backgroundColor: Colors.intello_bd_color_dark,
        body:  Center(
          child: _selectedPage,
          // child: _widgetOptions.elementAt(_selectedPageIndex),
        ),

        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
            color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
          ),

          child: TabBar(
            controller: _tabcontroller,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.green,
            indicatorWeight: 4,
            indicatorColor: _darkOrLightStatus == 1 ? intello_tab_indicator_color_for_light:intello_tab_indicator_color_for_dark,
            onTap: (index) {
              _onItemTapped(index);
              // currentIndex: _selectedTabIndex,
              //   selectedItemColor: Colors.amber[800],
            },
            tabs: [
              Tab(
                icon:_tabcontroller.index == 0 ?
                _darkOrLightStatus==1? Image.asset('assets/images/tab_home_active.png', height: 20, width: 20,) :
                Image.asset('assets/images/tab_home_active.png', height: 20, width: 20,
                    color: Colors.white
                ) :
                Image.asset('assets/images/tab_home.png', height: 20, width: 20,)
                ,
              ),
              Tab(
                icon:_tabcontroller.index == 1 ?
                _darkOrLightStatus==1? Image.asset('assets/images/tab_cat_active.png', height: 20, width: 20,) :
                Image.asset('assets/images/tab_cat_active.png', height: 20, width: 20,
                    color: Colors.white
                ) :
                Image.asset('assets/images/tab_cat.png',
                  height: 20, width: 20,
                ),


              ),
              Tab(
                icon:_tabcontroller.index == 2 ?
                _darkOrLightStatus==1? Image.asset('assets/images/tab_mycourses_active.png', height: 20, width: 20,) :
                Image.asset('assets/images/tab_mycourses_active.png', height: 20, width: 20,
                    color: Colors.white
                ) :
                Image.asset('assets/images/tab_mycourses.png',
                  height: 20, width: 20,
                ),

              ),
              Tab(
                icon:_tabcontroller.index == 3 ?
                _darkOrLightStatus==1? Image.asset('assets/images/tab_noti_active.png', height: 20, width: 20,) :
                Image.asset('assets/images/tab_noti_active.png', height: 20, width: 20,
                    color: Colors.white
                ) :
                Image.asset('assets/images/tab_noti.png',
                  height: 20, width: 20,
                ),

              ),
              Tab(
                icon:_tabcontroller.index == 4 ?
                _darkOrLightStatus==1? Image.asset('assets/images/tab_profile_active.png', height: 20, width: 20,) :
                Image.asset('assets/images/tab_profile_active.png', height: 20, width: 20,
                    color: Colors.white
                ) :
                Image.asset('assets/images/tab_profile.png',
                  height: 20, width: 20,
                ),

              ),

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
                text_value: "Teach on IntelloGeek",
                image_link:"assets/images/icon_teach.png",
                icon_height: 18,
                icon_width: 13,
                margin_right:24
            ),
          ),

          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "My Rewards",
                image_link:"assets/images/icon_notifications.png",
                icon_height: 18,
                icon_width: 16,
                margin_right:21
            ),
          ),

          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "My Cart",
                image_link:"assets/images/icon_notifications.png",
                icon_height: 18,
                icon_width: 16,
                margin_right:21
            ),
          ),
          InkResponse(
            onTap: (){},
            child:customMenuItem(
                text_value: "Travel Abroad",
                image_link:"assets/images/icon_settings.png",
                icon_height: 18,
                icon_width: 16,
                margin_right:21
            ),
          ),

          // InkResponse(
          //   onTap: (){},
          //   child:customMenuItem(
          //       text_value: "Notifications",
          //       image_link:"assets/images/icon_notifications.png",
          //       icon_height: 18,
          //       icon_width: 16,
          //       margin_right:21
          //   ),
          // ),
          //
          // InkResponse(
          //   onTap: (){},
          //   child:customMenuItem(
          //       text_value: "Our Partners",
          //       image_link:"assets/images/icon_partners.png",
          //       icon_height: 13,
          //       icon_width: 18,
          //       margin_right:19
          //   ),
          // ),
          //
          // InkResponse(
          //   onTap: (){},
          //   child:customMenuItem(
          //       text_value: "Settings",
          //       image_link:"assets/images/icon_settings.png",
          //       icon_height: 18,
          //       icon_width: 18,
          //       margin_right:19
          //   ),
          // ),

          InkResponse(
            onTap: (){
              removeUserInfo();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LogInScreen(),), (route) => false,);
            },
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
    return Container(
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
                  saveUserInfo(2);
                  _darkOrLightToggleModeStatus=2;
                  _darkOrLightStatus=2;

                  setState(() {
                //    MyCourseScreen.colorStatusChange();


                  });

                });

              }else{
                setState(() {
                  saveUserInfo(1);
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

  static void openCloseSideMenu() {
    if (sideMenuKey1.currentState!.isOpened) {
      sideMenuKey1.currentState!.closeSideMenu();
    } else {
      sideMenuKey1.currentState!.openSideMenu();
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

  void saveUserInfo(int dark_light_status) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt(pref_user_dark_light_status, dark_light_status);
    } catch (e) {
      //code
    }
  }

  void removeUserInfo() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString(pref_user_id, "");
      sharedPreferences.setString(pref_user_uuid, "");
      sharedPreferences.setString(pref_user_access_token, "");
      sharedPreferences.setString(pref_user_refresh_token, "");
      sharedPreferences.setString(pref_user_email, "");
      //sharedPreferences.setString(pref_user_password, userInfo['email'].toString());

    } catch (e) {
      //code
    }

    //
    // sharedPreferences.setString(pref_user_UUID, userInfo['data']["user_name"].toString());
    // sharedPreferences.setBool(pref_login_firstTime, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_cartID, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_county, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_city, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_state, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_nid, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_nid, userInfo['data']["user_name"].toString());
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        // _userId = sharedPreferences.getString(pref_user_id)!;
        // _accessToken = sharedPreferences.getString(pref_user_access_token)!;
        // _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;

      });
    } catch(e) {
      //code
    }

  }

}

