import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../common_file/toast.dart';

class CourseFiltersScreen extends StatefulWidget {
  const CourseFiltersScreen({Key? key}) : super(key: key);
  @override
  State<CourseFiltersScreen> createState() => _CourseFiltersScreenState();
}

class _CourseFiltersScreenState extends State<CourseFiltersScreen>{
  TextEditingController? _courseDetailsController = TextEditingController();
  TextEditingController? _durationController = TextEditingController();
  TextEditingController? _courseByController = TextEditingController();
  TextEditingController? _languageController = TextEditingController();
  TextEditingController? _levelController = TextEditingController();
  TextEditingController? _courseFeaturesController = TextEditingController();
  TextEditingController? _coursePricesController = TextEditingController();
  TextEditingController? _courseTypeController = TextEditingController();
  TextEditingController? _userCountryController = TextEditingController();

  String _courseDetails="Course Details",_courseDuration="Duration",_courseBy="Course by",_language="Language",
      _courseLevel="Level",_courseFeatures="Course Features",_coursePrice="Course Prices",_courseType="Course Type";

  String _courseDetailsSelectedId="",_courseDurationSelectedId="",_courseBySelectedId="",_languageSelectedId="",
      _courseLevelSelectedId="",_courseFeaturesSelectedId="",_coursePriceSelectedId="",_courseTypeSelectedId="";


  String _countryName = "Select your country";
  String _countryNameId = "0";

  //String _countryCode="IT";
  String _countryCode = "IT";
  FlagsCode _countryCodeByPhoneNumber = FlagsCode.IT;
  String select_your_country = "Select your country";
  List _countryList = [];
  bool _intelloGeekChoiceStatus=false;

  int _darkOrLightStatus=1;

