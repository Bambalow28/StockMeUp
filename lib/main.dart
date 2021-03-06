import 'package:flutter/material.dart';
import 'dart:io';
import 'package:newrandomproject/mainPages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newrandomproject/signupPage/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Me Up',
      home: LoginPage(title: 'Stock Me Up Login'),
    );
  }
}

//Login Widget
class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

//Login Page Widget State
class _LoginPageState extends State<LoginPage> {
  TextEditingController emailAddress = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool loginCheck = false;
  bool hidePass = true;
  bool isLoading = false;
  bool signUpLoading = false;

  String loginMessage = '';

  late FirebaseAuth auth;
  late final FirebaseFirestore firestoreInstance;
  late SharedPreferences prefs;

  String loginText = 'Login';
  late User user = user;
  late var uid;

  userLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("isLoggedIn", true);
    });
  }

  checkLoginState() async {
    prefs = await SharedPreferences.getInstance();

    var status = prefs.getBool('isLoggedIn');
    if (status == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          ModalRoute.withName("/LoginPage"));
    } else {
      return;
    }
    print('User Login Status: ' + status.toString());
  }

  //Initiate FlutterFire (Firebase)
  void initializeFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        auth = FirebaseAuth.instance;
        firestoreInstance = FirebaseFirestore.instance;
        print('DB Initialized');
      });
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }

  goToHomePage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        ModalRoute.withName("/LoginPage"));
  }

  Future loginVerify() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      setState(() {
        loginCheck = false;
        loginMessage = 'Login Success';
        userLoggedIn();
        Future.delayed(Duration(seconds: 1), () => {goToHomePage()});
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          loginCheck = true;
          loginMessage = 'No User Found';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          loginCheck = true;
          loginMessage = 'Wrong Password';
        });
      }
    }
  }

  signUpVerify() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
    //
  }

  @override
  void initState() {
    super.initState();
    initializeFire();
    checkLoginState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 130.0),
                  //   width: 180.0,
                  //   height: 180.0,
                  //   decoration: BoxDecoration(
                  //       color: Colors.blue[700],
                  //       borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  //   child: Icon(
                  //     Icons.signal_cellular_alt_sharp,
                  //     color: Colors.yellow[50],
                  //     size: 150.0,
                  //   ),
                  // ),
                  Container(
                      padding: EdgeInsets.only(top: 150.0, bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            text: 'STOCKME',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45.0,
                                fontStyle: FontStyle.italic),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'UP',
                                  style: TextStyle(
                                      color: Colors.blue[300],
                                      fontSize: 55.0,
                                      fontWeight: FontWeight.bold))
                            ]),
                      )),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                    child: TextField(
                      controller: emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[850],
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        hintText: 'Email Address',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue[300]!, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: TextField(
                      controller: password,
                      obscureText: hidePass,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[850],
                        prefixIcon:
                            Icon(Icons.lock_open_rounded, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_rounded,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              if (hidePass == true) {
                                hidePass = false;
                              } else {
                                hidePass = true;
                              }
                            });
                          },
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue[300]!, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        loginVerify();
                        isLoading = false;
                      });
                    },
                    child: Container(
                      width: 300.0,
                      height: 45.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Text(
                        loginText,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Container(
                        width: 270.0,
                        height: 45.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[850],
                            border: Border.all(color: Colors.green, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Colors.grey, strokeWidth: 2.0),
                            )
                          : Text(
                              loginMessage,
                              style: TextStyle(
                                  color: loginCheck ? Colors.red : Colors.green,
                                  fontSize: 12.0),
                            )),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    height: 30.0,
                    margin: EdgeInsets.only(bottom: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Developed By: Joshua Alanis",
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
