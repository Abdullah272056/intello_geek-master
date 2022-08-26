import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/api_service/api_service.dart';
import 'package:intello_geek/common_file/toast.dart';
import 'package:intello_geek/registration/password_set.dart';
import 'package:intello_geek/registration/password_set1.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Colors/colors.dart';
import 'log_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? _userCountryController = TextEditingController();
  TextEditingController? _userPhoneNumberController = TextEditingController();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _surNameController = TextEditingController();
  String _countryName = "Select your country";
  String _countryNameId = "0";

  //String _countryCode="IT";
  String _countryCode = "IT";
  FlagsCode _countryCodeByPhoneNumber = FlagsCode.IT;
  String select_your_country = "Select your country";
  bool _isObscure = true;
  bool _isObscure3 = true;

  //var homeSearchResultData;
  List _countryList = [];

  late String userId;
  //late String _phoneNumberTxt;
  String phoneNumberCountryCode="IT";

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
        child: Flex(
          direction: Axis.vertical,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50.0, bottom: 0.0),
              child: Image.asset(
                "assets/images/logo_horizontal.png",
                height: 110,
                width: 280,
                fit: BoxFit.fill,
              ),
            ),

            // SizedBox(height: 30,),
            Expanded(
              child: _buildBottomDesign(),
              flex: 1,
            ),
          ],
        ),

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
                    height: 25,
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Name",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  userInputName(_userNameController!, 'Name',
                      TextInputType.text, "assets/images/icon_user.png"),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Surname",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputName(_surNameController!, 'Surname',
                      TextInputType.text, "assets/images/icon_user.png"),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // userInputName(_emailController!, 'Email', TextInputType.emailAddress,Icons.email),
                  userInputEmail(_emailController!, 'Email', TextInputType.emailAddress),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Country",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputCountry(_userCountryController!, 'Country',
                      TextInputType.text, "assets/images/icon_country.png"),


                  //phone input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Phone Number",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userInputPhoneNumber(
                      _userPhoneNumberController!,
                      'Phone number',
                      TextInputType.phone,
                      "assets/images/icon_country.png"),


                  SizedBox(
                    height: 30,
                  ),
                  _buildSignUpButton(),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Text("Already have an account?",
                              style: TextStyle(
                                  color: intello_input_text_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          InkResponse(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogInScreen()));
                            },
                            child: Text(" Sign In",
                                style: TextStyle(
                                    color: intello_bg_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildSignUpButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: () {
          String nameTxt = _userNameController!.text;
          String surnameTxt = _surNameController!.text;
          String emailTxt = _emailController!.text;
          String phoneNumberTxt = _userPhoneNumberController!.text;
          String countryTxt = _userCountryController!.text;
          if (_inputValidation(
                  name: nameTxt,
                  surname: surnameTxt,
                  email: emailTxt,
                  phoneNumber: phoneNumberTxt,
                  countryNameId: _countryNameId) == false) {
            // showToast("OK");

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PasswordSetScreen1(
                          countryId: _countryNameId,
                          email: emailTxt,
                          mobile: phoneNumberTxt,
                          name: nameTxt,
                          surName: surnameTxt,
                        )));

            // setState(() {
            //   _userRegistration(
            //       name: nameTxt,surName: surnameTxt,email: emailTxt,mobile: phoneNumberTxt,countryId:_countryNameId
            //   );
            // });

            // Navigator.push(context,MaterialPageRoute(builder: (context)=>PasswordSetScreen()));

          }
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  intello_button_color_green,
                  intello_button_color_green
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(7.0)),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              "Sign Up",
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

  Widget userInputName(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType, String icon_link) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: TextField(
          controller: userInput,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
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
              fit: BoxFit.fill,
            ),

            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputEmail(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: TextField(
          controller: userInput,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor: intello_input_text_color,
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
            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputPhoneNumber2(TextEditingController userInput,
      String hintTitle, TextInputType keyboardType, String icon_link) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: IntlPhoneField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'BD',
            onChanged: (phone) {
              print(phone.completeNumber);
            },
          )),
    );
  }

  Widget userInputPhoneNumber(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType, String icon_link) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: TextField(
                  controller: userInput,
                  onChanged: (text) {
                    Fluttertoast.cancel();
                    String text1 = text.replaceAll(new RegExp(r'[^\w\s]+'), '');
                    // showToast(text1);

                    _showCountryCodeByPhoneNumber(text1);
                    // if (text1 == "880") {
                    //   setState(() {
                    //     _countryCodeByPhoneNumber = FlagsCode.BD;
                    //   });
                    // } else if (text1 == "880") {
                    //   setState(() {
                    //     _countryCodeByPhoneNumber = FlagsCode.BD;
                    //   });
                    // } else {
                    //   setState(() {
                    //     // _countryCodeByPhoneNumber=FlagsCode.ZW;
                    //   });
                    // }

                    //print('First text field: $text');
                  },
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  cursorColor: intello_input_text_color,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 15,
                      minWidth: 15,
                    ),
                    // suffixIcon: Image(
                    //   image: AssetImage(
                    //     icon_link,
                    //   ),
                    //   height: 18,
                    //   width: 22,
                    //   fit: BoxFit.fill,
                    // ),

                    hintText: hintTitle,
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        color: hint_color,
                        fontStyle: FontStyle.normal),
                  ),
                  keyboardType: keyboardType,
                ),
              ),
              Flag.fromString(_countryCode, height: 20, width: 20),
            //  Flag.fromString(phoneNumberCountryCode, height: 18, width: 22, fit: BoxFit.fill),
              // Flag.fromCode(_countryCodeByPhoneNumber,
              //     height: 18, width: 22, fit: BoxFit.fill)
            ],
          )),
    );
  }

  Widget userInputCountry(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType, String icon_link) {
    return InkResponse(
      onTap: () {
        setState(() {
          // _countryName="Bangladesh";
          // _countryCode=FlagsCode.BD;
          _getCountryDataList();
        });

        // showToast("Ok");
      },
      child: Container(
        height: 55,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: ig_inputBoxBackGroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              if (_countryName == select_your_country) ...{
                Expanded(
                    child: Text(_countryName,
                        style: TextStyle(
                            color: intello_hint_color,
                            fontSize: 18,
                            fontWeight: FontWeight.normal))),
              } else ...{
                Expanded(
                    child: Text(_countryName,
                        style: TextStyle(
                            color: intello_text_color,
                            fontSize: 18,
                            fontWeight: FontWeight.normal))),
              },
              Flag.fromString(_countryCode, height: 20, width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInputPassword(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          obscureText: _isObscure,
          cursorColor: intello_input_text_color,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                color: hint_color,
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                }),
            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 18, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputConfirmPassword(TextEditingController userInput,
      String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: ig_inputBoxBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          obscureText: _isObscure3,
          enableSuggestions: false,
          cursorColor: intello_input_text_color,
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                color: hint_color,
                icon:
                    Icon(_isObscure3 ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure3 = !_isObscure3;
                  });
                }),
            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 18, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  _inputValidation(
      {required String name,
      required String surname,
      required String email,
      required String phoneNumber,
      required String countryNameId}) {
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
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+"
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

    if (countryNameId.isEmpty || countryNameId == "0") {
      Fluttertoast.cancel();
      validation_showToast("Country name can't empty");
      return;
    }

    return false;
  }

  _getCountryDataList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context, "Loading...");
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$GET_COUNTRY_LIST'),
          );
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            setState(() {
              var data = jsonDecode(response.body);
              _countryList = data["data"];
              _showAlertDialog(context, _countryList);
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

  _showMyDialog() async {
    var result = await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Material Dialog"),
              content: new Text("Hey! I'm Coflutter!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    //  Navigator.pop(context, dataVaribleHere);
                  },
                )
              ],
            ));
    if (result != null) {
      setState(() {
        //Do stuff
      });
    }
  }

  void _showLoadingDialog(BuildContext context, String _message) {
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child: Wrap(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 30, bottom: 30),
                  child: Center(
                    child: Row(
                      children: [
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
                          _message,
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

  void _showAlertDialog(BuildContext context, List _countryListData) {
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child: Container(
            // color: Colors.green,
            margin: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 20, bottom: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 00, bottom: 10),
                  child: Text(
                    "Select your country",
                    style: TextStyle(
                      fontSize: 17,
                      color: intello_bg_color,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _countryList == null ? 0 : _countryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkResponse(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                              _countryName = _countryListData[index]
                                      ['country_name']
                                  .toString();
                              _countryCode = _countryListData[index]
                                      ['country_code_name']
                                  .toString();
                              _countryNameId = _countryListData[index]
                                      ['country_id']
                                  .toString();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flag.fromString(
                                        _countryListData[index]
                                                ['country_code_name']
                                            .toString(),
                                        height: 25,
                                        width: 25),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _countryListData[index]['country_name']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _showCountryCodeByPhoneNumber(String _phoneNumberTxt) {
    if (_phoneNumberTxt == "+88" ||
        _phoneNumberTxt == "88" ||
        _phoneNumberTxt == "880" ||
        _phoneNumberTxt == "8801") {
      setState(() {
        phoneNumberCountryCode = "BD";
      });
    }
    else if (_phoneNumberTxt == "93") {
      setState(() {
        phoneNumberCountryCode = "AF";
      });
    }
    else if (_phoneNumberTxt == "355") {
      setState(() {
        phoneNumberCountryCode = "AL";
      });
    } else if (_phoneNumberTxt == "213") {
      setState(() {
        phoneNumberCountryCode = "DZ";
      });
    } else if (_phoneNumberTxt == "1-684" ||
        _phoneNumberTxt == "1684") {
      setState(() {
        phoneNumberCountryCode = "AS";
      });
    } else if (_phoneNumberTxt == "376") {
      setState(() {
        phoneNumberCountryCode = "AD";
      });
    } else if (_phoneNumberTxt == "244") {
      setState(() {
        phoneNumberCountryCode = "AO";
      });
    } else if (_phoneNumberTxt == "1-264" ||
        _phoneNumberTxt == "1264") {
      setState(() {
        phoneNumberCountryCode = "AG";
      });
    } else if (_phoneNumberTxt == "54") {
      setState(() {
        phoneNumberCountryCode = "AR";
      });
    } else if (_phoneNumberTxt == "374") {
      setState(() {
        phoneNumberCountryCode = "AM";
      });
    } else if (_phoneNumberTxt == "297") {
      setState(() {
        phoneNumberCountryCode = "AW";
      });
    } else if (_phoneNumberTxt == "61") {
      setState(() {
        phoneNumberCountryCode = "AU";
      });
    } else if (_phoneNumberTxt == "43") {
      setState(() {
        phoneNumberCountryCode = "AT";
      });
    } else if (_phoneNumberTxt == "994") {
      setState(() {
        phoneNumberCountryCode = "AZ";
      });
    } else if (_phoneNumberTxt == "1-242" ||
        _phoneNumberTxt == "1242") {
      setState(() {
        phoneNumberCountryCode = "BS";
      });
    } else if (_phoneNumberTxt == "973") {
      setState(() {
        phoneNumberCountryCode = "BH";
      });
    } else if (_phoneNumberTxt == "1-246" ||
        _phoneNumberTxt == "1246") {
      setState(() {
        phoneNumberCountryCode = "BB";
      });
    } else if (_phoneNumberTxt == "375") {
      setState(() {
        phoneNumberCountryCode = "BY";
      });
    } else if (_phoneNumberTxt == "32") {
      setState(() {
        phoneNumberCountryCode = "BE";
      });
    } else if (_phoneNumberTxt == "501") {
      setState(() {
        phoneNumberCountryCode = "BZ";
      });
    } else if (_phoneNumberTxt == "229") {
      setState(() {
        phoneNumberCountryCode = "BJ";
      });
    } else if (_phoneNumberTxt == "1-441" ||
        _phoneNumberTxt == "1441") {
      setState(() {
        phoneNumberCountryCode = "BM";
      });
    } else if (_phoneNumberTxt == "975") {
      setState(() {
        phoneNumberCountryCode = "BT";
      });
    } else if (_phoneNumberTxt == "591") {
      setState(() {
        phoneNumberCountryCode = "BO";
      });
    } else if (_phoneNumberTxt == "387") {
      setState(() {
        phoneNumberCountryCode = "BA";
      });
    } else if (_phoneNumberTxt == "267") {
      setState(() {
        phoneNumberCountryCode = "BW";
      });
    } else if (_phoneNumberTxt == "55") {
      setState(() {
        phoneNumberCountryCode = "BR";
      });
    } else if (_phoneNumberTxt == "246") {
      setState(() {
        phoneNumberCountryCode = "IO";
      });
    } else if (_phoneNumberTxt == "1-284" ||
        _phoneNumberTxt == "1284") {
      setState(() {
        phoneNumberCountryCode = "VG";
      });
    } else if (_phoneNumberTxt == "673") {
      setState(() {
        phoneNumberCountryCode = "BN";
      });
    } else if (_phoneNumberTxt == "359") {
      setState(() {
        phoneNumberCountryCode = "BG";
      });
    } else if (_phoneNumberTxt == "226") {
      setState(() {
        phoneNumberCountryCode = "BF";
      });
    } else if (_phoneNumberTxt == "257") {
      setState(() {
        phoneNumberCountryCode = "BI";
      });
    } else if (_phoneNumberTxt == "855") {
      setState(() {
        phoneNumberCountryCode = "KH";
      });
    } else if (_phoneNumberTxt == "237") {
      setState(() {
        phoneNumberCountryCode = "CM";
      });
    }
    // else if (_phoneNumberTxt == "1") {
    //   setState(() {
    //     phoneNumberCountryCode = "CA";
    //   });
    // }
    else if (_phoneNumberTxt == "238") {
      setState(() {
        phoneNumberCountryCode = "CV";
      });
    } else if (_phoneNumberTxt == "1-345" ||
        _phoneNumberTxt == "1345") {
      setState(() {
        phoneNumberCountryCode = "KY";
      });
    } else if (_phoneNumberTxt == "236") {
      setState(() {
        phoneNumberCountryCode = "CF";
      });
    } else if (_phoneNumberTxt == "235") {
      setState(() {
        phoneNumberCountryCode = "TD";
      });
    } else if (_phoneNumberTxt == "56") {
      setState(() {
        phoneNumberCountryCode = "CL";
      });
    } else if (_phoneNumberTxt == "86") {
      setState(() {
        phoneNumberCountryCode = "CN";
      });
    } else if (_phoneNumberTxt == "61") {
      setState(() {
        phoneNumberCountryCode = "CX";
      });
    } else if (_phoneNumberTxt == "61") {
      setState(() {
        phoneNumberCountryCode = "CC";
      });
    } else if (_phoneNumberTxt == "57") {
      setState(() {
        phoneNumberCountryCode = "CO";
      });
    } else if (_phoneNumberTxt == "269") {
      setState(() {
        phoneNumberCountryCode = "KM";
      });
    } else if (_phoneNumberTxt == "682") {
      setState(() {
        phoneNumberCountryCode = "CK";
      });
    } else if (_phoneNumberTxt == "506") {
      setState(() {
        phoneNumberCountryCode = "CR";
      });
    } else if (_phoneNumberTxt == "385") {
      setState(() {
        phoneNumberCountryCode = "HR";
      });
    } else if (_phoneNumberTxt == "53") {
      setState(() {
        phoneNumberCountryCode = "CU";
      });
    } else if (_phoneNumberTxt == "599") {
      setState(() {
        phoneNumberCountryCode = "CW";
      });
    } else if (_phoneNumberTxt == "357") {
      setState(() {
        phoneNumberCountryCode = "CY";
      });
    } else if (_phoneNumberTxt == "357") {
      setState(() {
        phoneNumberCountryCode = "CY";
      });
    } else if (_phoneNumberTxt == "420") {
      setState(() {
        phoneNumberCountryCode = "CZ";
      });
    } else if (_phoneNumberTxt == "243") {
      setState(() {
        phoneNumberCountryCode = "CD";
      });
    } else if (_phoneNumberTxt == "45") {
      setState(() {
        phoneNumberCountryCode = "DK";
      });
    } else if (_phoneNumberTxt == "253") {
      setState(() {
        phoneNumberCountryCode = "DJ";
      });
    } else if (_phoneNumberTxt == "1-767" ||
        _phoneNumberTxt == "1767") {
      setState(() {
        phoneNumberCountryCode = "DM";
      });
    } else if (_phoneNumberTxt == "1-809" ||
        _phoneNumberTxt == "1809" ||
        _phoneNumberTxt == "1-829" ||
        _phoneNumberTxt == "1829" ||
        _phoneNumberTxt == "1-849" ||
        _phoneNumberTxt == "1849") {
      setState(() {
        phoneNumberCountryCode = "DO";
      });
    } else if (_phoneNumberTxt == "670") {
      setState(() {
        phoneNumberCountryCode = "TL";
      });
    } else if (_phoneNumberTxt == "593") {
      setState(() {
        phoneNumberCountryCode = "EC";
      });
    } else if (_phoneNumberTxt == "20") {
      setState(() {
        phoneNumberCountryCode = "EG";
      });
    } else if (_phoneNumberTxt == "503") {
      setState(() {
        phoneNumberCountryCode = "SV";
      });
    } else if (_phoneNumberTxt == "240") {
      setState(() {
        phoneNumberCountryCode = "GQ";
      });
    } else if (_phoneNumberTxt == "291") {
      setState(() {
        phoneNumberCountryCode = "ER";
      });
    } else if (_phoneNumberTxt == "372") {
      setState(() {
        phoneNumberCountryCode = "EE";
      });
    } else if (_phoneNumberTxt == "251") {
      setState(() {
        phoneNumberCountryCode = "ET";
      });
    } else if (_phoneNumberTxt == "500") {
      setState(() {
        phoneNumberCountryCode = "FK";
      });
    } else if (_phoneNumberTxt == "298") {
      setState(() {
        phoneNumberCountryCode = "FO";
      });
    } else if (_phoneNumberTxt == "679") {
      setState(() {
        phoneNumberCountryCode = "FJ";
      });
    } else if (_phoneNumberTxt == "358") {
      setState(() {
        phoneNumberCountryCode = "FI";
      });
    } else if (_phoneNumberTxt == "33") {
      setState(() {
        phoneNumberCountryCode = "FR";
      });
    } else if (_phoneNumberTxt == "689") {
      setState(() {
        phoneNumberCountryCode = "PF";
      });
    } else if (_phoneNumberTxt == "241") {
      setState(() {
        phoneNumberCountryCode = "GA";
      });
    } else if (_phoneNumberTxt == "220") {
      setState(() {
        phoneNumberCountryCode = "GM";
      });
    } else if (_phoneNumberTxt == "995") {
      setState(() {
        phoneNumberCountryCode = "GE";
      });
    } else if (_phoneNumberTxt == "49") {
      setState(() {
        phoneNumberCountryCode = "DE";
      });
    } else if (_phoneNumberTxt == "233") {
      setState(() {
        phoneNumberCountryCode = "GH";
      });
    } else if (_phoneNumberTxt == "350") {
      setState(() {
        phoneNumberCountryCode = "GI";
      });
    } else if (_phoneNumberTxt == "30") {
      setState(() {
        phoneNumberCountryCode = "GR";
      });
    } else if (_phoneNumberTxt == "299") {
      setState(() {
        phoneNumberCountryCode = "GL";
      });
    } else if (_phoneNumberTxt == "1-473" ||
        _phoneNumberTxt == "1473") {
      setState(() {
        phoneNumberCountryCode = "GD";
      });
    } else if (_phoneNumberTxt == "1-671" ||
        _phoneNumberTxt == "1671") {
      setState(() {
        phoneNumberCountryCode = "GU";
      });
    } else if (_phoneNumberTxt == "502") {
      setState(() {
        phoneNumberCountryCode = "GT";
      });
    } else if (_phoneNumberTxt == "44-1481" ||
        _phoneNumberTxt == "441481") {
      setState(() {
        phoneNumberCountryCode = "GG";
      });
    } else if (_phoneNumberTxt == "224") {
      setState(() {
        phoneNumberCountryCode = "GN";
      });
    } else if (_phoneNumberTxt == "245") {
      setState(() {
        phoneNumberCountryCode = "GW";
      });
    } else if (_phoneNumberTxt == "592") {
      setState(() {
        phoneNumberCountryCode = "GY";
      });
    } else if (_phoneNumberTxt == "509") {
      setState(() {
        phoneNumberCountryCode = "HT";
      });
    } else if (_phoneNumberTxt == "504") {
      setState(() {
        phoneNumberCountryCode = "HN";
      });
    } else if (_phoneNumberTxt == "852") {
      setState(() {
        phoneNumberCountryCode = "HK";
      });
    } else if (_phoneNumberTxt == "36") {
      setState(() {
        phoneNumberCountryCode = "HU";
      });
    } else if (_phoneNumberTxt == "354") {
      setState(() {
        phoneNumberCountryCode = "IS";
      });
    } else if (_phoneNumberTxt == "91") {
      setState(() {
        phoneNumberCountryCode = "IN";
      });
    } else if (_phoneNumberTxt == "62") {
      setState(() {
        phoneNumberCountryCode = "ID";
      });
    } else if (_phoneNumberTxt == "98") {
      setState(() {
        phoneNumberCountryCode = "IR";
      });
    } else if (_phoneNumberTxt == "964") {
      setState(() {
        phoneNumberCountryCode = "IQ";
      });
    } else if (_phoneNumberTxt == "353") {
      setState(() {
        phoneNumberCountryCode = "IE";
      });
    } else if (_phoneNumberTxt == "44-1624" ||
        _phoneNumberTxt == "441624") {
      setState(() {
        phoneNumberCountryCode = "IE";
      });
    } else if (_phoneNumberTxt == "972") {
      setState(() {
        phoneNumberCountryCode = "IL";
      });
    } else if (_phoneNumberTxt == "39") {
      setState(() {
        phoneNumberCountryCode = "IT";
      });
    } else if (_phoneNumberTxt == "225") {
      setState(() {
        phoneNumberCountryCode = "CI";
      });
    } else if (_phoneNumberTxt == "1-876" ||
        _phoneNumberTxt == "1876") {
      setState(() {
        phoneNumberCountryCode = "JM";
      });
    } else if (_phoneNumberTxt == "81") {
      setState(() {
        phoneNumberCountryCode = "JP";
      });
    } else if (_phoneNumberTxt == "44-1534" ||
        _phoneNumberTxt == "441534") {
      setState(() {
        phoneNumberCountryCode = "JE";
      });
    } else if (_phoneNumberTxt == "962") {
      setState(() {
        phoneNumberCountryCode = "JO";
      });
    } else if (_phoneNumberTxt == "7") {
      setState(() {
        phoneNumberCountryCode = "KZ";
      });
    } else if (_phoneNumberTxt == "254") {
      setState(() {
        phoneNumberCountryCode = "KE";
      });
    } else if (_phoneNumberTxt == "686") {
      setState(() {
        phoneNumberCountryCode = "KI";
      });
    } else if (_phoneNumberTxt == "383") {
      setState(() {
        phoneNumberCountryCode = "XK";
      });
    } else if (_phoneNumberTxt == "965") {
      setState(() {
        phoneNumberCountryCode = "KW";
      });
    } else if (_phoneNumberTxt == "996") {
      setState(() {
        phoneNumberCountryCode = "KG";
      });
    } else if (_phoneNumberTxt == "856") {
      setState(() {
        phoneNumberCountryCode = "LA";
      });
    } else if (_phoneNumberTxt == "371") {
      setState(() {
        phoneNumberCountryCode = "LV";
      });
    } else if (_phoneNumberTxt == "961") {
      setState(() {
        phoneNumberCountryCode = "LB";
      });
    } else if (_phoneNumberTxt == "266") {
      setState(() {
        phoneNumberCountryCode = "LS";
      });
    } else if (_phoneNumberTxt == "231") {
      setState(() {
        phoneNumberCountryCode = "LR";
      });
    } else if (_phoneNumberTxt == "218") {
      setState(() {
        phoneNumberCountryCode = "LY";
      });
    } else if (_phoneNumberTxt == "423") {
      setState(() {
        phoneNumberCountryCode = "LI";
      });
    } else if (_phoneNumberTxt == "370") {
      setState(() {
        phoneNumberCountryCode = "LT";
      });
    } else if (_phoneNumberTxt == "352") {
      setState(() {
        phoneNumberCountryCode = "LU";
      });
    } else if (_phoneNumberTxt == "853") {
      setState(() {
        phoneNumberCountryCode = "MO";
      });
    } else if (_phoneNumberTxt == "389") {
      setState(() {
        phoneNumberCountryCode = "MK";
      });
    } else if (_phoneNumberTxt == "261") {
      setState(() {
        phoneNumberCountryCode = "MG";
      });
    } else if (_phoneNumberTxt == "265") {
      setState(() {
        phoneNumberCountryCode = "MW";
      });
    } else if (_phoneNumberTxt == "60") {
      setState(() {
        phoneNumberCountryCode = "MY";
      });
    } else if (_phoneNumberTxt == "960") {
      setState(() {
        phoneNumberCountryCode = "MV";
      });
    } else if (_phoneNumberTxt == "223") {
      setState(() {
        phoneNumberCountryCode = "ML";
      });
    } else if (_phoneNumberTxt == "356") {
      setState(() {
        phoneNumberCountryCode = "MT";
      });
    } else if (_phoneNumberTxt == "692") {
      setState(() {
        phoneNumberCountryCode = "MH";
      });
    } else if (_phoneNumberTxt == "222") {
      setState(() {
        phoneNumberCountryCode = "MR";
      });
    } else if (_phoneNumberTxt == "230") {
      setState(() {
        phoneNumberCountryCode = "MU";
      });
    } else if (_phoneNumberTxt == "262") {
      setState(() {
        phoneNumberCountryCode = "YT";
      });
    } else if (_phoneNumberTxt == "52") {
      setState(() {
        phoneNumberCountryCode = "MX";
      });
    } else if (_phoneNumberTxt == "691") {
      setState(() {
        phoneNumberCountryCode = "FM";
      });
    } else if (_phoneNumberTxt == "373") {
      setState(() {
        phoneNumberCountryCode = "MD";
      });
    } else if (_phoneNumberTxt == "377") {
      setState(() {
        phoneNumberCountryCode = "MC";
      });
    } else if (_phoneNumberTxt == "976") {
      setState(() {
        phoneNumberCountryCode = "MN";
      });
    } else if (_phoneNumberTxt == "382") {
      setState(() {
        phoneNumberCountryCode = "ME";
      });
    } else if (_phoneNumberTxt == "1-664" ||
        _phoneNumberTxt == "1664") {
      setState(() {
        phoneNumberCountryCode = "MS";
      });
    } else if (_phoneNumberTxt == "212") {
      setState(() {
        phoneNumberCountryCode = "MA";
      });
    } else if (_phoneNumberTxt == "258") {
      setState(() {
        phoneNumberCountryCode = "MZ";
      });
    } else if (_phoneNumberTxt == "95") {
      setState(() {
        phoneNumberCountryCode = "MM";
      });
    } else if (_phoneNumberTxt == "264") {
      setState(() {
        phoneNumberCountryCode = "NA";
      });
    } else if (_phoneNumberTxt == "674") {
      setState(() {
        phoneNumberCountryCode = "NR";
      });
    } else if (_phoneNumberTxt == "977") {
      setState(() {
        phoneNumberCountryCode = "NP";
      });
    } else if (_phoneNumberTxt == "31") {
      setState(() {
        phoneNumberCountryCode = "NL";
      });
    } else if (_phoneNumberTxt == "599") {
      setState(() {
        phoneNumberCountryCode = "AN";
      });
    } else if (_phoneNumberTxt == "687") {
      setState(() {
        phoneNumberCountryCode = "NC";
      });
    } else if (_phoneNumberTxt == "64") {
      setState(() {
        phoneNumberCountryCode = "NZ";
      });
    } else if (_phoneNumberTxt == "505") {
      setState(() {
        phoneNumberCountryCode = "NI";
      });
    } else if (_phoneNumberTxt == "227") {
      setState(() {
        phoneNumberCountryCode = "NE";
      });
    } else if (_phoneNumberTxt == "234") {
      setState(() {
        phoneNumberCountryCode = "NG";
      });
    } else if (_phoneNumberTxt == "683") {
      setState(() {
        phoneNumberCountryCode = "NU";
      });
    } else if (_phoneNumberTxt == "850") {
      setState(() {
        phoneNumberCountryCode = "KP";
      });
    } else if (_phoneNumberTxt == "1-670" ||
        _phoneNumberTxt == "1670") {
      setState(() {
        phoneNumberCountryCode = "MP";
      });
    } else if (_phoneNumberTxt == "47") {
      setState(() {
        phoneNumberCountryCode = "NO";
      });
    } else if (_phoneNumberTxt == "968") {
      setState(() {
        phoneNumberCountryCode = "OM";
      });
    } else if (_phoneNumberTxt == "92") {
      setState(() {
        phoneNumberCountryCode = "PK";
      });
    } else if (_phoneNumberTxt == "680") {
      setState(() {
        phoneNumberCountryCode = "PW";
      });
    } else if (_phoneNumberTxt == "970") {
      setState(() {
        phoneNumberCountryCode = "PS";
      });
    } else if (_phoneNumberTxt == "507") {
      setState(() {
        phoneNumberCountryCode = "PA";
      });
    } else if (_phoneNumberTxt == "675") {
      setState(() {
        phoneNumberCountryCode = "PG";
      });
    } else if (_phoneNumberTxt == "595") {
      setState(() {
        phoneNumberCountryCode = "PY";
      });
    } else if (_phoneNumberTxt == "51") {
      setState(() {
        phoneNumberCountryCode = "PE";
      });
    } else if (_phoneNumberTxt == "63") {
      setState(() {
        phoneNumberCountryCode = "PH";
      });
    } else if (_phoneNumberTxt == "64") {
      setState(() {
        phoneNumberCountryCode = "PN";
      });
    } else if (_phoneNumberTxt == "48") {
      setState(() {
        phoneNumberCountryCode = "PL";
      });
    } else if (_phoneNumberTxt == "351") {
      setState(() {
        phoneNumberCountryCode = "PT";
      });
    } else if (_phoneNumberTxt == "1-787" ||
        _phoneNumberTxt == "1787" ||
        _phoneNumberTxt == "1-939" ||
        _phoneNumberTxt == "1939") {
      setState(() {
        phoneNumberCountryCode = "PR";
      });
    } else if (_phoneNumberTxt == "974") {
      setState(() {
        phoneNumberCountryCode = "QA";
      });
    } else if (_phoneNumberTxt == "242") {
      setState(() {
        phoneNumberCountryCode = "CG";
      });
    } else if (_phoneNumberTxt == "262") {
      setState(() {
        phoneNumberCountryCode = "RE";
      });
    } else if (_phoneNumberTxt == "40") {
      setState(() {
        phoneNumberCountryCode = "RO";
      });
    } else if (_phoneNumberTxt == "7") {
      setState(() {
        phoneNumberCountryCode = "RU";
      });
    } else if (_phoneNumberTxt == "250") {
      setState(() {
        phoneNumberCountryCode = "RW";
      });
    } else if (_phoneNumberTxt == "590") {
      setState(() {
        phoneNumberCountryCode = "BL";
      });
    } else if (_phoneNumberTxt == "290") {
      setState(() {
        phoneNumberCountryCode = "SH";
      });
    } else if (_phoneNumberTxt == "1-869" ||
        _phoneNumberTxt == "1869") {
      setState(() {
        phoneNumberCountryCode = "KN";
      });
    } else if (_phoneNumberTxt == "1-758" ||
        _phoneNumberTxt == "1758") {
      setState(() {
        phoneNumberCountryCode = "LC";
      });
    } else if (_phoneNumberTxt == "590") {
      setState(() {
        phoneNumberCountryCode = "MF";
      });
    } else if (_phoneNumberTxt == "590") {
      setState(() {
        phoneNumberCountryCode = "PM";
      });
    } else if (_phoneNumberTxt == "1-784" ||
        _phoneNumberTxt == "1784") {
      setState(() {
        phoneNumberCountryCode = "VC";
      });
    } else if (_phoneNumberTxt == "685") {
      setState(() {
        phoneNumberCountryCode = "WS";
      });
    } else if (_phoneNumberTxt == "378") {
      setState(() {
        phoneNumberCountryCode = "SM";
      });
    } else if (_phoneNumberTxt == "239") {
      setState(() {
        phoneNumberCountryCode = "ST";
      });
    } else if (_phoneNumberTxt == "966") {
      setState(() {
        phoneNumberCountryCode = "SA";
      });
    } else if (_phoneNumberTxt == "221") {
      setState(() {
        phoneNumberCountryCode = "SN";
      });
    } else if (_phoneNumberTxt == "381") {
      setState(() {
        phoneNumberCountryCode = "RS";
      });
    } else if (_phoneNumberTxt == "248") {
      setState(() {
        phoneNumberCountryCode = "SC";
      });
    } else if (_phoneNumberTxt == "232") {
      setState(() {
        phoneNumberCountryCode = "SL";
      });
    } else if (_phoneNumberTxt == "65") {
    setState(() {
    phoneNumberCountryCode = "SG";
    });
    } else if (_phoneNumberTxt == "1-721" ||
    _phoneNumberTxt == "1721") {
    setState(() {
    phoneNumberCountryCode = "SX";
    });
    } else if (_phoneNumberTxt == "421") {
    setState(() {
    phoneNumberCountryCode = "SK";
    });
    } else if (_phoneNumberTxt == "386") {
    setState(() {
    phoneNumberCountryCode = "SI";
    });
    } else if (_phoneNumberTxt == "677") {
    setState(() {
    phoneNumberCountryCode = "SB";
    });
    } else if (_phoneNumberTxt == "252") {
    setState(() {
    phoneNumberCountryCode = "SO";
    });
    } else if (_phoneNumberTxt == "27") {
    setState(() {
    phoneNumberCountryCode = "ZA";
    });
    } else if (_phoneNumberTxt == "82") {
    setState(() {
    phoneNumberCountryCode = "KR";
    });
    } else if (_phoneNumberTxt == "211") {
    setState(() {
    phoneNumberCountryCode = "SS";
    });
    } else if (_phoneNumberTxt == "34") {
    setState(() {
    phoneNumberCountryCode = "ES";
    });
    } else if (_phoneNumberTxt == "94") {
    setState(() {
    phoneNumberCountryCode = "LK";
    });
    } else if (_phoneNumberTxt == "249") {
    setState(() {
    phoneNumberCountryCode = "SD";
    });
    } else if (_phoneNumberTxt == "597") {
    setState(() {
    phoneNumberCountryCode = "SR";
    });
    } else if (_phoneNumberTxt == "47") {
    setState(() {
    phoneNumberCountryCode = "SJ";
    });
    } else if (_phoneNumberTxt == "47") {
    setState(() {
    phoneNumberCountryCode = "SJ";
    });
    } else if (_phoneNumberTxt == "268") {
    setState(() {
    phoneNumberCountryCode = "SZ";
    });
    } else if (_phoneNumberTxt == "46") {
    setState(() {
    phoneNumberCountryCode = "SE";
    });
    } else if (_phoneNumberTxt == "41") {
    setState(() {
    phoneNumberCountryCode = "CH";
    });
    } else if (_phoneNumberTxt == "963") {
    setState(() {
    phoneNumberCountryCode = "SY";
    });
    } else if (_phoneNumberTxt == "886") {
    setState(() {
    phoneNumberCountryCode = "TW";
    });
    } else if (_phoneNumberTxt == "992") {
    setState(() {
    phoneNumberCountryCode = "TJ";
    });
    } else if (_phoneNumberTxt == "255") {
    setState(() {
    phoneNumberCountryCode = "TZ";
    });
    } else if (_phoneNumberTxt == "66") {
    setState(() {
    phoneNumberCountryCode = "TH";
    });
    } else if (_phoneNumberTxt == "228") {
    setState(() {
    phoneNumberCountryCode = "TG";
    });
    } else if (_phoneNumberTxt == "690") {
    setState(() {
    phoneNumberCountryCode = "TK";
    });
    } else if (_phoneNumberTxt == "676") {
    setState(() {
    phoneNumberCountryCode = "TO";
    });
    } else if (_phoneNumberTxt == "1-868" ||
    _phoneNumberTxt == "1868") {
    setState(() {
    phoneNumberCountryCode = "TT";
    });
    } else if (_phoneNumberTxt == "216") {
    setState(() {
    phoneNumberCountryCode = "TN";
    });
    } else if (_phoneNumberTxt == "90") {
    setState(() {
    phoneNumberCountryCode = "TR";
    });
    } else if (_phoneNumberTxt == "993") {
    setState(() {
    phoneNumberCountryCode = "TM";
    });
    } else if (_phoneNumberTxt == "1-649" ||
    _phoneNumberTxt == "1649") {
    setState(() {
    phoneNumberCountryCode = "TC";
    });
    } else if (_phoneNumberTxt == "688") {
    setState(() {
    phoneNumberCountryCode = "TV";
    });
    } else if (_phoneNumberTxt == "1-340" ||
    _phoneNumberTxt == "1340") {
    setState(() {
    phoneNumberCountryCode = "VI";
    });
    } else if (_phoneNumberTxt == "256") {
    setState(() {
    phoneNumberCountryCode = "UG";
    });
    } else if (_phoneNumberTxt == "380") {
    setState(() {
    phoneNumberCountryCode = "UA";
    });
    } else if (_phoneNumberTxt == "971") {
    setState(() {
    phoneNumberCountryCode = "AE";
    });
    } else if (_phoneNumberTxt == "44") {
    setState(() {
    phoneNumberCountryCode = "GB";
    });
    } else if (_phoneNumberTxt == "1") {
    setState(() {
    phoneNumberCountryCode = "US";
    });

    }
    else if (_phoneNumberTxt == "1") {
    setState(() {
    phoneNumberCountryCode = "CA";
    });
    }

    else if (_phoneNumberTxt == "598") {
    setState(() {
    phoneNumberCountryCode = "UY";
    });
    } else if (_phoneNumberTxt == "998") {
    setState(() {
    phoneNumberCountryCode = "UZ";
    });
    } else if (_phoneNumberTxt == "678") {
    setState(() {
    phoneNumberCountryCode = "VU";
    });
    } else if (_phoneNumberTxt == "379") {
    setState(() {
    phoneNumberCountryCode = "VA";
    });
    } else if (_phoneNumberTxt == "58") {
    setState(() {
    phoneNumberCountryCode = "VE";
    });
    } else if (_phoneNumberTxt == "84") {
    setState(() {
    phoneNumberCountryCode = "VN";
    });
    } else if (_phoneNumberTxt == "681") {
    setState(() {
    phoneNumberCountryCode = "WF";
    });
    } else if (_phoneNumberTxt == "212") {
    setState(() {
    phoneNumberCountryCode = "EH";
    });
    } else if (_phoneNumberTxt == "967") {
    setState(() {
    phoneNumberCountryCode = "YE";
    });
    } else if (_phoneNumberTxt == "260") {
    setState(() {
    phoneNumberCountryCode = "ZM";
    });
    } else if (_phoneNumberTxt == "263") {
    setState(() {
    phoneNumberCountryCode = "ZW";
    });
    }
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

  // Widget _buildSignInButton() {
  //   return Container(
  //       margin: const EdgeInsets.only(left: 20.0, right: 20.0),
  //       child: InkWell(
  //         onTap: () {
  //           if (_phoneNumberTxt == "+88" ||
  //               _phoneNumberTxt == "88" ||
  //               _phoneNumberTxt == "880" ||
  //               _phoneNumberTxt == "8801") {
  //             setState(() {
  //               phoneNumberCountryCode = "BD";
  //             });
  //           }
  //           else if (_phoneNumberTxt == "93") {
  //             setState(() {
  //               phoneNumberCountryCode = "AF";
  //             });
  //           }
  //           else if (_phoneNumberTxt == "355") {
  //             setState(() {
  //               phoneNumberCountryCode = "AL";
  //             });
  //           } else if (_phoneNumberTxt == "213") {
  //             setState(() {
  //               phoneNumberCountryCode = "DZ";
  //             });
  //           } else if (_phoneNumberTxt == "1-684" ||
  //               _phoneNumberTxt == "1684") {
  //             setState(() {
  //               phoneNumberCountryCode = "AS";
  //             });
  //           } else if (_phoneNumberTxt == "376") {
  //             setState(() {
  //               phoneNumberCountryCode = "AD";
  //             });
  //           } else if (_phoneNumberTxt == "244") {
  //             setState(() {
  //               phoneNumberCountryCode = "AO";
  //             });
  //           } else if (_phoneNumberTxt == "1-264" ||
  //               _phoneNumberTxt == "1264") {
  //             setState(() {
  //               phoneNumberCountryCode = "AG";
  //             });
  //           } else if (_phoneNumberTxt == "54") {
  //             setState(() {
  //               phoneNumberCountryCode = "AR";
  //             });
  //           } else if (_phoneNumberTxt == "374") {
  //             setState(() {
  //               phoneNumberCountryCode = "AM";
  //             });
  //           } else if (_phoneNumberTxt == "297") {
  //             setState(() {
  //               phoneNumberCountryCode = "AW";
  //             });
  //           } else if (_phoneNumberTxt == "61") {
  //             setState(() {
  //               phoneNumberCountryCode = "AU";
  //             });
  //           } else if (_phoneNumberTxt == "43") {
  //             setState(() {
  //               phoneNumberCountryCode = "AT";
  //             });
  //           } else if (_phoneNumberTxt == "994") {
  //             setState(() {
  //               phoneNumberCountryCode = "AZ";
  //             });
  //           } else if (_phoneNumberTxt == "1-242" ||
  //               _phoneNumberTxt == "1242") {
  //             setState(() {
  //               phoneNumberCountryCode = "BS";
  //             });
  //           } else if (_phoneNumberTxt == "973") {
  //             setState(() {
  //               phoneNumberCountryCode = "BH";
  //             });
  //           } else if (_phoneNumberTxt == "1-246" ||
  //               _phoneNumberTxt == "1246") {
  //             setState(() {
  //               phoneNumberCountryCode = "BB";
  //             });
  //           } else if (_phoneNumberTxt == "375") {
  //             setState(() {
  //               phoneNumberCountryCode = "BY";
  //             });
  //           } else if (_phoneNumberTxt == "32") {
  //             setState(() {
  //               phoneNumberCountryCode = "BE";
  //             });
  //           } else if (_phoneNumberTxt == "501") {
  //             setState(() {
  //               phoneNumberCountryCode = "BZ";
  //             });
  //           } else if (_phoneNumberTxt == "229") {
  //             setState(() {
  //               phoneNumberCountryCode = "BJ";
  //             });
  //           } else if (_phoneNumberTxt == "1-441" ||
  //               _phoneNumberTxt == "1441") {
  //             setState(() {
  //               phoneNumberCountryCode = "BM";
  //             });
  //           } else if (_phoneNumberTxt == "975") {
  //             setState(() {
  //               phoneNumberCountryCode = "BT";
  //             });
  //           } else if (_phoneNumberTxt == "591") {
  //             setState(() {
  //               phoneNumberCountryCode = "BO";
  //             });
  //           } else if (_phoneNumberTxt == "387") {
  //             setState(() {
  //               phoneNumberCountryCode = "BA";
  //             });
  //           } else if (_phoneNumberTxt == "267") {
  //             setState(() {
  //               phoneNumberCountryCode = "BW";
  //             });
  //           } else if (_phoneNumberTxt == "55") {
  //             setState(() {
  //               phoneNumberCountryCode = "BR";
  //             });
  //           } else if (_phoneNumberTxt == "246") {
  //             setState(() {
  //               phoneNumberCountryCode = "IO";
  //             });
  //           } else if (_phoneNumberTxt == "1-284" ||
  //               _phoneNumberTxt == "1284") {
  //             setState(() {
  //               phoneNumberCountryCode = "VG";
  //             });
  //           } else if (_phoneNumberTxt == "673") {
  //             setState(() {
  //               phoneNumberCountryCode = "BN";
  //             });
  //           } else if (_phoneNumberTxt == "359") {
  //             setState(() {
  //               phoneNumberCountryCode = "BG";
  //             });
  //           } else if (_phoneNumberTxt == "226") {
  //             setState(() {
  //               phoneNumberCountryCode = "BF";
  //             });
  //           } else if (_phoneNumberTxt == "257") {
  //             setState(() {
  //               phoneNumberCountryCode = "BI";
  //             });
  //           } else if (_phoneNumberTxt == "855") {
  //             setState(() {
  //               phoneNumberCountryCode = "KH";
  //             });
  //           } else if (_phoneNumberTxt == "237") {
  //             setState(() {
  //               phoneNumberCountryCode = "CM";
  //             });
  //           } else if (_phoneNumberTxt == "1") {
  //             setState(() {
  //               phoneNumberCountryCode = "CA";
  //             });
  //           } else if (_phoneNumberTxt == "238") {
  //             setState(() {
  //               phoneNumberCountryCode = "CV";
  //             });
  //           } else if (_phoneNumberTxt == "1-345" ||
  //               _phoneNumberTxt == "1345") {
  //             setState(() {
  //               phoneNumberCountryCode = "KY";
  //             });
  //           } else if (_phoneNumberTxt == "236") {
  //             setState(() {
  //               phoneNumberCountryCode = "CF";
  //             });
  //           } else if (_phoneNumberTxt == "235") {
  //             setState(() {
  //               phoneNumberCountryCode = "TD";
  //             });
  //           } else if (_phoneNumberTxt == "56") {
  //             setState(() {
  //               phoneNumberCountryCode = "CL";
  //             });
  //           } else if (_phoneNumberTxt == "86") {
  //             setState(() {
  //               phoneNumberCountryCode = "CN";
  //             });
  //           } else if (_phoneNumberTxt == "61") {
  //             setState(() {
  //               phoneNumberCountryCode = "CX";
  //             });
  //           } else if (_phoneNumberTxt == "61") {
  //             setState(() {
  //               phoneNumberCountryCode = "CC";
  //             });
  //           } else if (_phoneNumberTxt == "57") {
  //             setState(() {
  //               phoneNumberCountryCode = "CO";
  //             });
  //           } else if (_phoneNumberTxt == "269") {
  //             setState(() {
  //               phoneNumberCountryCode = "KM";
  //             });
  //           } else if (_phoneNumberTxt == "682") {
  //             setState(() {
  //               phoneNumberCountryCode = "CK";
  //             });
  //           } else if (_phoneNumberTxt == "506") {
  //             setState(() {
  //               phoneNumberCountryCode = "CR";
  //             });
  //           } else if (_phoneNumberTxt == "385") {
  //             setState(() {
  //               phoneNumberCountryCode = "HR";
  //             });
  //           } else if (_phoneNumberTxt == "53") {
  //             setState(() {
  //               phoneNumberCountryCode = "CU";
  //             });
  //           } else if (_phoneNumberTxt == "599") {
  //             setState(() {
  //               phoneNumberCountryCode = "CW";
  //             });
  //           } else if (_phoneNumberTxt == "357") {
  //             setState(() {
  //               phoneNumberCountryCode = "CY";
  //             });
  //           } else if (_phoneNumberTxt == "357") {
  //             setState(() {
  //               phoneNumberCountryCode = "CY";
  //             });
  //           } else if (_phoneNumberTxt == "420") {
  //             setState(() {
  //               phoneNumberCountryCode = "CZ";
  //             });
  //           } else if (_phoneNumberTxt == "243") {
  //             setState(() {
  //               phoneNumberCountryCode = "CD";
  //             });
  //           } else if (_phoneNumberTxt == "45") {
  //             setState(() {
  //               phoneNumberCountryCode = "DK";
  //             });
  //           } else if (_phoneNumberTxt == "253") {
  //             setState(() {
  //               phoneNumberCountryCode = "DJ";
  //             });
  //           } else if (_phoneNumberTxt == "1-767" ||
  //               _phoneNumberTxt == "1767") {
  //             setState(() {
  //               phoneNumberCountryCode = "DM";
  //             });
  //           } else if (_phoneNumberTxt == "1-809" ||
  //               _phoneNumberTxt == "1809" ||
  //               _phoneNumberTxt == "1-829" ||
  //               _phoneNumberTxt == "1829" ||
  //               _phoneNumberTxt == "1-849" ||
  //               _phoneNumberTxt == "1849") {
  //             setState(() {
  //               phoneNumberCountryCode = "DO";
  //             });
  //           } else if (_phoneNumberTxt == "670") {
  //             setState(() {
  //               phoneNumberCountryCode = "TL";
  //             });
  //           } else if (_phoneNumberTxt == "593") {
  //             setState(() {
  //               phoneNumberCountryCode = "EC";
  //             });
  //           } else if (_phoneNumberTxt == "20") {
  //             setState(() {
  //               phoneNumberCountryCode = "EG";
  //             });
  //           } else if (_phoneNumberTxt == "503") {
  //             setState(() {
  //               phoneNumberCountryCode = "SV";
  //             });
  //           } else if (_phoneNumberTxt == "240") {
  //             setState(() {
  //               phoneNumberCountryCode = "GQ";
  //             });
  //           } else if (_phoneNumberTxt == "291") {
  //             setState(() {
  //               phoneNumberCountryCode = "ER";
  //             });
  //           } else if (_phoneNumberTxt == "372") {
  //             setState(() {
  //               phoneNumberCountryCode = "EE";
  //             });
  //           } else if (_phoneNumberTxt == "251") {
  //             setState(() {
  //               phoneNumberCountryCode = "ET";
  //             });
  //           } else if (_phoneNumberTxt == "500") {
  //             setState(() {
  //               phoneNumberCountryCode = "FK";
  //             });
  //           } else if (_phoneNumberTxt == "298") {
  //             setState(() {
  //               phoneNumberCountryCode = "FO";
  //             });
  //           } else if (_phoneNumberTxt == "679") {
  //             setState(() {
  //               phoneNumberCountryCode = "FJ";
  //             });
  //           } else if (_phoneNumberTxt == "358") {
  //             setState(() {
  //               phoneNumberCountryCode = "FI";
  //             });
  //           } else if (_phoneNumberTxt == "33") {
  //             setState(() {
  //               phoneNumberCountryCode = "FR";
  //             });
  //           } else if (_phoneNumberTxt == "689") {
  //             setState(() {
  //               phoneNumberCountryCode = "PF";
  //             });
  //           } else if (_phoneNumberTxt == "241") {
  //             setState(() {
  //               phoneNumberCountryCode = "GA";
  //             });
  //           } else if (_phoneNumberTxt == "220") {
  //             setState(() {
  //               phoneNumberCountryCode = "GM";
  //             });
  //           } else if (_phoneNumberTxt == "995") {
  //             setState(() {
  //               phoneNumberCountryCode = "GE";
  //             });
  //           } else if (_phoneNumberTxt == "49") {
  //             setState(() {
  //               phoneNumberCountryCode = "DE";
  //             });
  //           } else if (_phoneNumberTxt == "233") {
  //             setState(() {
  //               phoneNumberCountryCode = "GH";
  //             });
  //           } else if (_phoneNumberTxt == "350") {
  //             setState(() {
  //               phoneNumberCountryCode = "GI";
  //             });
  //           } else if (_phoneNumberTxt == "30") {
  //             setState(() {
  //               phoneNumberCountryCode = "GR";
  //             });
  //           } else if (_phoneNumberTxt == "299") {
  //             setState(() {
  //               phoneNumberCountryCode = "GL";
  //             });
  //           } else if (_phoneNumberTxt == "1-473" ||
  //               _phoneNumberTxt == "1473") {
  //             setState(() {
  //               phoneNumberCountryCode = "GD";
  //             });
  //           } else if (_phoneNumberTxt == "1-671" ||
  //               _phoneNumberTxt == "1671") {
  //             setState(() {
  //               phoneNumberCountryCode = "GU";
  //             });
  //           } else if (_phoneNumberTxt == "502") {
  //             setState(() {
  //               phoneNumberCountryCode = "GT";
  //             });
  //           } else if (_phoneNumberTxt == "44-1481" ||
  //               _phoneNumberTxt == "441481") {
  //             setState(() {
  //               phoneNumberCountryCode = "GG";
  //             });
  //           } else if (_phoneNumberTxt == "224") {
  //             setState(() {
  //               phoneNumberCountryCode = "GN";
  //             });
  //           } else if (_phoneNumberTxt == "245") {
  //             setState(() {
  //               phoneNumberCountryCode = "GW";
  //             });
  //           } else if (_phoneNumberTxt == "592") {
  //             setState(() {
  //               phoneNumberCountryCode = "GY";
  //             });
  //           } else if (_phoneNumberTxt == "509") {
  //             setState(() {
  //               phoneNumberCountryCode = "HT";
  //             });
  //           } else if (_phoneNumberTxt == "504") {
  //             setState(() {
  //               phoneNumberCountryCode = "HN";
  //             });
  //           } else if (_phoneNumberTxt == "852") {
  //             setState(() {
  //               phoneNumberCountryCode = "HK";
  //             });
  //           } else if (_phoneNumberTxt == "36") {
  //             setState(() {
  //               phoneNumberCountryCode = "HU";
  //             });
  //           } else if (_phoneNumberTxt == "354") {
  //             setState(() {
  //               phoneNumberCountryCode = "IS";
  //             });
  //           } else if (_phoneNumberTxt == "91") {
  //             setState(() {
  //               phoneNumberCountryCode = "IN";
  //             });
  //           } else if (_phoneNumberTxt == "62") {
  //             setState(() {
  //               phoneNumberCountryCode = "ID";
  //             });
  //           } else if (_phoneNumberTxt == "98") {
  //             setState(() {
  //               phoneNumberCountryCode = "IR";
  //             });
  //           } else if (_phoneNumberTxt == "964") {
  //             setState(() {
  //               phoneNumberCountryCode = "IQ";
  //             });
  //           } else if (_phoneNumberTxt == "353") {
  //             setState(() {
  //               phoneNumberCountryCode = "IE";
  //             });
  //           } else if (_phoneNumberTxt == "44-1624" ||
  //               _phoneNumberTxt == "441624") {
  //             setState(() {
  //               phoneNumberCountryCode = "IE";
  //             });
  //           } else if (_phoneNumberTxt == "972") {
  //             setState(() {
  //               phoneNumberCountryCode = "IL";
  //             });
  //           } else if (_phoneNumberTxt == "39") {
  //             setState(() {
  //               phoneNumberCountryCode = "IT";
  //             });
  //           } else if (_phoneNumberTxt == "225") {
  //             setState(() {
  //               phoneNumberCountryCode = "CI";
  //             });
  //           } else if (_phoneNumberTxt == "1-876" ||
  //               _phoneNumberTxt == "1876") {
  //             setState(() {
  //               phoneNumberCountryCode = "JM";
  //             });
  //           } else if (_phoneNumberTxt == "81") {
  //             setState(() {
  //               phoneNumberCountryCode = "JP";
  //             });
  //           } else if (_phoneNumberTxt == "44-1534" ||
  //               _phoneNumberTxt == "441534") {
  //             setState(() {
  //               phoneNumberCountryCode = "JE";
  //             });
  //           } else if (_phoneNumberTxt == "962") {
  //             setState(() {
  //               phoneNumberCountryCode = "JO";
  //             });
  //           } else if (_phoneNumberTxt == "7") {
  //             setState(() {
  //               phoneNumberCountryCode = "KZ";
  //             });
  //           } else if (_phoneNumberTxt == "254") {
  //             setState(() {
  //               phoneNumberCountryCode = "KE";
  //             });
  //           } else if (_phoneNumberTxt == "686") {
  //             setState(() {
  //               phoneNumberCountryCode = "KI";
  //             });
  //           } else if (_phoneNumberTxt == "383") {
  //             setState(() {
  //               phoneNumberCountryCode = "XK";
  //             });
  //           } else if (_phoneNumberTxt == "965") {
  //             setState(() {
  //               phoneNumberCountryCode = "KW";
  //             });
  //           } else if (_phoneNumberTxt == "996") {
  //             setState(() {
  //               phoneNumberCountryCode = "KG";
  //             });
  //           } else if (_phoneNumberTxt == "856") {
  //             setState(() {
  //               phoneNumberCountryCode = "LA";
  //             });
  //           } else if (_phoneNumberTxt == "371") {
  //             setState(() {
  //               phoneNumberCountryCode = "LV";
  //             });
  //           } else if (_phoneNumberTxt == "961") {
  //             setState(() {
  //               phoneNumberCountryCode = "LB";
  //             });
  //           } else if (_phoneNumberTxt == "266") {
  //             setState(() {
  //               phoneNumberCountryCode = "LS";
  //             });
  //           } else if (_phoneNumberTxt == "231") {
  //             setState(() {
  //               phoneNumberCountryCode = "LR";
  //             });
  //           } else if (_phoneNumberTxt == "218") {
  //             setState(() {
  //               phoneNumberCountryCode = "LY";
  //             });
  //           } else if (_phoneNumberTxt == "423") {
  //             setState(() {
  //               phoneNumberCountryCode = "LI";
  //             });
  //           } else if (_phoneNumberTxt == "370") {
  //             setState(() {
  //               phoneNumberCountryCode = "LT";
  //             });
  //           } else if (_phoneNumberTxt == "352") {
  //             setState(() {
  //               phoneNumberCountryCode = "LU";
  //             });
  //           } else if (_phoneNumberTxt == "853") {
  //             setState(() {
  //               phoneNumberCountryCode = "MO";
  //             });
  //           } else if (_phoneNumberTxt == "389") {
  //             setState(() {
  //               phoneNumberCountryCode = "MK";
  //             });
  //           } else if (_phoneNumberTxt == "261") {
  //             setState(() {
  //               phoneNumberCountryCode = "MG";
  //             });
  //           } else if (_phoneNumberTxt == "265") {
  //             setState(() {
  //               phoneNumberCountryCode = "MW";
  //             });
  //           } else if (_phoneNumberTxt == "60") {
  //             setState(() {
  //               phoneNumberCountryCode = "MY";
  //             });
  //           } else if (_phoneNumberTxt == "960") {
  //             setState(() {
  //               phoneNumberCountryCode = "MV";
  //             });
  //           } else if (_phoneNumberTxt == "223") {
  //             setState(() {
  //               phoneNumberCountryCode = "ML";
  //             });
  //           } else if (_phoneNumberTxt == "356") {
  //             setState(() {
  //               phoneNumberCountryCode = "MT";
  //             });
  //           } else if (_phoneNumberTxt == "692") {
  //             setState(() {
  //               phoneNumberCountryCode = "MH";
  //             });
  //           } else if (_phoneNumberTxt == "222") {
  //             setState(() {
  //               phoneNumberCountryCode = "MR";
  //             });
  //           } else if (_phoneNumberTxt == "230") {
  //             setState(() {
  //               phoneNumberCountryCode = "MU";
  //             });
  //           } else if (_phoneNumberTxt == "262") {
  //             setState(() {
  //               phoneNumberCountryCode = "YT";
  //             });
  //           } else if (_phoneNumberTxt == "52") {
  //             setState(() {
  //               phoneNumberCountryCode = "MX";
  //             });
  //           } else if (_phoneNumberTxt == "691") {
  //             setState(() {
  //               phoneNumberCountryCode = "FM";
  //             });
  //           } else if (_phoneNumberTxt == "373") {
  //             setState(() {
  //               phoneNumberCountryCode = "MD";
  //             });
  //           } else if (_phoneNumberTxt == "377") {
  //             setState(() {
  //               phoneNumberCountryCode = "MC";
  //             });
  //           } else if (_phoneNumberTxt == "976") {
  //             setState(() {
  //               phoneNumberCountryCode = "MN";
  //             });
  //           } else if (_phoneNumberTxt == "382") {
  //             setState(() {
  //               phoneNumberCountryCode = "ME";
  //             });
  //           } else if (_phoneNumberTxt == "1-664" ||
  //               _phoneNumberTxt == "1664") {
  //             setState(() {
  //               phoneNumberCountryCode = "MS";
  //             });
  //           } else if (_phoneNumberTxt == "212") {
  //             setState(() {
  //               phoneNumberCountryCode = "MA";
  //             });
  //           } else if (_phoneNumberTxt == "258") {
  //             setState(() {
  //               phoneNumberCountryCode = "MZ";
  //             });
  //           } else if (_phoneNumberTxt == "95") {
  //             setState(() {
  //               phoneNumberCountryCode = "MM";
  //             });
  //           } else if (_phoneNumberTxt == "264") {
  //             setState(() {
  //               phoneNumberCountryCode = "NA";
  //             });
  //           } else if (_phoneNumberTxt == "674") {
  //             setState(() {
  //               phoneNumberCountryCode = "NR";
  //             });
  //           } else if (_phoneNumberTxt == "977") {
  //             setState(() {
  //               phoneNumberCountryCode = "NP";
  //             });
  //           } else if (_phoneNumberTxt == "31") {
  //             setState(() {
  //               phoneNumberCountryCode = "NL";
  //             });
  //           } else if (_phoneNumberTxt == "599") {
  //             setState(() {
  //               phoneNumberCountryCode = "AN";
  //             });
  //           } else if (_phoneNumberTxt == "687") {
  //             setState(() {
  //               phoneNumberCountryCode = "NC";
  //             });
  //           } else if (_phoneNumberTxt == "64") {
  //             setState(() {
  //               phoneNumberCountryCode = "NZ";
  //             });
  //           } else if (_phoneNumberTxt == "505") {
  //             setState(() {
  //               phoneNumberCountryCode = "NI";
  //             });
  //           } else if (_phoneNumberTxt == "227") {
  //             setState(() {
  //               phoneNumberCountryCode = "NE";
  //             });
  //           } else if (_phoneNumberTxt == "234") {
  //             setState(() {
  //               phoneNumberCountryCode = "NG";
  //             });
  //           } else if (_phoneNumberTxt == "683") {
  //             setState(() {
  //               phoneNumberCountryCode = "NU";
  //             });
  //           } else if (_phoneNumberTxt == "850") {
  //             setState(() {
  //               phoneNumberCountryCode = "KP";
  //             });
  //           } else if (_phoneNumberTxt == "1-670" ||
  //               _phoneNumberTxt == "1670") {
  //             setState(() {
  //               phoneNumberCountryCode = "MP";
  //             });
  //           } else if (_phoneNumberTxt == "47") {
  //             setState(() {
  //               phoneNumberCountryCode = "NO";
  //             });
  //           } else if (_phoneNumberTxt == "968") {
  //             setState(() {
  //               phoneNumberCountryCode = "OM";
  //             });
  //           } else if (_phoneNumberTxt == "92") {
  //             setState(() {
  //               phoneNumberCountryCode = "PK";
  //             });
  //           } else if (_phoneNumberTxt == "680") {
  //             setState(() {
  //               phoneNumberCountryCode = "PW";
  //             });
  //           } else if (_phoneNumberTxt == "970") {
  //             setState(() {
  //               phoneNumberCountryCode = "PS";
  //             });
  //           } else if (_phoneNumberTxt == "507") {
  //             setState(() {
  //               phoneNumberCountryCode = "PA";
  //             });
  //           } else if (_phoneNumberTxt == "675") {
  //             setState(() {
  //               phoneNumberCountryCode = "PG";
  //             });
  //           } else if (_phoneNumberTxt == "595") {
  //             setState(() {
  //               phoneNumberCountryCode = "PY";
  //             });
  //           } else if (_phoneNumberTxt == "51") {
  //             setState(() {
  //               phoneNumberCountryCode = "PE";
  //             });
  //           } else if (_phoneNumberTxt == "63") {
  //             setState(() {
  //               phoneNumberCountryCode = "PH";
  //             });
  //           } else if (_phoneNumberTxt == "64") {
  //             setState(() {
  //               phoneNumberCountryCode = "PN";
  //             });
  //           } else if (_phoneNumberTxt == "48") {
  //             setState(() {
  //               phoneNumberCountryCode = "PL";
  //             });
  //           } else if (_phoneNumberTxt == "351") {
  //             setState(() {
  //               phoneNumberCountryCode = "PT";
  //             });
  //           } else if (_phoneNumberTxt == "1-787" ||
  //               _phoneNumberTxt == "1787" ||
  //               _phoneNumberTxt == "1-939" ||
  //               _phoneNumberTxt == "1939") {
  //             setState(() {
  //               phoneNumberCountryCode = "PR";
  //             });
  //           } else if (_phoneNumberTxt == "974") {
  //             setState(() {
  //               phoneNumberCountryCode = "QA";
  //             });
  //           } else if (_phoneNumberTxt == "242") {
  //             setState(() {
  //               phoneNumberCountryCode = "CG";
  //             });
  //           } else if (_phoneNumberTxt == "262") {
  //             setState(() {
  //               phoneNumberCountryCode = "RE";
  //             });
  //           } else if (_phoneNumberTxt == "40") {
  //             setState(() {
  //               phoneNumberCountryCode = "RO";
  //             });
  //           } else if (_phoneNumberTxt == "7") {
  //             setState(() {
  //               phoneNumberCountryCode = "RU";
  //             });
  //           } else if (_phoneNumberTxt == "250") {
  //             setState(() {
  //               phoneNumberCountryCode = "RW";
  //             });
  //           } else if (_phoneNumberTxt == "590") {
  //             setState(() {
  //               phoneNumberCountryCode = "BL";
  //             });
  //           } else if (_phoneNumberTxt == "290") {
  //             setState(() {
  //               phoneNumberCountryCode = "SH";
  //             });
  //           } else if (_phoneNumberTxt == "1-869" ||
  //               _phoneNumberTxt == "1869") {
  //             setState(() {
  //               phoneNumberCountryCode = "KN";
  //             });
  //           } else if (_phoneNumberTxt == "1-758" ||
  //               _phoneNumberTxt == "1758") {
  //             setState(() {
  //               phoneNumberCountryCode = "LC";
  //             });
  //           } else if (_phoneNumberTxt == "590") {
  //             setState(() {
  //               phoneNumberCountryCode = "MF";
  //             });
  //           } else if (_phoneNumberTxt == "590") {
  //             setState(() {
  //               phoneNumberCountryCode = "PM";
  //             });
  //           } else if (_phoneNumberTxt == "1-784" ||
  //               _phoneNumberTxt == "1784") {
  //             setState(() {
  //               phoneNumberCountryCode = "VC";
  //             });
  //           } else if (_phoneNumberTxt == "685") {
  //             setState(() {
  //               phoneNumberCountryCode = "WS";
  //             });
  //           } else if (_phoneNumberTxt == "378") {
  //             setState(() {
  //               phoneNumberCountryCode = "SM";
  //             });
  //           } else if (_phoneNumberTxt == "239") {
  //             setState(() {
  //               phoneNumberCountryCode = "ST";
  //             });
  //           } else if (_phoneNumberTxt == "966") {
  //             setState(() {
  //               phoneNumberCountryCode = "SA";
  //             });
  //           } else if (_phoneNumberTxt == "221") {
  //             setState(() {
  //               phoneNumberCountryCode = "SN";
  //             });
  //           } else if (_phoneNumberTxt == "381") {
  //             setState(() {
  //               phoneNumberCountryCode = "RS";
  //             });
  //           } else if (_phoneNumberTxt == "248") {
  //             setState(() {
  //               phoneNumberCountryCode = "SC";
  //             });
  //           } else if (_phoneNumberTxt == "232") {
  //             setState(() {
  //               phoneNumberCountryCode = "SL";
  //             });
  //           } else if (_phoneNumberTxt == "65") {
  //             setState(() {
  //               phoneNumberCountryCode = "SG";
  //             });
  //           } else if (_phoneNumberTxt == "1-721" ||
  //               _phoneNumberTxt == "1721") {
  //             setState(() {
  //               phoneNumberCountryCode = "SX";
  //             });
  //           } else if (_phoneNumberTxt == "421") {
  //             setState(() {
  //               phoneNumberCountryCode = "SK";
  //             });
  //           } else if (_phoneNumberTxt == "386") {
  //             setState(() {
  //               phoneNumberCountryCode = "SI";
  //             });
  //           } else if (_phoneNumberTxt == "677") {
  //             setState(() {
  //               phoneNumberCountryCode = "SB";
  //             });
  //           } else if (_phoneNumberTxt == "252") {
  //             setState(() {
  //               phoneNumberCountryCode = "SO";
  //             });
  //           } else if (_phoneNumberTxt == "27") {
  //             setState(() {
  //               phoneNumberCountryCode = "ZA";
  //             });
  //           } else if (_phoneNumberTxt == "82") {
  //             setState(() {
  //               phoneNumberCountryCode = "KR";
  //             });
  //           } else if (_phoneNumberTxt == "211") {
  //             setState(() {
  //               phoneNumberCountryCode = "SS";
  //             });
  //           } else if (_phoneNumberTxt == "34") {
  //             setState(() {
  //               phoneNumberCountryCode = "ES";
  //             });
  //           } else if (_phoneNumberTxt == "94") {
  //             setState(() {
  //               phoneNumberCountryCode = "LK";
  //             });
  //           } else if (_phoneNumberTxt == "249") {
  //             setState(() {
  //               phoneNumberCountryCode = "SD";
  //             });
  //           } else if (_phoneNumberTxt == "597") {
  //             setState(() {
  //               phoneNumberCountryCode = "SR";
  //             });
  //           } else if (_phoneNumberTxt == "47") {
  //             setState(() {
  //               phoneNumberCountryCode = "SJ";
  //             });
  //           } else if (_phoneNumberTxt == "47") {
  //             setState(() {
  //               phoneNumberCountryCode = "SJ";
  //             });
  //           } else if (_phoneNumberTxt == "268") {
  //             setState(() {
  //               phoneNumberCountryCode = "SZ";
  //             });
  //           } else if (_phoneNumberTxt == "46") {
  //             setState(() {
  //               phoneNumberCountryCode = "SE";
  //             });
  //           } else if (_phoneNumberTxt == "41") {
  //             setState(() {
  //               phoneNumberCountryCode = "CH";
  //             });
  //           } else if (_phoneNumberTxt == "963") {
  //             setState(() {
  //               phoneNumberCountryCode = "SY";
  //             });
  //           } else if (_phoneNumberTxt == "886") {
  //             setState(() {
  //               phoneNumberCountryCode = "TW";
  //             });
  //           } else if (_phoneNumberTxt == "992") {
  //             setState(() {
  //               phoneNumberCountryCode = "TJ";
  //             });
  //           } else if (_phoneNumberTxt == "255") {
  //             setState(() {
  //               phoneNumberCountryCode = "TZ";
  //             });
  //           } else if (_phoneNumberTxt == "66") {
  //             setState(() {
  //               phoneNumberCountryCode = "TH";
  //             });
  //           } else if (_phoneNumberTxt == "228") {
  //             setState(() {
  //               phoneNumberCountryCode = "TG";
  //             });
  //           } else if (_phoneNumberTxt == "690") {
  //             setState(() {
  //               phoneNumberCountryCode = "TK";
  //             });
  //           } else if (_phoneNumberTxt == "676") {
  //             setState(() {
  //               phoneNumberCountryCode = "TO";
  //             });
  //           } else if (_phoneNumberTxt == "1-868" ||
  //               _phoneNumberTxt == "1868") {
  //             setState(() {
  //               phoneNumberCountryCode = "TT";
  //             });
  //           } else if (_phoneNumberTxt == "216") {
  //             setState(() {
  //               phoneNumberCountryCode = "TN";
  //             });
  //           } else if (_phoneNumberTxt == "90") {
  //             setState(() {
  //               phoneNumberCountryCode = "TR";
  //             });
  //           } else if (_phoneNumberTxt == "993") {
  //             setState(() {
  //               phoneNumberCountryCode = "TM";
  //             });
  //           } else if (_phoneNumberTxt == "1-649" ||
  //               _phoneNumberTxt == "1649") {
  //             setState(() {
  //               phoneNumberCountryCode = "TC";
  //             });
  //           } else if (_phoneNumberTxt == "688") {
  //             setState(() {
  //               phoneNumberCountryCode = "TV";
  //             });
  //           } else if (_phoneNumberTxt == "1-340" ||
  //               _phoneNumberTxt == "1340") {
  //             setState(() {
  //               phoneNumberCountryCode = "VI";
  //             });
  //           } else if (_phoneNumberTxt == "256") {
  //             setState(() {
  //               phoneNumberCountryCode = "UG";
  //             });
  //           } else if (_phoneNumberTxt == "380") {
  //             setState(() {
  //               phoneNumberCountryCode = "UA";
  //             });
  //           } else if (_phoneNumberTxt == "971") {
  //             setState(() {
  //               phoneNumberCountryCode = "AE";
  //             });
  //           } else if (_phoneNumberTxt == "44") {
  //             setState(() {
  //               phoneNumberCountryCode = "GB";
  //             });
  //           } else if (_phoneNumberTxt == "1") {
  //             setState(() {
  //               phoneNumberCountryCode = "US";
  //             });
  //           } else if (_phoneNumberTxt == "598") {
  //             setState(() {
  //               phoneNumberCountryCode = "UY";
  //             });
  //           } else if (_phoneNumberTxt == "998") {
  //             setState(() {
  //               phoneNumberCountryCode = "UZ";
  //             });
  //           } else if (_phoneNumberTxt == "678") {
  //             setState(() {
  //               phoneNumberCountryCode = "VU";
  //             });
  //           } else if (_phoneNumberTxt == "379") {
  //             setState(() {
  //               phoneNumberCountryCode = "VA";
  //             });
  //           } else if (_phoneNumberTxt == "58") {
  //             setState(() {
  //               phoneNumberCountryCode = "VE";
  //             });
  //           } else if (_phoneNumberTxt == "84") {
  //             setState(() {
  //               phoneNumberCountryCode = "VN";
  //             });
  //           } else if (_phoneNumberTxt == "681") {
  //             setState(() {
  //               phoneNumberCountryCode = "WF";
  //             });
  //           } else if (_phoneNumberTxt == "212") {
  //             setState(() {
  //               phoneNumberCountryCode = "EH";
  //             });
  //           } else if (_phoneNumberTxt == "967") {
  //             setState(() {
  //               phoneNumberCountryCode = "YE";
  //             });
  //           } else if (_phoneNumberTxt == "260") {
  //             setState(() {
  //               phoneNumberCountryCode = "ZM";
  //             });
  //           } else if (_phoneNumberTxt == "263") {
  //             setState(() {
  //               phoneNumberCountryCode = "ZW";
  //             });
  //           }
  //         },
  //       ));
  // }


}
