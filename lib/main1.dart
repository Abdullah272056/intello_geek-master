// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// String prettyPrint(Map json) {
//   JsonEncoder encoder = const JsonEncoder.withIndent('  ');
//   String pretty = encoder.convert(json);
//   return pretty;
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Map<String, dynamic>? _userData;
//   AccessToken? _accessToken;
//   bool _checking = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfIsLogged();
//   }
//
//   Future<void> _checkIfIsLogged() async {
//     final accessToken = await FacebookAuth.instance.accessToken;
//     setState(() {
//       _checking = false;
//     });
//     if (accessToken != null) {
//       print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
//       // now you can call to  FacebookAuth.instance.getUserData();
//       final userData = await FacebookAuth.instance.getUserData();
//       // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
//       _accessToken = accessToken;
//       setState(() {
//         _userData = userData;
//       });
//     }
//   }
//
//   void _printCredentials() {
//     print(
//       prettyPrint(_accessToken!.toJson()),
//     );
//   }
//
//   Future<void> _login() async {
//     final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
//
//     // loginBehavior is only supported for Android devices, for ios it will be ignored
//     // final result = await FacebookAuth.instance.login(
//     //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
//     //   loginBehavior: LoginBehavior
//     //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
//     // );
//
//     if (result.status == LoginStatus.success) {
//       _accessToken = result.accessToken;
//       _printCredentials();
//       // get the user data
//       // by default we get the userId, email,name and picture
//       final userData = await FacebookAuth.instance.getUserData();
//       // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
//       _userData = userData;
//     } else {
//       print(result.status);
//       print(result.message);
//     }
//
//     setState(() {
//       _checking = false;
//     });
//   }
//
//
//   Future<void> _logOut() async {
//     await FacebookAuth.instance.logOut();
//     _accessToken = null;
//     _userData = null;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Facebook Auth Example'),
//         ),
//         body: _checking
//             ? const Center(
//           child: CircularProgressIndicator(),
//         )
//             : SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   _userData != null ? prettyPrint(_userData!) : "NO LOGGED",
//                 ),
//                 const SizedBox(height: 20),
//                 _accessToken != null
//                     ? Text(
//                   prettyPrint(_accessToken!.toJson()),
//                 )
//                     : Container(),
//                 const SizedBox(height: 20),
//                 CupertinoButton(
//                   color: Colors.blue,
//                   child: Text(
//                     _userData != null ? "LOGOUT" : "LOGIN",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   onPressed: _userData != null ? _logOut : _login,
//                 ),
//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




















import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intello_geek/registration/log_in.dart';
import 'package:intello_geek/registration/log_in1.dart';
import 'package:intello_geek/registration/password_set.dart';
import 'package:intello_geek/registration/send_otp_page.dart';
import 'package:intello_geek/registration/sign_up.dart';
import 'package:intello_geek/splash_screen/splash_screen1.dart';
import 'package:intello_geek/splash_screen/splash_screen3.dart';
import 'package:intello_geek/teacher_profile_view_page.dart';

import 'Colors/colors.dart';
import 'cart_page/cart_page.dart';
import 'cart_page/check_out.dart';
import 'cart_page/payment_details.dart';
import 'cart_page/payment_details2.dart';
import 'cart_page/profile_page.dart';
import 'cart_page/subscription2.dart';
import 'cart_page/terms_service.dart';
import 'contact_with_teacer_page.dart';
import 'course/course_filter.dart';
import 'course/course_video_play_details_page.dart';
import 'course/course_video_play_previous_page.dart';
import 'course/my_course_details.dart';
import 'course/my_course_page.dart';
import 'course/my_course_page1.dart';
import 'home_page/course_details.dart';
import 'course/course_filter_empty.dart';
import 'home_page/home_page.dart';
import 'home_page/most_visited_course_page.dart';
import 'home_page/navigation_bar_page.dart';
import 'home_page/recently_added_course.dart';
import 'new page/your_applications_screen.dart';
import 'new page/your_applications_screen1.dart';
import 'new page/your_applications_screen2.dart';
import 'new page/your_applications_screen3.dart';
import 'new page/your_applications_screen4.dart';
import 'new page/your_applications_screen5.dart';
import 'new page/your_applications_screen6.dart';
import 'new page/your_applications_screen7.dart';
import 'notification/notification_page.dart';

void main1() {
  runApp( MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,

        // statusBarColor: intello_bg_color,
        // systemNavigationBarColor: intello_bg_color,

        // statusBarColor: Colors.intello_bd_color_dark.withOpacity(0.0),
        //
        // systemNavigationBarColor: Colors.intello_bd_color_dark,
        //

      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      color:intello_bg_color,
      title: 'IntelloGeek',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: intello_bg_color,
          )
      ),
      home: Scaffold(
        body: Stack(
          children: [
            SplashScreen1()

            // NavigationBarScreen(0,HomeScreen(1))
            //MostVisitedCourseSeeMoreScreen()
          ],
        ),
      ),
    );
  }


}