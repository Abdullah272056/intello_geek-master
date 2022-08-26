import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/registration/send_otp_page.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors/colors.dart';
import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../common_file/load_dialog.dart';
import '../common_file/toast.dart';
import '../home_page/home_page.dart';
import '../home_page/navigation_bar_page.dart';
import 'log_in.dart';

class PasswordSetScreen extends StatefulWidget {
   String userId;
   // String surName;
   // String email;
   // String mobile;
   // String countryId;


   PasswordSetScreen({required this.userId}); //  PasswordSetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordSetScreen> createState() => _PasswordSetScreenState(
      this.userId);
}

class _PasswordSetScreenState extends State<PasswordSetScreen> {
  String _userid;
  _PasswordSetScreenState(this._userid,);

  TextEditingController? _passwordController = TextEditingController();
  TextEditingController? _confirmPasswordController = TextEditingController();

  //TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure3 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child:Flex(

          direction: Axis.vertical,
          children: [
            // Container(
            //   margin: const EdgeInsets.only(top: 70.0, bottom: 50.0),
            //   child:  Image.asset(
            //     "assets/images/logo1.png",
            //     width: 195,
            //     height: 140,
            //     fit: BoxFit.fill,
            //   ),
            //
            // ),
            //
            // Expanded(child: _buildBottomDesign()),


            Expanded(
              child: Container(

              width: 200,
              height: 200,
              child:  Image.asset(
                "assets/images/logo1.png",
              ),

            ),
            ),
            _buildBottomDesign()


          ],
        ) ,

        /* add child content here */
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
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
                    height: 30,
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Enter Password",
                        style: TextStyle(
                            color:intello_input_text_color,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  //password input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Password",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputPassword(_passwordController!, 'Password', TextInputType.visiblePassword),
                  //password input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Confirm Password",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputConfirmPassword(_confirmPasswordController!, 'Confirm Password', TextInputType.visiblePassword),

                  SizedBox(
                    height: 30,
                  ),
                  _buildSubmitButton(),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Text("Already have an account?",
                              style: TextStyle(
                                  color:intello_input_text_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)
                          ),
                          InkResponse(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>LogInScreen()));
                            },
                            child: Text(" Sign In",
                                style: TextStyle(
                                    color:intello_bd_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: () {
          String password = _passwordController!.text;
          String confirmPassword = _confirmPasswordController!.text;

          if (password.isEmpty) {
            Fluttertoast.cancel();
            validation_showToast("Password can't empty");
            return;
          }

          if (password.length<8) {
            Fluttertoast.cancel();
            validation_showToast("Password must be 8 character");
            return;
          }

          if (confirmPassword.isEmpty) {
            Fluttertoast.cancel();
            validation_showToast("Confirm password can't empty");
            return;
          }
          // if (confirmPassword.length<8) {
          //   Fluttertoast.cancel();
          //   validation_showToast("Confirm password must be 8 character");
          //   return;
          // }

          if (password!=confirmPassword) {
            Fluttertoast.cancel();
            validation_showToast("Confirm password do not match");
            return;
          }

          setState(() {
            _userNewPasswordSet(
              userId: _userid,newPassword: password,confirmPassword: confirmPassword
              );
            });

        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [intello_button_color_green, intello_button_color_green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(7.0)
          ),
          child: Container(

            height: 50,
            alignment: Alignment.center,
            child:  Text(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget userInputPassword(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color:ig_inputBoxBackGroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          obscureText: _isObscure,
          enableSuggestions: false,
          autofocus: false,
          cursorColor:intello_input_text_color,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                color:intello_input_text_color,
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                }),
            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 18, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputConfirmPassword(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color:ig_inputBoxBackGroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          obscureText: _isObscure3,
          enableSuggestions: false,
          autofocus: false,
          cursorColor:intello_input_text_color,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                color: intello_input_text_color,
                icon: Icon(_isObscure3 ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure3 = !_isObscure3;
                  });
                }),
            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 18, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  _userNewPasswordSet(
      {
        required String userId,
        required String newPassword,
        required String confirmPassword,

      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Creating...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_FORGET_PASSWORD_NEW_PASSWORD_SET'),
              body: {
                'user_id': userId,
                'new_password': newPassword,
                'confirm_password': confirmPassword,
              });
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            _showToast("success");

            setState(() {
               Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LogInScreen(),
                ),
                    (route) => false,
              );
            });
          }
          else if (response.statusCode == 400) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
          }
          else {
            // var data = jsonDecode(response.body.toString());
            // _showToast(data['message']);
          }
        } catch (e) {
          Navigator.of(context).pop();
          print(e.toString());
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }



  void saveUserInfo(var userInfo) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString(pref_user_id, userInfo['id'].toString());
      sharedPreferences.setString(pref_user_uuid, userInfo['uuid'].toString());
      sharedPreferences.setString(pref_login_status, "1");

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

  void showLoadingDialog(BuildContext context,String message) {
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child: Wrap(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20, bottom: 20),
                  child: Center(
                    child: Row(
                      children:  [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor:intello_bg_color,
                          color: Colors.black,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          message,
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ))
            ],
            // child: VerificationScreen(),
          ),
        );
      },
    );
  }
  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}
