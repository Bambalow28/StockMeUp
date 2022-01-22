import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:newrandomproject/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

//View News Page Widget
class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

//View News Widget State
class _MainPage extends State<MainPage> {
  String appBarTitle = "Home";
  bool userVerified = false;
  String marketStatus = '';
  bool marketStatusCheck = false;
  int pageIndex = 0;
  int timeMarketOpen = 0;

  var userId;
  late var displayName;

  //Texts for each signals
  List signalInfo = [];

  bool signalVote = false;

  //DateTime
  DateTime timeNow = DateTime.now();
  DateFormat formatter = DateFormat.yMd().add_jm();
  String formattedDate = '';

  late FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  Widget floatingButton() {
    if (userVerified == true) {
      return FloatingActionButton(
        elevation: 5.0,
        child: Icon(Icons.create_rounded),
        backgroundColor: Colors.blue[300],
        onPressed: () {
          Navigator.of(context).push(postSignalRoute());
        },
      );
    } else {
      return Container();
    }
  }

  //Convert Timestamp to Ago
  String convertTime(DateTime timeInput) {
    Duration diff = DateTime.now().difference(timeInput);

    if (diff.inDays >= 1) {
      if (diff.inDays == 1) {
        return '${diff.inDays} Day ago';
      } else {
        return '${diff.inDays} Days ago';
      }
    } else if (diff.inHours >= 1) {
      if (diff.inHours == 1) {
        return '${diff.inHours} Hour ago';
      } else {
        return '${diff.inHours} Hours ago';
      }
    } else if (diff.inMinutes >= 1) {
      if (diff.inMinutes == 1) {
        return '${diff.inMinutes} Minute ago';
      } else {
        return '${diff.inMinutes} Minutes ago';
      }
    } else if (diff.inSeconds >= 1) {
      if (diff.inSeconds == 1) {
        return '${diff.inSeconds} Second ago';
      } else {
        return '${diff.inSeconds} Seconds ago';
      }
    } else {
      return 'Just Now';
    }
  }

