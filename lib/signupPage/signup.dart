import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newrandomproject/mainPages/home.dart';
import 'package:image_picker/image_picker.dart';

//View News Page Widget
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

//View News Widget State
class _SignUpPage extends State<SignUpPage> {
  String appBarTitle = "Sign Up";

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? _imageFileList;
  set imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  bool hidePass = true;
  bool checkedValue = false;
  bool loginCheck = false;
  bool checkImage = false;

  String signUpMessage = '';

  TextEditingController username = new TextEditingController();
  TextEditingController emailAddress = new TextEditingController();
  TextEditingController password = new TextEditingController();

  late FirebaseAuth auth;
  late final FirebaseFirestore firestoreInstance;
  late FirebaseStorage storageInstance;

  intiliazieConnection() {
    setState(() {
      try {
        auth = FirebaseAuth.instance;
        firestoreInstance = FirebaseFirestore.instance;
        storageInstance = FirebaseStorage.instance;
        print('DB Initialized');
      } catch (e) {
        print(e);
      }
    });
  }

  goToHomePage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        ModalRoute.withName("/LoginPage"));
  }

  Future getImageFromGallery() async {
    try {
      var image = await imagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageFile = image;
        checkImage = true;
        print(_imageFileList![0].path);
      });
    } catch (e) {
      print(e);
      setState(() {
        checkImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    intiliazieConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
          automaticallyImplyLeading: true,
        ),
        body: GestureDetector(
            onTap: () => {FocusScope.of(context).requestFocus(new FocusNode())},
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(23, 23, 23, 1),
                    Color.fromRGBO(13, 13, 13, 1)
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                      alignment: Alignment.center,
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: checkImage
                          ? Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(_imageFileList![0].path),
                                    fit: BoxFit.fill),
                              ),
                              // child: Image.file(
                              //   File(_imageFileList![0].path),
                              //   fit: BoxFit.fill,
                              //   scale: 1.0,
                              // ),
                            )
                          : Icon(
                              Icons.person,
                              size: 150.0,
                              color: Colors.white,
                            )),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          backgroundColor: Colors.grey[850],
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0, bottom: 30.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            print('Show Camera');
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.0),
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[800],
                                                  border: Border.all(
                                                      color: Colors.blue,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.photo_camera,
                                                      color: Colors.white),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),
                                        )),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            getImageFromGallery();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.0),
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[800],
                                                  border: Border.all(
                                                      color: Colors.blue,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                      Icons
                                                          .photo_library_rounded,
                                                      color: Colors.white),
                                                  Text(
                                                    'Photo Library',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),
                                        ))
                                      ],
                                    ))
                              ],
                            );
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                      child: Text(
                        'Add Profile Picture',
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                    width: 250.0,
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
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
                                color: Colors.blue, width: 1.0),
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
                                BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                      child: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.grey),
                          child: CheckboxListTile(
                            checkColor: Colors.white,
                            title: Text(
                              "I agree with Privacy Policy",
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: checkedValue,
                            onChanged: (newValue) {
                              setState(() {
                                checkedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ))),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Text(
                        signUpMessage,
                        style: TextStyle(
                            color: loginCheck ? Colors.red : Colors.green,
                            fontSize: 14.0),
                      )),
                  GestureDetector(
                      onTap: () async {
                        try {
                          if (username.text == '') {
                            setState(() {
                              loginCheck = true;
                              signUpMessage = 'Please Enter Username';
                            });
                          } else {
                            await auth.createUserWithEmailAndPassword(
                                email: emailAddress.text,
                                password: password.text);
                            final User user = auth.currentUser!;
                            final userId = user.uid;
                            user.updateDisplayName(username.text);
                            setState(() {
                              loginCheck = false;
                              signUpMessage = 'Account Successfully Created';
                              //Store Profile Picture into Firebase Storage
                              if (_imageFileList![0].path != '') {
                                storageInstance
                                    .ref()
                                    .child(userId)
                                    .putFile(File(_imageFileList![0].path))
                                    .whenComplete(
                                        () => {print('Image Uploaded')});
                              } else {
                                return;
                              }

                              //Store Profile Info into Firestore Database
                              firestoreInstance
                                  .collection('users')
                                  .doc(userId)
                                  .set({
                                'displayName': username.text,
                                'email': emailAddress.text,
                                'verified': false
                              }).then((verifyCheck) => {
                                        Future.delayed(Duration(seconds: 1),
                                            () => {goToHomePage()}),
                                      });
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            setState(() {
                              loginCheck = true;
                              signUpMessage = 'Weak Password';
                            });
                          } else if (e.code == 'email-already-in-use') {
                            setState(() {
                              loginCheck = true;
                              signUpMessage = 'Email Already In-Use';
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        width: 300.0,
                        height: 45.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 40.0),
                        decoration: BoxDecoration(
                            color: Colors.green[800],
                            border: Border.all(color: Colors.green, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )),
                ],
              ),
            )));
  }
}
