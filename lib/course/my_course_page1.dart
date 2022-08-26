
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intello_geek/Colors/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class MyCourseScreen1 extends StatefulWidget {
  int _darkOrLightStatus;


  MyCourseScreen1(this._darkOrLightStatus); //const MyCourseScreen({Key? key}) : super(key: key);

  @override
  State<MyCourseScreen1> createState() => _MyCourseScreenState(this._darkOrLightStatus);
}

class _MyCourseScreenState extends State<MyCourseScreen1> {
  int _darkOrLightStatus;
  _MyCourseScreenState(this._darkOrLightStatus);

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? searchController = TextEditingController();

  int tab_status = 1;
  int list_grid_status = 1;
  String list_grid_image_icon_link = "assets/images/icon_list.png";

 // int _darkOrLightStatus=1;


  int searchBoxVisible=0;

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
            if(searchBoxVisible==0)...{
              Container(
                height: 55,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      margin: new EdgeInsets.only(left: 20),
                      child: InkResponse(
                        onTap: () {
                          // Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: new EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "My Courses",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )),


                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: InkWell(

                        onTap: () {
                          setState(() {
                            searchBoxVisible=1;
                          });
                          // if(list_grid_status==1){
                          //   setState(() {
                          //     list_grid_status=2;
                          //     list_grid_image_icon_link = "assets/images/grid.png";
                          //   });
                          //
                          //
                          // }
                          // else {
                          //   setState(() {
                          //     list_grid_status=1;
                          //     list_grid_image_icon_link = "assets/images/icon_list.png";
                          //   });
                          //
                          // }

                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            }
            else...{
              DelayedWidget(

                delayDuration: Duration(milliseconds: 100),// Not required
                animationDuration: Duration(milliseconds: 500),// Not required
                animation: DelayedAnimations.SLIDE_FROM_RIGHT,// Not required
                child: userInputSearchField(_emailController!, 'Search courses', TextInputType.text),
              ),

            },


            SizedBox(
              height: 17,
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

  Widget userInputSearchField(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: new EdgeInsets.only(left: 20,right: 20),
      decoration: BoxDecoration(
          color: _darkOrLightStatus==1?Colors.white:
          intello_bottom_bg_color_for_dark,

          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, top: 0,bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor:_darkOrLightStatus==1?intello_input_text_color: Colors.white,
          style: TextStyle(color:_darkOrLightStatus==1?intello_hint_color: Colors.white,),
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: IconButton(
               // color: Colors.intello_input_text_color,
                icon: Icon(
                  Icons.search,
                  color:_darkOrLightStatus==1?intello_hint_color: Colors.white,

                  //color: Colors.intello_hint_color,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    searchBoxVisible=0;
                  });
                }),

            // suffixIconConstraints: BoxConstraints(
            //   minHeight: 15,
            //   minWidth: 15,
            // ),
            // suffixIcon: Image(
            //   image: AssetImage(
            //     'assets/images/icon_email.png',
            //   ),
            //   height: 18,
            //   width: 22,
            //   fit: BoxFit.fill,
            // ),

            hintText: hintTitle,

            hintStyle:  TextStyle(fontSize: 17,
                color:_darkOrLightStatus==1?intello_hint_color: Colors.white,
               // color: Colors.intello_hint_color,
                fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
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

  Widget _buildBottomDesignForList() {
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
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildMostVisitedCourseItemForList();
                      }),
                )
              ],
            )));
  }

