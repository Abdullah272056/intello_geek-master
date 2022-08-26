import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:intello_geek/home_page/home_page.dart';
import 'package:intello_geek/home_page/navigation_bar_page.dart';
import 'package:intello_geek/home_page/search_file.dart';
import 'package:intello_geek/registration/send_otp_page.dart';
import 'package:intello_geek/registration/sign_up.dart';
import 'package:intello_geek/splash_screen/splash_screen4.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors/colors.dart';

import '../api_service/api_service.dart';
import '../api_service/sharePreferenceDataSaveName.dart';
import '../common_file/toast.dart';
import 'forgot_password.dart';
import 'package:http/http.dart' as http;

class LogInScreen extends StatefulWidget {


  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

String prettyPrint(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class _LogInScreenState extends State<LogInScreen> {

  TextEditingController? _emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;
  String _userId = "";
  String _accessToken1 = "";
  String _refreshToken = "";
  String _userUUId = "";
  int _darkOrLightStatus=1;



  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    //  clientId: '1098362159954:android:64a2773b8e7d4533e7b08b.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;
  String _contactText = '';


  //facebook login
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  String _nameFacebook="";
  String _lastNameFacebook="";
  String _phoneFacebook="";
  String _emailFacebook="";

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  //facebook start


  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken!.toJson()),
    );
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      _printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;


      _nameFacebook=_userData!["name"].toString();
      _lastNameFacebook=_userData!["name"].toString();
      _emailFacebook=_userData!["email"].toString();
      _phoneFacebook=_userData!["phone"].toString();

      if(_phoneFacebook.isEmpty && _phoneFacebook !=null){
        _userLogInWithFaceBook(first_name: _nameFacebook, last_name: _lastNameFacebook, email: _phoneFacebook,);
      }else{

        _userLogInWithFaceBook(first_name: _nameFacebook, last_name: _lastNameFacebook, email: _emailFacebook,);
      }



