import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/home_page/search_result.dart';
import 'package:intello_geek/registration/sign_up.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/sharePreferenceDataSaveName.dart';

class SearchNotFoundScreen extends StatefulWidget {
  String inputValue;

  SearchNotFoundScreen({required this.inputValue});

  @override
  State<SearchNotFoundScreen> createState() => _SearchNotFoundScreenState(this.inputValue);

}

class _SearchNotFoundScreenState extends State<SearchNotFoundScreen> {

  String _inputValue;
  _SearchNotFoundScreenState(this._inputValue);

  TextEditingController? searchController = TextEditingController();
  int _darkOrLightStatus=2;
  @protected
  @mustCallSuper
  void initState() {
    loadUserIdFromSharePref().then((_) {
      searchController?.text=_inputValue;
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
                      "Search IG",
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
            Expanded(
              child: _buildBottomDesign(),
            ),
          ],
        ),

        /* add child content here */
      ),
    );
  }

  Widget _buildTextFieldSearch() {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: searchController,
        autofocus: true,
        textInputAction: TextInputAction.go,
        //cursorColor: Colors.hint_color,
        cursorColor:_darkOrLightStatus==1?hint_color:intello_bg_color ,

        cursorHeight: 24,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty) {
            // _showToast(value);
            Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchResultFileScreen(inputValue: value,)));
          }
        },
        style:TextStyle(
            fontSize: 20,
            // color: Colors.black,
            color:_darkOrLightStatus==1?intello_input_text_color:intello_hint_color,
            decoration: TextDecoration.none),
        decoration: InputDecoration(

          filled: true,
          fillColor: Colors.transparent,
          contentPadding:EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.search,
            color:intello_hint_color,
            size: 25,
          ),
          suffixIcon: IconButton(
              color: hint_color,
              icon:ImageIcon(
                AssetImage("assets/images/icon_filter.png"),
                color:intello_hint_color,
              ),
              onPressed: () {
                setState(() {
                  String searchTxt = searchController!.text;
                  if (searchTxt.isNotEmpty) {
                    _showToast("ok");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             NavigationBarScreen(0,HomeSearchResultPageScreen(searchTxt))));
                    //
                    //
                  } else {
                    // _showToast("Enter a value");
                  }
                });
              }),

          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(
                color: _darkOrLightStatus==1 ? hint_color:Colors.white,

                width: 1),
          ),

          labelStyle: const TextStyle(
            color:intello_hint_color,
          ),
          hintText: "Search course you like",
          hintStyle: const TextStyle(
            color:intello_hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),
        ),
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
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "What would you like to learn?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildTextFieldSearch(),

                  SizedBox(height: 50,),

                  Image.asset(
                    "assets/images/no_data_found_image.png",
                    fit: BoxFit.fill,
                    height: 200,
                    width: 272,
                  ),

                  SizedBox(height: 50,),

                  Text(
                    "Opss...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _darkOrLightStatus==1?intello_bold_text_color
                        :Colors.white,
                        fontSize: 25,
                        height: 1.5,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "It looks like what you're searching for is currently not available on our platform!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _darkOrLightStatus==1?intello_text_color
                            :Colors.white,
                        //color: Colors.intello_text_color,
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500),
                  ),

                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            )));
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


}