  RangeValues _currentRangeValues =RangeValues(0, 80);
  double _maxRangeValue=100;
  bool isChecked = false;
  @protected
  @mustCallSuper
  void initState() {
    loadUserIdFromSharePref();
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

            const SizedBox(
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
                          "Course filters",
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

            const SizedBox(
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

  Widget _buildBottomDesign() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          //  color:_darkOrLightStatus == 1 ? Colors.white:intello_bottom_bg_color_for_dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
            padding:
            const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [


                  //course details input
                  // Container(
                  //   margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                  //   child:  userInput(_courseDetailsController!, 'Enter course details', TextInputType.emailAddress),
                  // ),
                  Container(
                    margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                    child: InkWell(
                      child:userInput(intello_input_text_color,"Enter course details"),
                    )

                  ),

                  // Container(
                  //   margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                  //   child: userInput1(Colors.white,"Course Details"),
                  // ),

                  Row(
                      children: [
                        Expanded(child: Container(
                          margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                          child: InkWell(
                            onTap: (){
                              _showToast("working..");
                            },
                            child:userInput(intello_input_text_color,_courseDuration),
                          )

                        ),),

                        Expanded(child: Container(
                          margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                          child:InkWell(
                            onTap: (){

                            },
                            child:userInput(intello_input_text_color,_courseBy),
                          ),
                        ),),

                      ]
                  ),

                  Container(
                    margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                    child:  userInputCountry(_userCountryController!, 'Country', TextInputType.text,),
                  ),


                  Row(
                      children: [
                        Expanded(child: Container(
                          margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                          child:  InkWell(
                            onTap: (){

                            },
                            child:userInput(intello_input_text_color,_language),
                          ),
                        ),),

                        Expanded(child: Container(
                          margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                          child: InkWell(
                            onTap: (){

                            },
                            child:userInput(intello_input_text_color,_courseLevel),
                          ),
                        ),),



                      ]
                  ),

                  Container(
                    margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                    child: InkWell(
                      onTap: (){

                      },
                      child:userInput(intello_input_text_color,_courseFeatures),
                    ),
                  ),
                  Container(
                    margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                    child:  InkWell(
                      onTap: (){

                      },
                      child:userInput(intello_input_text_color,_coursePrice),
                    ),
                  ),

                  Container(
                    margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 10,bottom: 10),
                    child:  InkWell(
                      onTap: (){

                      },
                      child:userInput(intello_input_text_color,_courseType),
                    ),
                  ),
                  optionCochable(),
                  userInputRange(),

                  intelloGeekChoice(),
                  SizedBox(height: 30,),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: <Widget>[
                      _buildChip("Italian"),
                      _buildChip("With Certificate"),
                      _buildChip("Courses"),
                      _buildChip("Big Data Course"),
                      _buildChip("Courses"),
                      _buildChip("Italian"),

                    ],
                  ),
                  _buildApplyFilterButton(),
                  SizedBox(height: 10,),
                  _buildClearFilterButton(),
                  SizedBox(height: 20,),


                ],
              ),
            )
        ));
  }

  Widget userInput2(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(color:_darkOrLightStatus == 1 ?ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
        child: TextField(
          controller: userInput,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color:intello_bg_color ,
          style:TextStyle(
              fontSize: 20,
              // color: Colors.black,
              color:_darkOrLightStatus==1?intello_input_text_color:Colors.white,
              decoration: TextDecoration.none),
          // cursorColor: intello_input_text_color,
          autofocus: false,

          decoration: InputDecoration(
            border: InputBorder.none,

            // suffixIcon: Icon(Icons.email,color: Colors.hint_color,),

            hintText: hintTitle,
            hintStyle:TextStyle(fontSize: 18, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputCountry(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType ) {
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
        margin: const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
            color:_darkOrLightStatus == 1 ?ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flag.fromString(_countryCode, height: 16, width: 22),
              SizedBox(width: 12,),
              Expanded(
                  child: Text(_countryName,
                      style: TextStyle(
                          color: _darkOrLightStatus==1?intello_input_text_color:Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal))),
              SizedBox(width: 8,),
              Icon(
                Icons.arrow_drop_down,
                color:_darkOrLightStatus == 1 ?intello_input_text_color:Colors.white,
                size: 26.0,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget userInput(Color textColor,String text) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
          color:_darkOrLightStatus == 1 ?ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: Flex(
          direction: Axis.horizontal,
          children: [

            Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: _darkOrLightStatus==1?intello_input_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal))),
            SizedBox(width: 12,),
            Icon(
              Icons.arrow_drop_down,
              color:_darkOrLightStatus == 1 ?intello_input_text_color:Colors.white,
              size: 26.0,
            ),

          ],
        ),
      ),
    );
  }

  Widget userInputRange() {
    return Wrap(
     children: [
       Flex(
         direction: Axis.vertical,
         children: [
           Flex(direction: Axis.horizontal,
             children: [

               Expanded(child: Container(
                 margin:EdgeInsets.only(left: 10),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Free",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),

               )),
               Expanded(child: Container(
                 margin:EdgeInsets.only(right: 10),
                 child:Align(
                   alignment: Alignment.centerRight,
                   child: Text(
                     "Max",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                         fontSize: 12,
                         fontWeight: FontWeight.w400),
                   ),
                 ),

               )),

             ],

           ),
           
           Row(
             children: [
               Expanded(child:  RangeSlider(
                 min: 0,
                 values: _currentRangeValues,
                 max: _maxRangeValue,
                 divisions: _maxRangeValue.toInt(),
                 activeColor: intello_bg_color,
                 inactiveColor: range_inactive_color,
                 labels: RangeLabels(
                   _currentRangeValues.start.round().toString(),

                   _currentRangeValues.end.round().toString(),
                 ),
                 onChanged: (RangeValues values) {
                   setState(() {

                     _currentRangeValues = values;
                     // _maxRangeValue=values.start.round().toDouble();
                   });
                 },
               ))
             ],
           )

          
         ],

       ),
     ],
    );
  }

  Widget intelloGeekChoice() {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin:  EdgeInsets.only(left: 10.0, right: 10.0,top: 20,bottom: 10),
      decoration: BoxDecoration(
          color: _darkOrLightStatus == 1 ?ig_inputBoxBackGroundColor:intello_bg_color_for_darkMode,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: Flex(
          direction: Axis.horizontal,
          children: [

            Expanded(
                child: Text("IntelloGeek Choice",
                    style: TextStyle(
                        color:_darkOrLightStatus==1?intello_text_color:Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal))),
            FlutterSwitch(
            width: 45.0,
            height: 27.0,
            toggleSize: 25.0,
              activeColor:intello_bg_color,

            value: _intelloGeekChoiceStatus,
            borderRadius: 15.0,
            padding: 5.0,
            //showOnOff: true,
            onToggle: (val) {
              setState(() {
                _intelloGeekChoiceStatus = val;
              });
            },
          ),


          ],
        ),
      ),
    );
  }

  Widget optionCochable() {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin:  EdgeInsets.only(left: 0.0, right: 10.0,top: 23,bottom: 20),
      child: Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0, bottom: 0, right: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor:_darkOrLightStatus==1?intello_input_text_color: Colors.white,
              ),
              child: Checkbox(
                checkColor: Colors.white,

                activeColor: intello_bg_color,

                //fillColor: MaterialStateProperty.resolveWith(Colors.black38),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ),

            Expanded(
                child: Text("Option cochable ( Value )",
                    style: TextStyle(
                        color: _darkOrLightStatus==1?intello_text_color:Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal))),



          ],
        ),
      ),
    );
  }

  Widget _buildApplyFilterButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0,top: 40),
      child: ElevatedButton(
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7))),
        child: Ink(
          decoration: BoxDecoration(
            color: _darkOrLightStatus==1?intello_button_color_green:intello_bg_color,

              borderRadius: BorderRadius.circular(7.0)
          ),
          child: Container(

            height: 50,
            alignment: Alignment.center,
            child:  Text(
              "Apply Filter",
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

  Widget _buildClearFilterButton() {
    return InkWell(
      onTap: (){
       // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));

      },
      child: Container(

        height: 50,
        alignment: Alignment.center,
        child:  Text(
          "Clear Filter",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _darkOrLightStatus==1?intello_text_color:Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildChip1(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,

      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  Widget _buildChip(String text) {
    return Container(

      decoration: BoxDecoration(color: _darkOrLightStatus==1?Colors.white:intello_bg_color_for_darkMode
        ,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: range_inactive_color,
          width: 1,
        ),),
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child:  Wrap(
        alignment: WrapAlignment.center,
        children: [
          SizedBox(width: 5,),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color:_darkOrLightStatus==1?hint_color:Colors.white,
            ),
          ),
          SizedBox(width: 10,),
          Icon(
            Icons.cancel,

            color:_darkOrLightStatus==1?hint_color:Colors.white,
            size: 15.0,
          ),
        ],
      ),
    );
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Expanded(child: ListView.builder(

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
                  }),)
            ],
          ),



        );
      },
    );
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
