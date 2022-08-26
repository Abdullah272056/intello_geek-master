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

void main() {
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