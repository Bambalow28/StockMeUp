import 'package:flutter/material.dart';
import 'package:newrandomproject/mainPages/home.dart';

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

  goToSignUpPage() {}

  goToHomePage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        ModalRoute.withName("/LoginPage"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
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
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        prefixIcon:
                            Icon(Icons.lock_open_rounded, color: Colors.grey),
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
                      goToHomePage();
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
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Sign Up Clicked');
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
