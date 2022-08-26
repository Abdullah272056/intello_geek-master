import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:intello_geek/registration/send_otp_page_for_forotten_pass.dart';

import '../api_service/api_service.dart';
import '../common_file/loding_dialog.dart';
import 'log_in.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController? _emailController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure3 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          color: intello_bg_color,
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
          child:Flex(

            direction: Axis.vertical,
            children: [


              Container(
                margin: const EdgeInsets.only(top: 60.0, bottom: 40.0),
                child:  Image.asset(
                  "assets/images/logo1.png",
                  width: 186,
                  height: 133,
                  fit: BoxFit.fill,
                ),

              ),



              Expanded(child: _buildBottomDesign(),
                ),

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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      height: 15,
                    ),
                    Container(

                      width: 80,
                      height: 80,
                      child:  Image.asset(
                        "assets/images/icon_forgot.png",
                      ),

                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:intello_bold_text_color,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Enter your email address associated with your account "
                          "we will send you a link to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: intello_small_text_color_,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Email",
                          style: TextStyle(
                              color:intello_hint_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    userInputEmail(_emailController!, 'Email', TextInputType.emailAddress),
                  //  userInputEmail(_emailController!, 'Email', TextInputType.emailAddress,Icons.email),

                    SizedBox(
                      height: 30,
                    ),

                    _buildSubmitButton(),
                    SizedBox(
                      height: 15,
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
                                    color:intello_text_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)
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
              ),
            )));
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: () {
          String emailTxt = _emailController!.text;

          if (_inputValid(emailTxt) == false) {
           // _userLogIn(email:emailTxt,password: passwordTxt );
            //Navigator.push(context,MaterialPageRoute(builder: (context)=> NavigationBarScreen(0,HomeScreen()),));

            _sendMailForForgottenPassword(email: emailTxt);
          }

         // _inputValid(emailTxt);
         // Navigator.push(context,MaterialPageRoute(builder: (context)=>LogInScreen()));
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [intello_button_color_green,intello_button_color_green],
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
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userInputEmail(TextEditingController userInputController, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color:ig_inputBoxBackGroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          controller: userInputController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:intello_input_text_color,
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(
              minHeight: 15,
              minWidth: 15,
            ),
            suffixIcon: Image(
              image: AssetImage(
                'assets/images/icon_email.png',
              ),
              height: 18,
              width: 22,
              fit: BoxFit.fill,
            ),


            // suffixIcon: Icon(Icons.email,color: Colors.hint_color,),

            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 18, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  _sendMailForForgottenPassword(
      {
        required String email,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Checking...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_FORGET_PASSWORD'),
              body: {
                'email': email,
              });
          Navigator.of(context).pop();
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());
            Navigator.push(context,MaterialPageRoute(builder: (context)=>
                SendOtpForForgottenPasswordVerifyScreen(userId: data['data']["id"].toString()),));

          }
          else {
            var data = jsonDecode(response.body);
            _showToast(data['message']);
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

  _inputValid(String email) {
    if (email.isEmpty) {
      Fluttertoast.cancel();
      _showToast("Email can't empty");
      return;
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+"
      //  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    ).hasMatch(email)) {
      Fluttertoast.cancel();
      _showToast("Enter valid email");
      return;
    }


    return false;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: intello_bg_color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}
