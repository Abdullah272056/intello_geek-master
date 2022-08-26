import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/sharePreferenceDataSaveName.dart';

class VideoPlayPreviousPageScreen extends StatefulWidget {
  const VideoPlayPreviousPageScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayPreviousPageScreen> createState() => _VideoPlayPreviousPageScreenState();
}

class _VideoPlayPreviousPageScreenState extends State<VideoPlayPreviousPageScreen> {
  int _darkOrLightStatus=1;

  @protected
  @mustCallSuper
  void initState() {
    loadUserIdFromSharePref().then((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(


        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://mernlmsassets.s3.ap-south-1.amazonaws.com/Thumbnails/Competitive%20Programming%20-Thumbnail.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Flex(
          direction: Axis.vertical,
          children: [
           Expanded(child: Column(
             children: [
               SizedBox(
                 height: MediaQuery.of(context).size.height / 15,
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
                             "Course Video",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 20,
                                 fontWeight: FontWeight.w600),
                           ),
                         ),
                       )),
                 ],
               ),
               Expanded(child: Center(
                 child: Image.asset(
                   "assets/images/play2.png",
                   height: 70,
                   width: 70,
                   fit: BoxFit.fill,
                 ),
               ))
               ,
             ],
           )),
            _buildBottomDesign()
          ],
        ) /* add child content here */,
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
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
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 30),
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

                if (MediaQuery.of(context).orientation == Orientation.portrait)...{
                  // is portrait
                  Text(
                    "Learn how to pitch and grow your business, how to make your ideas and speak!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1 ?intello_bold_text_color:Colors.white,
                       // color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width/15,
                        fontWeight: FontWeight.w600),
                  ),
                }else...{
                  Text(
                    "Learn how to pitch and grow your business, how to make your ideas and speak!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color:_darkOrLightStatus == 1 ? intello_bold_text_color:Colors.white,
                        fontSize: MediaQuery.of(context).size.height/15,
                        fontWeight: FontWeight.w600),
                  ),
                },

              ],
            )));
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


