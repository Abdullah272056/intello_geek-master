
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../course/my_course_details.dart';
import '../home_page/course_details.dart';
import '../home_page/navigation_bar_page.dart';
import 'card input format/input_formatters.dart';



class PaymentDetailsScreen2 extends StatefulWidget {

  int darkOrLightStatus;
  PaymentDetailsScreen2(this.darkOrLightStatus);

  @override
  State<PaymentDetailsScreen2> createState() =>
      _PaymentDetailsScreen2State(this.darkOrLightStatus);

   static void colorStatusChange(){
     // _MyCourseScreenState sss=new _MyCourseScreenState();
     // sss.colorStatus();

   }

}

class _PaymentDetailsScreen2State extends State<PaymentDetailsScreen2> {
  int _darkOrLightStatus;


  _PaymentDetailsScreen2State(this._darkOrLightStatus);



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
  int cartTypeTappedIndex=0;
  TextEditingController? _cardholderNameController = TextEditingController();
  TextEditingController? _emailAddressController = TextEditingController();
  TextEditingController? _cardNumberController = TextEditingController();
  TextEditingController? _cardCVCNumberController = TextEditingController();
  TextEditingController? _cardExpiryDateController = TextEditingController();
  TextEditingController? _zipController = TextEditingController();
  TextEditingController? _stateController = TextEditingController();
  TextEditingController? _couponCodeController = TextEditingController();
  void initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      //_showToast(_userId.toString());
      _getMyCourseCourseDataList();
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
              height: MediaQuery.of(context).size.height / 15,
              // height: 50,
            ),
            Container(
              height: 55,
              child: Flex(
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
                        margin: new EdgeInsets.only(right: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Payment Details",
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
            ),


            SizedBox(
              height: 17,
              // height: 30,
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 00),

            child: Column(
              children: [
                Container(
                  margin:EdgeInsets.only(left: 20,right: 20) ,
                  child:  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Complete your purchase by providing payment details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 10),
                  height: 50,
                  child:  ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        if(index==0){
                          return _buildCardTypeListItem(marginLeft: 20,marginRight: 5,index: index);
                        }
                        else if(index==4){
                          return _buildCardTypeListItem(marginLeft: 5,marginRight: 20,index: index);
                        }
                        else{
                          return _buildCardTypeListItem(marginLeft: 5,marginRight: 5,index: index);
                        }

                      }),
                ),
                Expanded(
                  child:SingleChildScrollView(
                    child: Column(
                      children: [

                        //email
                        userInputField(userInputController: _emailAddressController!, fieldName: "Email Address*",
                          hintTitle: "Email Address", keyboardType:TextInputType.text,),
                        //Cardholder Name
                        userInputField(userInputController: _cardholderNameController!, fieldName: "Cardholder Name*",
                          hintTitle: "Cardholder Name", keyboardType:TextInputType.text,),

                        // Card Number
                        userInputCardNumberField(userInputController: _cardNumberController!,
                          fieldName: "Card Details*",icon_link:_darkOrLightStatus==1?
                          "assets/images/icon_credit_card.png":"assets/images/icon_credit_card_daark.png",
                          hintTitle: "0000 0000 0000 0000", keyboardType:TextInputType.number,),
                        // expire and cvc
                        Row(
                          children: [

                            Expanded(child: userInputCardExpiryDateField(userInputController: _cardExpiryDateController!,
                              fieldName: "Expiry*", hintTitle: "MM/YY", keyboardType:TextInputType.number,),),

                            Expanded(child:    userInputCardCvvField(userInputController: _cardCVCNumberController!,
                              fieldName: "CVC", hintTitle: "000", keyboardType:TextInputType.number,),


                            ),
                          ],
                        ),

                        //billing address
                        userBillingAddressInputField(),

                        userCouponCodeInputField(userInputController: _couponCodeController!, fieldName: "Apply Coupon",
                          hintTitle: "Enter Code", keyboardType:TextInputType.text,),

                        _buildBottomDesign2()

                      ],

                    ),
                  ),
                ),


              ],
            )));
  }

  Widget userInputField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType,required String fieldName}

  ) {
    return Column(
      children: [
      Container(
        margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
        child:Align(

          alignment: Alignment.topLeft,
          child: Text(fieldName,
              style: TextStyle(
                  color: intello_level_color,
                  fontSize: 15,
                  fontWeight: FontWeight.w400)),
        ),
      ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
          color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
            child: TextField(
              controller: userInputController,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              style: TextStyle(
                color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                // suffixIcon: Icon(icons,color: Colors.hint_color,),

                hintText: hintTitle,
                hintStyle: const TextStyle(
                    fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
              ),
              keyboardType: keyboardType,
            ),
          ),
        )

      ],
    );
  }

  Widget userInputCardNumberField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType,
    required String fieldName, required String icon_link,}

      ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
          child:Align(

            alignment: Alignment.topLeft,
            child: Text(fieldName,
                style: TextStyle(
                    color: intello_level_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
            child: TextField(
              controller: userInputController,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              style: TextStyle(
                color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],



              maxLength: 19,
              decoration: InputDecoration(
                border: InputBorder.none,
                // suffixIcon: Icon(icons,color: Colors.hint_color,),
                suffixIconConstraints: BoxConstraints(
                  minHeight: 15,
                  minWidth: 15,
                ),
                suffixIcon: Image(
                  image: AssetImage(
                    icon_link,
                  ),
                  height:_darkOrLightStatus==1?30: 24,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                hintText: hintTitle,
                counterText: "",
                hintStyle: const TextStyle(
                    fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
              ),
              keyboardType: keyboardType,
            ),
          ),
        )

      ],
    );
  }


  Widget userInputCardExpiryDateField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType,required String fieldName}

      ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
          child:Align(

            alignment: Alignment.topLeft,
            child: Text(fieldName,
                style: TextStyle(
                    color: intello_level_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
            child: TextField(
              controller: userInputController,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              style: TextStyle(
                color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                new LengthLimitingTextInputFormatter(4),
                new CardMonthInputFormatter()
              ],


              decoration: InputDecoration(
                border: InputBorder.none,
                // suffixIcon: Icon(icons,color: Colors.hint_color,),

                hintText: hintTitle,
                counterText: "",
                hintStyle: const TextStyle(
                    fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
              ),
              keyboardType: keyboardType,
            ),
          ),
        )

      ],
    );
  }
  Widget userInputCardCvvField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType,required String fieldName}
      ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
          child:Align(

            alignment: Alignment.topLeft,
            child: Text(fieldName,
                style: TextStyle(
                    color: intello_level_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
            child: TextField(
              controller: userInputController,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              maxLength: 3,
              style: TextStyle(
                color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],

              decoration: InputDecoration(
                border: InputBorder.none,
                // suffixIcon: Icon(icons,color: Colors.hint_color,),

                hintText: hintTitle,
                counterText: "",
                hintStyle: const TextStyle(
                    fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
              ),
              keyboardType: keyboardType,
            ),
          ),
        )

      ],
    );
  }

  Widget userInputZipCodeField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType}
      ) {
    return SizedBox(
      height: 55,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: TextField(
          controller: userInputController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          style: TextStyle(
            color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintTitle,
            hintStyle: const TextStyle(

                fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userSateField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType}
      ) {
    return SizedBox(
      height: 55,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
        child: TextField(
          controller: userInputController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          style: TextStyle(
            color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintTitle,
            hintStyle: const TextStyle(

                fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userBillingAddressInputField() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
          child:Align(

            alignment: Alignment.topLeft,
            child: Text("Billing Address",
                style: TextStyle(

                    color: intello_level_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)
              )),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 20),
            child: Flex(direction: Axis.horizontal,
              children: [
                Text("United States",
                    style: TextStyle(
                        color:_darkOrLightStatus==1? intello_input_text_color:Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Expanded(child: Align(alignment: Alignment.centerRight,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(90 / 360),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: intello_level_color,
                      size: 22.0,
                    ),
                    ),



                ) )

              ],

            ),
          ),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
          color: intello_level_color,
        ),
        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
         // alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)
              )),
          child: Flex(direction: Axis.horizontal,
            children: [
              Expanded(child: Align(alignment: Alignment.centerLeft,
                  child: userInputZipCodeField(userInputController: _zipController!,hintTitle: "Zip",keyboardType:TextInputType.text, )
              ) ),

              Container(
                height: 55,
                width: 1,
                margin: const EdgeInsets.only(left: 00, top: 0, right: 00, bottom: 0),
                color: intello_level_color,
              ),

              Expanded(child: Align(alignment: Alignment.centerLeft,
                  child: userSateField(userInputController: _stateController!,hintTitle: "State",keyboardType:TextInputType.text, )
              ) ),

            ],

          ),
        ),

      ],
    );
  }


  Widget _buildCardTypeListItem({required double marginLeft,required double marginRight,required int index}) {
    return InkResponse(
      onTap: (){

        setState(() {  cartTypeTappedIndex=index; });

      },
      child: Container(
        margin: EdgeInsets.only(left: marginLeft, right: marginRight,),
        // padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        height:50,
        width: 70,
        decoration: new BoxDecoration(
           color: _darkOrLightStatus==1?Colors.white:Colors.white,
          // intello_subscription_card_border_color

            border:cartTypeTappedIndex==index?
            Border.all(color: intello_subscription_card_border_color,width: 2):
            Border.all(color: intello_payment_card_type_list_item_border,width: 1)
            ,
            borderRadius: new BorderRadius.all(
              Radius.circular(6),
            )
        ),
        child:  Container(
          margin: const EdgeInsets.all(10),
          child:Image.asset("assets/images/icon_visa.png",
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget userCouponCodeInputField( {required TextEditingController userInputController,
    required String hintTitle, required TextInputType keyboardType,required String fieldName}

      ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23, top: 20, right: 20, bottom: 0),
          child:Align(

            alignment: Alignment.topLeft,
            child: Text(fieldName,
                style: TextStyle(
                    color: intello_level_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ),


        Container(
          height: 55,
          margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 25),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:_darkOrLightStatus==1? ig_inputBoxBackGroundColor:intello_dark_bg_color_for_dark,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 25.0, top: 0, bottom: 0, right: 00),
            child: Flex(direction: Axis.horizontal,
               children: [
                 Expanded(
                   flex: 3,
                   child: TextField(
                   controller: userInputController,
                   textInputAction: TextInputAction.next,
                   autocorrect: false,
                   enableSuggestions: false,
                   autofocus: false,
                     style: TextStyle(
                       color:_darkOrLightStatus==1? intello_bold_text_color_for_dark:Colors.white,
                     ),
                   decoration: InputDecoration(
                     border: InputBorder.none,
                     // suffixIcon: Icon(icons,color: Colors.hint_color,),

                     hintText: hintTitle,
                     hintStyle: const TextStyle(
                         fontSize: 17, color: hint_color, fontStyle: FontStyle.normal),
                   ),
                   keyboardType: keyboardType,
                 ),),
                 Expanded(
                   flex: 3,
                   child: InkResponse(
                     onTap: (){

                     },
                     child: Container(
                       alignment: Alignment.center,
                       margin: EdgeInsets.only(left: 15),
                       height: 55,
                       // width: 140,
                       decoration: BoxDecoration(
                           color: intello_button_color_green,
                           borderRadius: BorderRadius.circular(10)),
                       child: Text('Apply',

                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.w600,
                           fontSize: 15,),

                       ),

                     ),
                   ),)

               ],
            )
          ),
        )

      ],
    );
  }

  Widget _buildBottomDesign2() {
    return Container(
        margin: EdgeInsets.only(top: 30),
       // height: 200,
        width: MediaQuery.of(context).size.width,

        decoration: new BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [BoxShadow(

            color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.35):intello_bg_color_for_darkMode,
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

        child: Padding(
            padding: EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 00),

            child: Column(
              children: [
                Container(

                  height: 5,
                ),
                Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Align(alignment: Alignment.centerLeft,
                      child: Text("Apply Coupon",
                        style: TextStyle(
                            fontSize: 15,color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                            fontWeight:FontWeight.w500
                        ),
                      ),
                    )),
                    Expanded(
                        child: Align(alignment: Alignment.centerRight,
                          child: Text("\$490",
                            style: TextStyle(
                                fontSize: 15,
                                color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                                fontWeight:FontWeight.w500
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  height: 1,
                color: intello_level_color_for_dark_for_dark,
                ),
                Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Align(alignment: Alignment.centerLeft,
                      child: Text("Tax",
                        style: TextStyle(
                            fontSize: 15,
                            color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                            fontWeight:FontWeight.w500
                        ),
                      ),
                    )),
                    Expanded(
                        child: Align(alignment: Alignment.centerRight,
                          child: Text("\$10",
                            style: TextStyle(
                                fontSize: 15,
                                color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                                fontWeight:FontWeight.w500
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  height: 1,
                  color: intello_level_color_for_dark_for_dark,
                ),
                Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Align(alignment: Alignment.centerLeft,
                      child:Flex(
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            'Coupon',
                            style: TextStyle(
                                fontSize: 15,
                                color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                                fontWeight:FontWeight.w500
                            ),
                          ),

                          Text(
                            ' (30% OFF)',
                            style: TextStyle(
                                fontSize: 13,
                                color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                                fontWeight:FontWeight.w300
                            ),
                          ),
                        ],

                      ),

                    )),

                    Expanded(
                        child: Align(alignment: Alignment.centerRight,
                          child: Text("\$-50",
                            style: TextStyle(
                                fontSize: 15,
                                color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                                fontWeight:FontWeight.w500
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  height: 1,
                  color: intello_level_color_for_dark_for_dark,
                ),

                Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child: Align(alignment: Alignment.centerLeft,
                      child: Text("Total",
                        style: TextStyle(
                            fontSize: 15,
                            color:_darkOrLightStatus==1? intello_bold_text_color:Colors.white,
                            fontWeight:FontWeight.w500
                        ),
                      ),
                    )),
                    Expanded(
                        child: Align(alignment: Alignment.centerRight,
                          child: Text("\$450",
                            style: TextStyle(
                                fontSize: 15,
                                color:_darkOrLightStatus==1? intello_bg_color:Colors.white,
                                fontWeight:FontWeight.w500
                            ),
                          ),
                        )
                    ),
                  ],
                ),

                _buildProceedToPayButton(),

              ],
            )));
  }

  Widget _buildProceedToPayButton() {
    return Container(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 20, bottom: 10),
        child:ElevatedButton(
          onPressed: () {
            // Navigator.push(context,MaterialPageRoute(builder: (context)=>SplashScreen4()));
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Ink(
            decoration: BoxDecoration(
                color: _darkOrLightStatus==1? intello_bg_color:intello_bg_color,
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: Align(
                alignment: Alignment.center,
                child:Text(
                  "Proceed to Pay",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PT-Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),);
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

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_id)!;
      _accessToken = sharedPreferences.getString(pref_user_access_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
     // _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
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
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue previousValue,
      TextEditingValue nextValue,
      ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = new StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: new TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}