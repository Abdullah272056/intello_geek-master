import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors/colors.dart';
import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../common_file/load_dialog.dart';
import '../common_file/toast.dart';
import '../home_page/home_page.dart';
import '../home_page/navigation_bar_page.dart';
import 'log_in.dart';

class SendOtpForVerifyScreen extends StatefulWidget {
   String userId;
   // String surName;
   // String email;
   // String mobile;
   // String countryId;


   SendOtpForVerifyScreen({required this.userId}); //  PasswordSetScreen({Key? key}) : super(key: key);

  @override
  State<SendOtpForVerifyScreen> createState() => _SendOtpForVerifyScreenState(this.userId);
}

class _SendOtpForVerifyScreenState extends State<SendOtpForVerifyScreen> {
  String _userId;
  _SendOtpForVerifyScreenState(this._userId);

  TextEditingController? _otpController = TextEditingController();
  String _otpTxt="";


  //TextEditingController? passwordController = TextEditingController();

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
                    child: Text("Enter 6 Digit OTP",
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

                  SizedBox(
                    height: 10,
                  ),
                  _buildTextFieldOTPView(
                    hintText: 'Enter 6 digit Number',
                    obscureText: false,
                    // prefixedIcon: const Icon(Icons.phone, color: Colors.appRed),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  _buildSubmitButton(),
                  SizedBox(
                    height: 20,
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
          String otp = _otpController!.text;

          if (_otpTxt.isEmpty) {
            Fluttertoast.cancel();
            validation_showToast("Otp can't empty");
            return;
          }

          if (_otpTxt.length<6) {
            Fluttertoast.cancel();
            validation_showToast("Otp must be 6 digit");
            return;
          }
         // _showToast(_otpTxt);

          setState(() {
            _userVerify(userId: _userId,otp:_otpTxt );
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



  Widget _buildTextFieldOTPView({
    required bool obscureText,
    String? hintText,
  }) {
    return Container(
      color: Colors.transparent,
      child: OTPTextField(
        length: 6,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.box,
        // contentPadding: EdgeInsets.only(right: 20.0,top: 20,left: 10,bottom: 0),
        fieldWidth:45,

        style: TextStyle(
          fontSize: 18,
          color: intello_search_result_text_color,
        ),
        keyboardType: TextInputType.number,
        onCompleted: (pin) {
         // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddInformationForParticularScreen()));


          _otpTxt = pin;
          // _showToast(pin);
        },
        onChanged: (value) {
          if (value.length < 6) {
            // _otpTxt = "";
          }
        },
      ),
    );
  }

  _userVerify(
      {
        required String otp,
        required String userId,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Creating...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_Email_verify'),
              body: {
                'user_id': userId,
                'code': otp,
              });
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            _showToast("successfully verified");
            var data = jsonDecode(response.body.toString());
            saveUserInfo(data["data"]);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(1)),
              ),
                  (route) => false,
            );

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
