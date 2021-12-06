import 'package:flutter/material.dart';
import 'package:newrandomproject/mainPages/home.dart';
import 'package:newrandomproject/mainPages/verifiedHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  late FirebaseAuth auth;

  String loginText = 'Login';

  //Initiate FlutterFire (Firebase)
  void initializeFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        auth = FirebaseAuth.instance;
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

  goToVerifiedHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VerifiedHome()),
        ModalRoute.withName("/LoginPage"));
  }

  loginVerify() async {
    // if (emailAddress.text == "admin" && password.text == "admin123") {
    //   goToVerifiedHome();
    // } else if (emailAddress.text == "user" && password.text == "user123") {
    //   goToHomePage();
    // } else {
    //   print("Error! No Account Found!");
    //   loginCheck = true;
    //   loginVerify();
    // }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      setState(() {
        loginText = 'Login Success';
        Future.delayed(Duration(seconds: 1), () => {goToVerifiedHome()});
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          loginCheck = true;
          print('No user found for that email.');
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          loginCheck = true;
          print('Wrong password provided for that user.');
        });
      }
    }
  }

  signUpVerify() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      print('Account Created!');
      goToHomePage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The Password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The Account already exists.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFire();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 150, bottom: 10.0),
                    child: Text(
                      'STOCKMEUP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
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
                        fillColor: Colors.grey[800],
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        hintText: 'Email Address',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1.0),
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
                        fillColor: Colors.grey[800],
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
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      loginVerify();
                    },
                    child: Container(
                      width: 300.0,
                      height: 45.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color:
                              loginCheck ? Colors.red[300] : Colors.green[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Text(
                        loginText,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      signUpVerify();
                    },
                    child: Container(
                      width: 270.0,
                      height: 45.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      child: Text(
                        "Sign Up",
                        style:
                            TextStyle(color: Colors.green[400], fontSize: 20.0),
                      ),
                    ),
                  ),
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
            )));
  }
}
