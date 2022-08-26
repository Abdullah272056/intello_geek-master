
import 'dart:io';
import 'package:flag/flag_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/api_service/api_service.dart';
import 'package:intello_geek/common_file/toast.dart';
import 'package:intello_geek/registration/password_set.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Colors/colors.dart';
import 'api_service/sharePreferenceDataSaveName.dart';

class ContactWithTeacherScreen extends StatefulWidget {
  const ContactWithTeacherScreen({Key? key}) : super(key: key);

  @override
  State<ContactWithTeacherScreen> createState() => _ContactWithTeacherScreenState();
}

class _ContactWithTeacherScreenState extends State<ContactWithTeacherScreen> {


  TextEditingController? _emailController = TextEditingController();
  TextEditingController? _userMessage = TextEditingController();
  TextEditingController? _userPhoneNumberController = TextEditingController();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _surNameController = TextEditingController();
  String _countryName="Select your country";
  //String _countryCode="IT";
  FlagsCode _countryCode=FlagsCode.IT;
  String select_your_country="Select your country";
  bool _isObscure = true;
  bool _isObscure3 = true;

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    loadUserIdFromSharePref();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ? intello_bg_color:
          intello_bg_color_for_darkMode,
        ),
          child:Flex(

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
                            "Contact",
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
             // SizedBox(height: 30,),
              Expanded(child: _buildBottomDesign(),
                flex: 3,),

            ],
          ) ,

         /* add child content here */
      ),
    );
  }

  Widget _buildBottomDesign() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark
          ,
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

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Name",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  userInputName(_userNameController!, 'Name', TextInputType.text,"assets/images/icon_user.png"),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Surname",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputName(_surNameController!, 'Surname', TextInputType.text,"assets/images/icon_user.png"),


                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 // userInputName(_emailController!, 'Email', TextInputType.emailAddress,Icons.email),
                  userInputEmail(_emailController!, 'Email', TextInputType.emailAddress),

                  //password input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Phone Number",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputPhoneNumber(_userPhoneNumberController!, 'Phone number', TextInputType.phone,"assets/images/icon_country.png"),
                  //password input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Message",
                        style: TextStyle(
                            color:intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputMessage(_userMessage!, 'Enter your message', TextInputType.text,"assets/images/icon_country.png"),

                  SizedBox(
                    height: 30,
                  ),
                  _buildSubmitButton(),
                  SizedBox(height: 20,)
                ],
              ),
            )));
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: () {
          String nameTxt = _userNameController!.text;
          String surnameTxt = _surNameController!.text;
          String emailTxt = _emailController!.text;
          String phoneNumberTxt = _userPhoneNumberController!.text;
          String messageTxt =_userMessage!.text;
          if (_inputValidation(name: nameTxt,surname: surnameTxt,
              email: emailTxt,phoneNumber: phoneNumberTxt,message: messageTxt) == false) {
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>PasswordSetScreen()));

          }


        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7))),
        child: Ink(
          decoration: BoxDecoration(
              gradient:_darkOrLightStatus == 1 ? LinearGradient(colors: [
                intello_button_color_green,
                intello_button_color_green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ) :
              LinearGradient(colors: [
                intello_bg_color,
                intello_bg_color],
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

  Widget userInputName(TextEditingController _controller, String hintTitle,TextInputType keyboardType, String icon_link ) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:
          ig_inputBoxBackGroundColor_for_dark,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark ,
          style: TextStyle(
              color:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
           // suffixIcon: Icon(icons,color: Colors.hint_color,),

            suffixIconConstraints: BoxConstraints(
              minHeight: 8,
              minWidth: 8,
            ),
            suffixIcon: Image(
              image: AssetImage(
                icon_link,

              ),
              height: 17,
              width: 17,
              color: _darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark,
              fit: BoxFit.fill,
            ),

            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 17, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputEmail(TextEditingController _controller, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color:_darkOrLightStatus==1?ig_inputBoxBackGroundColor:
          ig_inputBoxBackGroundColor_for_dark,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark ,
          style: TextStyle(
              color:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark
          ),
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
              color: _darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark,
            ),


            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 17, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputPhoneNumber(TextEditingController _controller, String hintTitle, TextInputType keyboardType,String icon_link) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color:_darkOrLightStatus==1?ig_inputBoxBackGroundColor:
          ig_inputBoxBackGroundColor_for_dark,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          controller: _controller,
          onChanged: (text) {
            Fluttertoast.cancel();
            showToast(text);
            //print('First text field: $text');
          },
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark ,
          style: TextStyle(
              color:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark
          ),
          autofocus: false,

          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 15,
              minWidth: 15,
            ),
            suffixIcon: Image(
              image: AssetImage(
                icon_link,
              ),
              height: 18,
              width: 22,
              fit: BoxFit.fill,
             // color: _darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark,
            ),


            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 17, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputMessage(TextEditingController _controller, String hintTitle, TextInputType keyboardType,String icon_link) {
    return  Container(

      decoration: BoxDecoration(
      color:_darkOrLightStatus==1?ig_inputBoxBackGroundColor:
          ig_inputBoxBackGroundColor_for_dark,
          borderRadius: BorderRadius.circular(10)),
      child:  Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          minLines: 6,
          maxLines: 30,
          keyboardType: TextInputType.multiline,
          controller: _controller,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark ,
          style: TextStyle(
              color:_darkOrLightStatus==1?intello_input_text_color:intello_input_text_color_for_dark
          ),
          autofocus: false,

          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 17, color:hint_color, fontStyle: FontStyle.normal),
          ),

        )

      ),
    );
  }

  _inputValidation({required String name, required String surname,required String email, required String phoneNumber,required String message} ) {
    if (name.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("name can't empty");
      return;
    }

    if (surname.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("surname can't empty");
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("email can't empty");
      return;
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+"
      //  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    )
        .hasMatch(email)) {
      validation_showToast("Enter valid email");
      return;
    }

    if (phoneNumber.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("phoneNumber can't empty");
      return;
    }

    if (message.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("message can't empty");
      return;
    }


    return false;
  }

  _getCountryDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context);
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$GET_COUNTRY_LIST'),

          );
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            setState(() {
              showToast("success");
              //_showAlertDialog(context);
              // offerShimmerStatus = false;
              // var data = jsonDecode(response.body.toString());
              // offerDataList = data["results"];
            });
          } else {
            Fluttertoast.cancel();
          }
        } catch (e) {
          Fluttertoast.cancel();

        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      showToast("No Internet Connection!");
    }
  }

  void _showLoadingDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child: Wrap(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 30, bottom: 30),
                  child: Center(
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: intello_bg_color,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Checking...",
                          style: TextStyle(fontSize: 25),
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

  void _showAlertDialog(BuildContext context){
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
                child: Column(
                  children: [
                  Text("Select your country"),
                    Expanded(child:
                    ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context,int index){
                          return ListTile(
                              leading: Icon(Icons.list),
                              trailing: Text("GFG",
                                style: TextStyle(
                                    color: Colors.green,fontSize: 15),),
                              title:Text("List item $index")
                          );
                        }
                    ),
                    )
                  ],
                ),
              )
            ],
            // child: VerificationScreen(),
          ),
        );
      },
    );
  }
  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        _userId = sharedPreferences.getString(pref_user_id)!;
        _accessToken = sharedPreferences.getString(pref_user_access_token)!;
        _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;

      });
    } catch(e) {
      //code
    }

  }

}
