import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//View News Page Widget
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

//View News Widget State
class _ProfilePage extends State<ProfilePage> {
  String appBarTitle = "Profile";
  int pageIndex = 3;

  late FirebaseAuth auth;
  late final FirebaseFirestore firestoreInstance;

  TextEditingController applicationMessage = new TextEditingController();

  bool userVerified = false;
  var userId;
  var displayName;
  var getEmail;

  //Responsible for the Bottom Navigation Bar
  //Page doesn't change if user is in current page.
  void navigationBarTapped(int index) {
    setState(() {
      pageIndex = index;

      switch (pageIndex) {
        case 0:
          Navigator.of(context).push(homeRoute());
          break;
        case 1:
          Navigator.of(context).push(stocksRoute());
          break;
        case 2:
          Navigator.of(context).push(groupChatRoute());
          break;
        case 3:
          appBarTitle = 'Profile';
      }
    });
  }

  initiateConnection() {
    setState(() {
      auth = FirebaseAuth.instance;
      firestoreInstance = FirebaseFirestore.instance;
      print('DB Initialized');
    });
  }

  checkVerifyUser() async {
    User user = auth.currentUser!;
    late bool userCheck;
    setState(() {
      userId = user.uid;
      getEmail = auth.currentUser!.email;
      displayName = user.displayName;

      firestoreInstance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) => userVerified = value.data()!['verified'])
          .then((verifyCheck) => {
                if (verifyCheck == true)
                  {
                    setState(() {
                      userVerified = true;
                    })
                  }
                else
                  {
                    setState(() {
                      userVerified = false;
                    })
                  }
              });
    });
  }

  //Logout Clicked
  logOutClicked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("isLoggedIn", false);
    });
    Navigator.of(context).push(loginRoute());
  }

  @override
  void initState() {
    super.initState();
    initiateConnection();
    checkVerifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.help_outline_rounded, color: Colors.grey[600]),
              onPressed: () {
                print('FAQ CLICKED');
              }),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {logOutClicked()},
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red[300],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(24, 24, 24, 1.0),
          type: BottomNavigationBarType.fixed,
          iconSize: 27.0,
          currentIndex: pageIndex,
          onTap: navigationBarTapped,
          elevation: 5,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                ),
                label: ('')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                ),
                label: ('')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                label: ('')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.green[300],
                ),
                label: (''))
          ],
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
                    margin: EdgeInsets.only(top: 40.0),
                    alignment: Alignment.center,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      // image: new DecorationImage(
                      //   fit: BoxFit.contain,
                      //   image: new NetworkImage(
                      //     profilePic,
                      //   ),
                      // ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          children: <Widget>[
                            Text(displayName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              children: <Widget>[
                                userVerified
                                    ? Text('Verified',
                                        style: TextStyle(
                                            color: Colors.cyan[400],
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold))
                                    : Text('Not Verified',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                SizedBox(width: 5.0),
                                userVerified
                                    ? Icon(Icons.check_circle_rounded,
                                        color: Colors.blue[300], size: 20.0)
                                    : Container()
                              ],
                            )
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('10', style: TextStyle(color: Colors.white)),
                              Text('Following',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        )),
                        VerticalDivider(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        Expanded(
                            child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('12.5M',
                                  style: TextStyle(color: Colors.white)),
                              Text('Followers',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 20.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //         width: 150.0,
                  //         height: 50.0,
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey[900],
                  //             border:
                  //                 Border.all(color: Colors.grey, width: 1.0),
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10.0))),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: <Widget>[
                  //             Text('10', style: TextStyle(color: Colors.white)),
                  //             Text('Following',
                  //                 style: TextStyle(color: Colors.grey))
                  //           ],
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10.0),
                  //       Container(
                  //         width: 150.0,
                  //         height: 50.0,
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey[900],
                  //             border:
                  //                 Border.all(color: Colors.grey, width: 1.0),
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10.0))),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: <Widget>[
                  //             Text('12.5M',
                  //                 style: TextStyle(color: Colors.white)),
                  //             Text('Followers',
                  //                 style: TextStyle(color: Colors.grey))
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    'Stock Portfolio',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  )),
                              Expanded(
                                child: SizedBox(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                              ),
                              builder: (BuildContext context) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, left: 10.0),
                                        child: Text(
                                          'Verified User Application',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
                                      child: TextField(
                                        controller: applicationMessage,
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                            hintText:
                                                'Why Should we Accept you?',
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)))),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          firestoreInstance
                                              .collection('userApplications')
                                              .doc(userId)
                                              .set({
                                            'email': getEmail,
                                            'message': applicationMessage.text
                                          });
                                          Future.delayed(
                                              Duration(seconds: 1),
                                              () => {
                                                    Navigator.of(context).pop()
                                                  });
                                        },
                                        child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 20.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.all(
                                                    (Radius.circular(30.0)))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Submit Application',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )))
                                  ],
                                );
                              });
                        },
                        child: Container(
                            width: 150.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                border:
                                    Border.all(color: Colors.blue, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Icon(
                                    Icons.signal_cellular_alt_rounded,
                                    color: Colors.blue[300],
                                    size: 50.0,
                                  ),
                                ),
                                Text(
                                  "Apply to be a Signal",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Go To Premium');
                        },
                        child: Container(
                            width: 150.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                border: Border.all(
                                    color: Colors.deepPurple, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Icon(
                                    Icons.attach_money_rounded,
                                    color: Colors.deepPurple[300],
                                    size: 50.0,
                                  ),
                                ),
                                Text(
                                  "Premium",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            )));
  }
}