  Widget _buildMostVisitedCourseItemForList() {
    return InkResponse(
      onTap: (){
        // _showToast("ok");
      //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CourseDetailsScreen()));
      },
      child:
      Container(
        margin: EdgeInsets.only(right: 20.0, top: 0, bottom: 20, left: 20),
        //width: 180,
        decoration: new BoxDecoration(
          color:_darkOrLightStatus == 1 ? Colors.white:intello_list_item_color_for_dark,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(

            color: _darkOrLightStatus == 1?Colors.grey.withOpacity(.25):intello_bg_color_for_darkMode,
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
        //   height: 150,
        child:ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              height: 120,
              width: 120,
              child:SlidableAutoCloseBehavior(
                child: Slidable(

                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(0),


                  endActionPane:ActionPane(
                    extentRatio: .45,
                    motion:DrawerMotion(),
                    children: [

                      SlidableAction(
                        autoClose: true,

                        padding: EdgeInsets.only(left: 10,right: 10),
                        onPressed: (BuildContext context) {

                          setState(() {
                            // _showToast("Delete");
                          });

                        },
                        flex: 1,
                        backgroundColor: intello_bg_color,
                        foregroundColor: Colors.white,
                        icon: Icons.archive_outlined,
                        label: 'Archive',
                      ),


                      SlidableAction(
                        autoClose: true,

                        padding: EdgeInsets.only(left: 10,right: 10),
                        onPressed: (BuildContext context) {

                          setState(() {
                            // _showToast(response["notification_id"].toString());
                            //  _deleteNotificationDataList(response["notification_id"].toString());

                          });

                        },
                        flex: 1,
                        backgroundColor: intello_notification_delete_button_color,
                        foregroundColor: Colors.white,
                        icon: Icons.delete_rounded,
                        label: 'Delete',
                      ),
                    ],
                  ),


                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child:InkResponse(
                    onTap: (){

                      //.  Navigator.push(context,MaterialPageRoute(builder: (context)=>MyCourseDetailsScreen(courseId: response["course_id"].toString() ,)));

                    },
                    child:
                    Container(
                      margin: EdgeInsets.only(right: 10.0, top: 10, bottom: 10, left: 10),
                      //color: Colors.white,
                      child: SizedBox(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Stack(children: <Widget>[
                                    FadeInImage.assetNetwork(
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.fill,
                                      placeholder: 'assets/images/loading.png',
                                      image:
                                      "https://technofaq.org/wp-content/uploads/2017/03/image00-21.jpg",
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
                                        width: 60,
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
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 5, bottom: 2),
                                          child: Column(
                                            children: [
                                              Flex(
                                                direction: Axis.horizontal,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        color: Colors.white,
                                                        child: FadeInImage.assetNetwork(
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                          'assets/images/empty.png',
                                                          image:
                                                          "https://www.arenawebsecurity.net/static/media/mainLogo.7e69599a.png",
                                                          imageErrorBuilder:
                                                              (context, url, error) =>
                                                              Image.asset(
                                                                'assets/images/empty.png',
                                                                fit: BoxFit.fill,
                                                              ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
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
                                                            fontWeight:
                                                            FontWeight.w500),
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
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "45 mins",
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.w500),
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
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children:  [
                                            Expanded(
                                              child: Text(
                                                "Tame your big data course",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(

                                                    color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                                    // color: Colors.intello_text_color,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                                softWrap: false,
                                                maxLines: 1,
                                              ),


                                            ),
                                          ],
                                        ),

                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Learn Online",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Flex(
                                        direction: Axis.horizontal,
                                        children: const [
                                          Expanded(
                                              child: Text(
                                                "Mario rossi • Trainer and Speaker",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:intello_hint_color,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400),
                                                softWrap: false,
                                                maxLines: 1,
                                              )),

                                        ],
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
                                                    child:  Text(
                                                      "34 / 98 Module",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:intello_hint_color,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400),
                                                      softWrap: false,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:Flex(direction: Axis.horizontal,
                                                        children: [
                                                          Expanded(child:  LinearPercentIndicator(
                                                            // width: MediaQuery.of(context).size.width/3.9,
                                                            animation: true,
                                                            lineHeight: 10.0,
                                                            animationDuration: 700,
                                                            percent: 0.73,
                                                            linearStrokeCap: LinearStrokeCap.roundAll,
                                                            backgroundColor: _darkOrLightStatus == 1 ? intello_Indicator_bg_color_for_light:intello_Indicator_bg_color_for_dark,
                                                            progressColor: _darkOrLightStatus == 1 ? intello_color_green:intello_bg_color,

                                                          ),),
                                                          Text(
                                                            "73%",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color:_darkOrLightStatus == 1 ? intello_text_color:Colors.white,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                          SizedBox(width: 7,)
                                                        ],
                                                      )
                                                  ),

                                                ],
                                              )),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 10, top: 10, bottom: 0),
                                            child:  ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: InkResponse(
                                                  onTap: (){

                                                    //  _showToast("clicked");


                                                  },
                                                  child: Align(alignment: Alignment.bottomRight,
                                                    child: Container(
                                                      height: 25,
                                                      width: 70,
                                                      color:intello_bg_color,
                                                      child: Align(alignment: Alignment.center,
                                                        child:  Text("Resume Course",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.w400)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
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

                  ),
                ),

              ),
            )),





      ),

    );
  }
}
