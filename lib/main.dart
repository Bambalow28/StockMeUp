import 'package:flutter/material.dart';
import 'dart:io';
import 'package:newrandomproject/mainPages/home.dart';
import 'package:newrandomproject/mainPages/verifiedHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var status = prefs.getBool('isLoggedIn');

    setState(() {
      prefs.setBool("isLoggedIn", true);
    });
  }

  checkLoginState() async {
    prefs = await SharedPreferences.getInstance();

    var status = prefs.getBool('isLoggedIn');
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

  goToVerifiedHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VerifiedHome()),
        ModalRoute.withName("/LoginPage"));
  }

  Future loginVerify() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      setState(() {
        loginMessage = 'Login Success';
        loginCheck = false;
        final User user = auth.currentUser!;
        final userId = user.uid;
        late bool userChecking;
        firestoreInstance
            .collection('users')
            .doc(userId)
            .get()
            .then((value) => userChecking = value.data()!['verified'])
            .then((verifyCheck) => {
                  if (userChecking == true)
                    {
                      loginMessage = 'Loading...',
                      Future.delayed(
                          Duration(seconds: 1), () => {goToVerifiedHome()})
                    }
                  else
                    {
                      loginMessage = 'Loading...',
                      Future.delayed(
                          Duration(seconds: 1), () => {goToHomePage()})
                    },
                  userLoggedIn()
                });
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
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      final User user = auth.currentUser!;
      final userId = user.uid;
      setState(() {
        loginCheck = false;
        firestoreInstance.collection('users').doc(userId).set({
          'email': emailAddress.text,
          'verified': false
        }).then((verifyCheck) => {
              loginMessage = 'Account Successfully Created',
              Future.delayed(Duration(seconds: 1), () => {goToHomePage()}),
              userLoggedIn()
            });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          loginCheck = true;
          loginMessage = 'Weak Password';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          loginCheck = true;
          loginMessage = 'Email Already In-Use';
        });
      }
    } catch (e) {
      print(e);
    }
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
                            borderSide:
                                BorderSide(color: Colors.green, width: 1.0),
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
                    child: isLoading
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.0)),
                            ))
                        : Container(
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          signUpLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          signUpVerify();
                          signUpLoading = false;
                        });
                      },
                      child: signUpLoading
                          ? Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: SizedBox(
                                height: 100.0,
                                width: 100.0,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2.0)),
                              ))
                          : Container(
                              width: 270.0,
                              height: 45.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  border: Border.all(
                                      color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
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
            )));
  }
}