  checkVerifyUser() {
    User user = auth.currentUser!;
    setState(() {
      userId = user.uid;
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
                    }),
                  }
                else
                  {
                    setState(() {
                      userVerified = false;
                    })
                  },
                print(verifyCheck)
              });
    });
  }

  //Responsible for the Bottom Navigation Bar
  //Page doesn't change if user is in current page.
  void navigationBarTapped(int index) {
    setState(() {
      pageIndex = index;

      switch (pageIndex) {
        case 0:
          appBarTitle = "Home";
          break;
        case 1:
          Navigator.of(context).push(stocksRoute());
          break;
        case 2:
          Navigator.of(context).push(groupChatRoute());
          break;
        case 3:
          Navigator.of(context).push(profileRoute());
          break;
      }
    });
  }

  getUserLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn');

    if (status == false) {
      Navigator.of(context).push(loginRoute());
    }
  }

  //Get all data stored in Firestore in Firebase
  getDataFromFirebase() async {
    var getPosts = await firestoreInstance.collection('posts').get();

    getPosts.docs.forEach((userIdentify) {
      if (userIdentify['postStatus'] == 'Public') {
        setState(() {
          signalInfo.add(userIdentify.data());
        });
      } else if (userIdentify['postStatus'] == 'Private') {
        return;
      }
    });
  }

  //Show Market Status (When it opens)
  showMarketStatus(BuildContext context) {
    Widget okBtn = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Got it!'));

    AlertDialog marketClosedAlert = AlertDialog(
      title: marketStatusCheck ? Text('MARKET OPEN') : Text('MARKET CLOSED'),
      content: marketStatusCheck
          ? Text('Market is open until 4:00PM EST')
          : Text('Market Opens in ' + ' ' + '$timeMarketOpen'),
      actions: [okBtn],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return marketClosedAlert;
        });
  }

  //Check if Time is Between Market Hours
  marketHours() async {
    var marketHrs = Uri.parse(
        'https://api.polygon.io/v1/marketstatus/now?apiKey=KoqKkSeNoEgp2qToI4l3mfyE0PmEriOf');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'KoqKkSeNoEgp2qToI4l3mfyE0PmEriOf'
    };
    var res = await http.get(marketHrs, headers: headers);

    var jsonResponse = convert.jsonDecode(res.body);
    var marketTime = jsonResponse['market'];

    if (marketTime == 'open') {
      print("Market is Open");
      setState(() {
        marketStatus = "Market Open";
        marketStatusCheck = true;
      });
    } else {
      print("Market is Closed");
      setState(() {
        marketStatus = "Market Closed";
        marketStatusCheck = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLoginState();
    marketHours();
    checkVerifyUser();
    getDataFromFirebase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {print('Search Users')},
                child: Icon(Icons.search),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {print('Show Notifications')},
                child: Icon(Icons.notifications_none_rounded),
              ),
            ),
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
                  color: Colors.green[300],
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
                  color: Colors.white,
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
                    GestureDetector(
                      onTap: () {
                        showMarketStatus(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.only(top: 20.0, bottom: 25.0),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: marketStatusCheck
                                ? Colors.green[400]
                                : Colors.red[400],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          marketStatus,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: signalInfo.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              var formatDate = signalInfo[index]['timePosted'];
                              var parsedDate = DateTime.parse(
                                  formatDate.toDate().toString());

                              formattedDate = formatter.format(parsedDate);
                              var convertedTime = convertTime(parsedDate);

                              return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight:
                                                    Radius.circular(20.0))),
                                        backgroundColor: Colors.grey[850],
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 20.0, bottom: 10.0),
                                                child: Text(
                                                  signalInfo[index]
                                                      ['tickerSymbol'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 32.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, bottom: 5.0),
                                                child: Text(
                                                  signalInfo[index]
                                                      ['signalPost'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 20.0,
                                                    right: 20.0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 130.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    border: Border.all(
                                                        color: Colors.blue,
                                                        width: 1.0)),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        'Signal Status',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20.0),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                            .green[
                                                                        800],
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .green,
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 5.0),
                                                                      child:
                                                                          Text(
                                                                        signalInfo[index]['goodSignal']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                24.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10.0),
                                                                      child:
                                                                          Text(
                                                                        'Good Signal',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))),
                                                        SizedBox(width: 10.0),
                                                        Expanded(
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20.0),
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        8.0),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                            .red[
                                                                        800],
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 5.0),
                                                                      child:
                                                                          Text(
                                                                        signalInfo[index]['badSignal']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                24.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10.0),
                                                                      child:
                                                                          Text(
                                                                        'Bad Signal',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5.0, left: 20.0),
                                                    alignment: Alignment.center,
                                                    height: 50.0,
                                                    width: 30.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[400],
                                                      // image: new DecorationImage(
                                                      //   fit: BoxFit.contain,
                                                      //   image: new NetworkImage(
                                                      //     profilePic,
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0, left: 5.0),
                                                    child: Text(
                                                      signalInfo[index]['user'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0, left: 2.0),
                                                    child: Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: Colors.blue[300],
                                                        size: 12.0),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              signalVote = true;
                                                            });

                                                            await firestoreInstance
                                                                .collection(
                                                                    "posts")
                                                                .doc(signalInfo[
                                                                        index]
                                                                    ['postID'])
                                                                .update({
                                                              "goodSignal": FieldValue
                                                                  .increment(
                                                                      signalVote
                                                                          ? (1)
                                                                          : (-1))
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20.0),
                                                            height: 50.0,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green[300],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .trending_up_rounded,
                                                                    color: Colors
                                                                        .white),
                                                                SizedBox(
                                                                    width: 5.0),
                                                                Text(
                                                                  'Good Signal',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ))),
                                                  SizedBox(width: 10.0),
                                                  Expanded(
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              signalVote =
                                                                  false;
                                                            });

                                                            await firestoreInstance
                                                                .collection(
                                                                    "posts")
                                                                .doc(signalInfo[
                                                                        index]
                                                                    ['postID'])
                                                                .update({
                                                              "badSignal": FieldValue
                                                                  .increment(
                                                                      signalVote
                                                                          ? (-1)
                                                                          : (1))
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 50.0,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        20.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .red[300],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .trending_down_rounded,
                                                                    color: Colors
                                                                        .white),
                                                                SizedBox(
                                                                    width: 5.0),
                                                                Text(
                                                                  'Bad Signal',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ))),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0, bottom: 10.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[850],
                                        border: Border.all(
                                            color: signalInfo[index]
                                                        ['signal'] ==
                                                    'BUY'
                                                ? Colors.green
                                                : Colors.red,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, left: 10.0),
                                                child: Text(
                                                  signalInfo[index]
                                                      ['tickerSymbol'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0),
                                                )),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, right: 20.0),
                                                child: Text(
                                                  signalInfo[index]['signal'],
                                                  style: TextStyle(
                                                      color: signalInfo[index]
                                                                  ['signal'] ==
                                                              'BUY'
                                                          ? Colors.green[300]
                                                          : Colors.red[300],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5.0, left: 10.0),
                                                child: Text(
                                                  signalInfo[index]
                                                      ['signalPost'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0),
                                                )),
                                            Expanded(
                                              child: SizedBox(),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0, bottom: 5.0),
                                              child: Text(
                                                '@' + signalInfo[index]['user'],
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10.0, bottom: 5.0),
                                              child: Text(
                                                convertedTime,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            }))
                  ],
                ))),
        floatingActionButton: floatingButton());
  }
}
