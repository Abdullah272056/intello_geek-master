import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intello_geek/Colors/colors.dart';

class RecentlyAddedSeeMoreScreen1 extends StatefulWidget {
  const RecentlyAddedSeeMoreScreen1({Key? key}) : super(key: key);

  @override
  State<RecentlyAddedSeeMoreScreen1> createState() => _RecentlyAddedSeeMoreScreenState1();
}

class _RecentlyAddedSeeMoreScreenState1 extends State<RecentlyAddedSeeMoreScreen1> {
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();


  Color businessAndCompanyTextColor = Colors.white;
  Color financeTextColor = Colors.black;
  Color iAAndBigDataTextColor = Colors.black;
  Color digitalMarketingTextColor = Colors.black;

  Color businessAndCompanyTabColor = intello_bg_color;
  Color financeTabColor = tabColor;
  Color iAAndBigDataTabColor =tabColor;
  Color digitalMarketingTabColor =tabColor;

  int tab_status = 1;

  int list_grid_status=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.intello_bd_color_dark,
      body: Container(
        decoration: BoxDecoration(
          color: intello_bg_color,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/16,
             // height: 50,
            ),

            Flex(
              direction: Axis.horizontal,
              children: [
                Container(
                  margin: new EdgeInsets.only(left: 30),
                  child: InkResponse(
                    onTap: () {},
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
                          "Recently Added Course",
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
              height: MediaQuery.of(context).size.height/30,
             // height: 30,
            ),
            Expanded(
              child: _buildBottomDesignForList(),
            ),
          ],
        ),

        /* add child content here */
      ),
    );
  }

  Widget _buildBottomDesignForList() {
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
            const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
            child: Column(
              children: [
                Expanded(child:  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics:  ClampingScrollPhysics(),

                    itemBuilder: (BuildContext context, int index) {
                      return _buildRecentlyCourseItemForList();
                    }),)

              ],
            )));
  }



  Widget _buildRecentlyCourseItemForList() {
    return Container(
        margin: EdgeInsets.only(right: 0.0,top: 0,bottom: 10,left: 0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child:Center(
            child: Container(
              padding: EdgeInsets.only(right: 5.0,top: 5,bottom: 5,left: 5),

              color: Colors.white,
              child: SizedBox(
                child: Flex(direction: Axis.horizontal,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: Stack(
                              children: <Widget>[
                                FadeInImage.assetNetwork(
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fill,
                                  placeholder: 'assets/images/loading.png',
                                  image: "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
                                  imageErrorBuilder: (context, url, error) =>
                                      Image.asset(
                                        'assets/images/loading.png',
                                        fit: BoxFit.fill,
                                      ),
                                ),

                                Center(
                                  child: Image.asset(
                                    "assets/images/play.png",
                                    height: 60,
                                    width:60,
                                    fit: BoxFit.fill,
                                  ),

                                ),

                                Container(
                                    width: 100,
                                    height: 100,

                                    alignment: Alignment.topLeft,
                                    child: Container(

                                      width: double.infinity,
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                      child:Column(
                                        children: [
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    color:Colors.white,
                                                    child: FadeInImage.assetNetwork(
                                                      fit: BoxFit.cover,
                                                      placeholder: 'assets/images/empty.png',
                                                      image: "https://www.arenawebsecurity.net/static/media/mainLogo.7e69599a.png",
                                                      imageErrorBuilder: (context, url, error) =>
                                                          Image.asset(
                                                            'assets/images/empty.png',
                                                            fit: BoxFit.fill,
                                                          ),
                                                    )),

                                              ),

                                              SizedBox(width: 5,),

                                              Flexible(
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.only(right: 5.0),
                                                  child: Text(
                                                    "ABC Learning Center",
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),
                                                    softWrap: false,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Container(
                                                //height: 40,
                                                width: 20,
                                              ),
                                              SizedBox(width: 3,),
                                              Flexible(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "45 mins",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500),
                                                      softWrap: false,
                                                      maxLines: 1,
                                                    ),
                                                  ],

                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),

                                    ))
                              ]),
                        )
                    ),

                    SizedBox(width: 5,),
                    Expanded(
                        child:Align(
                          alignment: Alignment.center,
                          child: Flex(direction: Axis.vertical,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tame your big data course",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  maxLines:1,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Learn Online",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  maxLines:1,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Flex(direction: Axis.horizontal,
                                children: const [
                                  Expanded(child: Text(
                                    "72 Participants",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:hint_color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    softWrap: false,
                                    maxLines:1,
                                  )),
                                  Text(
                                    "\$4.99",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: intello_bg_color,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    softWrap: false,
                                    maxLines:1,
                                  )

                                ],
                              ),

                              Row(
                                children:  [

                                  RatingBarIndicator(
                                    rating:4.5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color:intello_bd_color,
                                    ),
                                    itemCount: 5,
                                    itemSize: 17.0,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "(4.5)",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:hint_color,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 2,
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children:  [

                                  Container(

                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkResponse(
                                      onTap: (){},
                                      child:Image.asset('assets/images/icon_level.png',
                                        width: MediaQuery.of(context).size.width/18,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkResponse(
                                      onTap: (){},
                                      child:Image.asset('assets/images/icon_share.png',
                                        width: MediaQuery.of(context).size.width/18,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkResponse(
                                      onTap: (){},
                                      child:Image.asset('assets/images/icon_certificate.png',
                                        width: MediaQuery.of(context).size.width/18,
                                        height: 25,

                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container(

                                    child:  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [

                                        Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          child: InkResponse(
                                            onTap: (){},
                                            child:Image.asset('assets/images/heart.png',
                                              width: MediaQuery.of(context).size.width/18,
                                              height: 25,
                                            ),
                                          ),
                                        ),
                                        Expanded(child:  Align(
                                          alignment: Alignment.centerRight,
                                          child:  Container(
                                            margin: const EdgeInsets.only(right: 0),
                                            child: InkResponse(
                                              onTap: (){},
                                              child:Image.asset('assets/images/btn_enroll.png',
                                                width: MediaQuery.of(context).size.width/6,
                                                height: 25,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ))
                                        ,
                                      ],

                                    ),
                                  ))



                                ],
                              ),
                            ],

                          ),
                        )

                    ),


                  ],
                ),


              ),
            ) ,
          )
      ),
    )

    ;
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