      // var data = jsonDecode(response.body.toString());



    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      _checking = false;
    });
  }


  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  //facebook end




  //google

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';

      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {

        _contactText = 'I see you know $namedContact!';

      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        //  _showToast(name['displayName'].toString());
        return name['displayName'] as String?;
      }
    }
    return null;
  }
  ////////////  data receive
  Future<void> _handleSignIn() async {
    try {
      // _showToast("succ");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // var abc= await _googleSignIn.signIn();
      //  var data = jsonDecode(googleUser.body);
      // _showToast(googleUser.toString());
      log(googleUser.toString());


      //_showToast("1");
      final http.Response response = await http.get(
        Uri.parse('https://people.googleapis.com/v1/people/me/connections'
            '?requestMask.includeField=person.names'),
        headers: await googleUser?.authHeaders,
      );


      if (response.statusCode != 200) {
        setState(() {
          // _showToast("2");
          _contactText =  {response.body}.toString();
          //  _showToast(_contactText);

        });
        print('People API ${response.statusCode} response: ${response.body}');
        return;
      }
      final Map<String, dynamic> data =
      json.decode(response.body) as Map<String, dynamic>;
      final String? namedContact = _pickFirstNamedContact(data);


      //_showToast(data.toString());
      setState(() {
        //  _showToast("4");
        final String? namedContact = _pickFirstNamedContact(data);
        // _showToast(namedContact.toString());
        final GoogleSignInAccount? user = _currentUser;
        var _name=user?.displayName.toString();
        var _mail=user?.email.toString();
        var image=user?.photoUrl.toString();


        _userLogInWithGmail(email: _mail.toString(),first_name:_name.toString(),last_name: "" );

        //////////////////////////
        //  var name=user ?.displayName.toString();
        // _showToast("Name="+_name.toString()+
        //     "mail="+_mail.toString()+
        //     "image="+image.toString()
        // );

      });


      //  await _googleSignIn.signIn();

    } catch (error) {
      _showToast(error.toString());
      print("SignIn error: "+error.toString());
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //
  //     body: Container(
  //       decoration: BoxDecoration(
  //
  //         image: DecorationImage(
  //           image: AssetImage("assets/images/background.png"),
  //           fit: BoxFit.fill,
  //         ),
  //       ),
  //       child:Flex(
  //
  //         direction: Axis.vertical,
  //         children: [
  //
  //           Container(
  //             margin: const EdgeInsets.only(top: 70.0, bottom: 50.0),
  //             child:  Image.asset(
  //               "assets/images/logo1.png",
  //               width: 218,
  //               height: 155,
  //               fit: BoxFit.fill,
  //             ),
  //
  //           ),
  //
  //           Expanded(child: _buildBottomDesign(),
  //             flex: 3,),
  //
  //         ],
  //       ) ,
  //
  //       /* add child content here */
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child:Flex(

          direction: Axis.vertical,
          children: [

            Container(
              margin: const EdgeInsets.only(top: 70.0, bottom: 50.0),
              child:  Image.asset(
                "assets/images/logo1.png",
                width: 218,
                height: 155,
                fit: BoxFit.fill,
              ),

            ),

            Expanded(child: _buildBottomDesign(),
              flex: 3,),

          ],
        ) ,

        /* add child content here */
      ),
    );
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          // ElevatedButton(
          //   child: const Text('REFRESH'),
          //   onPressed: () => _handleGetContact(user),
          // ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
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
                  //dfg
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  userInputEmail(_emailController!, 'Email', TextInputType.emailAddress),

                  SizedBox(
                    height: 5,
                  ),
                  //password input
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Password",
                        style: TextStyle(
                            color: intello_level_color,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),


                  userInputPassword(passwordController!, 'Password', TextInputType.visiblePassword),


                  Align(
                    alignment: Alignment.topRight,
                    child: InkResponse(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                      },
                      child: Text("Forget Password?",
                          style: TextStyle(
                              color: intello_input_text_color,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)
                      ),

                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildSignInButton(),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20,bottom: 10),
                      child: InkResponse(
                        onTap: (){

                        },
                        child: Text("OR",
                            style: TextStyle(
                                color:intello_or_text_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)
                        ),

                      ),
                    ),
                  ),
                  _buildSocialButton(),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(
                                  color: intello_text_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)
                          ),
                          InkResponse(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
                            },
                            child: Text(" Sign Up",
                                style: TextStyle(
                                    color:intello_bg_color,
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
            )));
  }

  Widget _buildSignInButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: () {

          String emailTxt = _emailController!.text;
          String passwordTxt = passwordController!.text;
          if (_inputValid(emailTxt, passwordTxt) == false) {
            _userLogIn(email:emailTxt,password: passwordTxt );
            //Navigator.push(context,MaterialPageRoute(builder: (context)=> NavigationBarScreen(0,HomeScreen()),));

          } else {

          }

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
              "Sign In",
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

  _inputValid(String email, String password) {
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

    if (password.isEmpty) {
      Fluttertoast.cancel();
      _showToast("Password can't empty");
      return;
    }
    if (password.length<8) {
      Fluttertoast.cancel();
      _showToast("Password must be 8 character");
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
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  Widget _buildSocialButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center,
        // direction: Axis.horizontal,
        children: [
          InkWell(
            onTap: (){
              _handleSignOut();

              _handleSignIn();
            },
            child:  Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: ig_inputBoxBackGroundColor_for_light,

              ),
              // padding: EdgeInsets.all(8), // Border width
              // decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Container(
                  height: 25,
                  width: 25,

                  child: Image.asset(

                    "assets/images/icon_google.png",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),

          InkWell(
            onTap: (){
              _logOut();
              _login();
            },
            child:  Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: ig_inputBoxBackGroundColor_for_light,

              ),
              // padding: EdgeInsets.all(8), // Border width
              // decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Container(
                  height: 25,
                  width: 25,

                  child: Image.asset(

                    "assets/images/icon_facebook.png",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          InkWell(
            onTap: (){
              // _logOut();
              // _login();
            },
            child:  Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: ig_inputBoxBackGroundColor_for_light,

              ),
              // padding: EdgeInsets.all(8), // Border width
              // decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Container(
                  height: 25,
                  width: 25,

                  child: Image.asset(

                    "assets/images/icon_apple.png",
                  ),
                ),
              ),
            ),
          ),



        ],

      ),
    );
  }

  Widget userInputEmail(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color:ig_inputBoxBackGroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 20),
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


            // suffixIcon: Icon(Icons.email,color: Colors.hint_color,),

            hintText: hintTitle,
            hintStyle:TextStyle(fontSize: 18, color:hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget userInputPassword(TextEditingController userInput, String hintTitle, TextInputType keyboardType) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color:ig_inputBoxBackGroundColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 0,bottom: 0, right: 10),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          obscureText: _isObscure,
          obscuringCharacter: "*",
          enableSuggestions: false,
          autofocus: false,
          cursorColor: intello_input_text_color,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                color: intello_input_text_color,

                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                }),
            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 18, color: hint_color, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
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

  void userNotActiveDialog(BuildContext context,String email,String user_id) {
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child:Container(
            height: 300,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 10,bottom: 10),
            child: Flex(
              direction: Axis.vertical,
              children:  [

                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10,bottom: 10),
                  child:  Text("Verify Your Email Address",
                      style: TextStyle(
                          color:intello_or_text_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                  ),
                ),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10,bottom: 10),
                      child:  Text("We need to verify your email address!",
                          style: TextStyle(
                              color:intello_small_text_color_for_dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0,bottom: 10),
                      child:   Text(email,
                          style: TextStyle(
                              color:intello_color_tag_text,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                    ),
                  ],
                )),

                Align(
                    alignment: Alignment.bottomCenter,
                    child: Flex(direction: Axis.horizontal,

                      children: [
                        Expanded(child:  Container(
                          margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [intello_bg_color, intello_bg_color],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(7.0)
                              ),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child:  Text(
                                  "Cancel",
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
                        ),),

                        Expanded(child:  Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 00.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Fluttertoast.cancel();
                              Navigator.of(context).pop();
                              _sendOtp(userId: user_id);

                              // Navigator.push(context,MaterialPageRoute(builder: (context)=> SendOtpForVerifyScreen(),));


                              //_showToast("verify page");
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
                                height: 40,
                                alignment: Alignment.center,
                                child:  Text(
                                  "Verify Mail",
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
                        ),)


                      ],
                    )


                )



              ],
            ),
          ) ,
        );
      },
    );
  }

  _sendOtp({required String userId,}
      ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Sending...");
        try {
          Response response =
          await put(Uri.parse('$BASE_URL_API$SUB_URL_API_Email_SEND_OTP$userId/'),

          );
          Navigator.of(context).pop();

          if (response.statusCode == 200) {

            Navigator.push(context,MaterialPageRoute(builder: (context)=>SendOtpForVerifyScreen(userId: userId,)));

          }
          else if (response.statusCode == 400) {
            var data = jsonDecode(response.body);
            _showToast(data['message']);
          }

          else {
            // var data = jsonDecode(response.body.toString());
            // _showToast(data['message']);
          }
        } catch (e) {
          //  Navigator.of(context).pop();
          print(e.toString());
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }

  _userLogInStatusCheck({
    required String userId,
  }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Checking...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_USER_LGIN_STATUS_CHECK'),
              body: {
                'user_id': userId,
              });
          Navigator.of(context).pop();
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());

            saveUserInfoAfterUserLoginStatus(data);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(_darkOrLightStatus)),
              ),
                  (route) => false,
            );

            // Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationBarScreen(0,HomeScreen())));

          }
          else if (response.statusCode == 400) {
            var data = jsonDecode(response.body);
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


  _userLogInWithGmail(
      {

        required String first_name,
        required String last_name,
        required String email,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Checking...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_LOG_IN_WITH_GMAIL'),
              body: {
                'first_name': first_name,
                'last_name': first_name,
                'email': email,
              });
          Navigator.of(context).pop();
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());

            saveUserInfo(data);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(1)),
              ),
                  (route) => false,
            );

            // Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationBarScreen(0,HomeScreen())));

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

  _userLogInWithFaceBook(
      {

        required String first_name,
        required String last_name,
        required String email,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Checking...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_LOG_IN_WITH_GMAIL'),
              body: {
                'first_name': first_name,
                'last_name': first_name,
                'email': email,
              });
          Navigator.of(context).pop();
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());

            saveUserInfo(data);
            _logOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(1)),
              ),
                  (route) => false,
            );

            // Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationBarScreen(0,HomeScreen())));

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

  _userLogIn(
      {
        required String email,
        required String password,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoadingDialog(context,"Checking...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_LOG_IN'),
              body: {
                'username_or_email': email,
                'password': password,
              });
          Navigator.of(context).pop();
          // _showToast(response.statusCode.toString());

          if (response.statusCode == 200) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());

            saveUserInfo(data);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(0,HomeScreen(1)),
              ),
                  (route) => false,
            );

            // Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationBarScreen(0,HomeScreen())));

          }
          else if (response.statusCode == 400) {
            var data = jsonDecode(response.body);
            _showToast(data['message']);
          }
          else if (response.statusCode == 201) {
            setState(() {
              //_showToast("success");
              var data = jsonDecode(response.body);
              userNotActiveDialog(context,email,data['data']['id'].toString());
            });

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

      sharedPreferences.setString(pref_user_id, userInfo['data']['id'].toString());
      sharedPreferences.setString(pref_user_uuid, userInfo['data']['uuid'].toString());
      sharedPreferences.setString(pref_user_access_token, userInfo['access_token'].toString());
      sharedPreferences.setString(pref_user_refresh_token, userInfo['refresh_token'].toString());
      sharedPreferences.setString(pref_user_email, userInfo['email'].toString());
      sharedPreferences.setString(pref_login_status, "1");
      sharedPreferences.setInt(pref_user_dark_light_status, 1);

      //sharedPreferences.setString(pref_user_password, userInfo['email'].toString());

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

  void saveUserInfoAfterUserLoginStatus(var userInfo) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString(pref_user_id, userInfo['data']['id'].toString());
      sharedPreferences.setString(pref_user_uuid, userInfo['data']['uuid'].toString());
      sharedPreferences.setString(pref_user_access_token, userInfo['access_token'].toString());
      sharedPreferences.setString(pref_user_refresh_token, userInfo['refresh_token'].toString());
      sharedPreferences.setString(pref_user_email, userInfo['email'].toString());
      sharedPreferences.setString(pref_login_status, "1");
      // sharedPreferences.setInt(pref_user_dark_light_status, 1);

      //sharedPreferences.setString(pref_user_password, userInfo['email'].toString());

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

  _inputValidation({required String email, required String password} ) {

    if (email.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("email can't empty");
      return;
    }

    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+"
      //  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    ).hasMatch(email)) {
      validation_showToast("Enter valid email");
      return;
    }

    if (password.isEmpty) {
      Fluttertoast.cancel();
      validation_showToast("Password can't empty");
      return;
    }


    return false;
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        _userId = sharedPreferences.getString(pref_user_id)!;
        _accessToken1 = sharedPreferences.getString(pref_user_access_token)!;
        _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
        _darkOrLightStatus = sharedPreferences.getInt(pref_user_dark_light_status)!;
      });
    } catch(e) {
      //code
    }

  }

}
