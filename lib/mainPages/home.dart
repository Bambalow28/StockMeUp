import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:newrandomproject/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newrandomproject/mainPages/viewProfile.dart';

//View News Page Widget
class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

//View News Widget State
class _MainPage extends State<MainPage> {
  String appBarTitle = "UP";
  bool userVerified = false;
  String marketStatus = '';
  bool marketStatusCheck = false;
  int pageIndex = 0;
  int timeMarketOpen = 0;

  var userId;
  late var displayName;
  var allNames;

  Color dateArrow = Colors.white;

  //Texts for each signals
  List signalInfo = [];

  //List of Users
  Map<String, String> userNames = {};
  Map<String, String> filteredNames = {};
  List profilePicture = [];

  bool signalVote = false;

  //DateTime
  DateTime timeNow = DateTime.now();
  DateFormat formatter = DateFormat.yMd().add_jm();
  DateFormat formatMonthDate = DateFormat('MMMM dd, yyyy');
  String formattedDate = '';
  DateTime backDate = DateTime.now();

  late FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseStorage storage = FirebaseStorage.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  TextEditingController searchUser = TextEditingController();

  //Show Data based on Date
  getDateAndFormat() async {
    var getDate = await firestoreInstance.collection("posts").get();

    getDate.docs.forEach((element) {
      var dateData = element.data()['timePosted'];
      var formatDate = DateTime.parse(dateData.toDate().toString());

      if (backDate.year == formatDate.year &&
          backDate.month == formatDate.month &&
          backDate.day == formatDate.day) {
        print('DATE MATCH');
        setState(() {
          signalInfo.add(element.data());
        });
      } else {
        print('DATE NOT MATCH');
      }
    });
  }

  //Get all usernames from Firebase
  getAllUsersFromFirebase() async {
    var userCheck = await firestoreInstance.collection("users").get();
    allNames = userCheck.docs.map((e) => e.data());

    allNames.forEach((eachName) {
      setState(() {
        userNames[eachName['displayName']] = eachName['profilePicture'];
        // userNames.addEntries();
        // profilePicture.add(eachName['profilePicture']);
      });
    });
  }

  //Filter Usernames
  filterUsers(String inputString) {
    userNames.keys.forEach((key) {
      bool checkNames = key.toLowerCase().contains(inputString.toLowerCase());

      if (inputString.isEmpty) {
        setState(() {
          filteredNames.clear();
          filteredNames.remove(key);
        });
      } else if (checkNames) {
        setState(() {
          userNames.forEach((key, value) {
            if (key == inputString.toLowerCase()) {
              filteredNames[key] = value;
            }
          });
        });
      } else {
        print('Name is NOT in the Data');
      }
    });
  }

  //Show Floating Button if user is Verified
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

  //Check if user is verified or not
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

  // //Get all data stored in Firestore in Firebase
  // getDataFromFirebase() async {
  //   var getPosts = await firestoreInstance.collection('posts').get();

  //   getPosts.docs.forEach((userIdentify) {
  //     if (userIdentify['postStatus'] == 'Public') {
  //       setState(() {
  //         signalInfo.add(userIdentify.data());
  //       });
  //     } else if (userIdentify['postStatus'] == 'Private') {
  //       return;
  //     }
  //   });
  // }

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

  signalBottomSheet(BuildContext context, int index) async {
    var getGoodSignal = await firestoreInstance
        .collection("posts")
        .doc(signalInfo[index]['postID'])
        .get();

    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        backgroundColor: Colors.grey[850],
        builder: (BuildContext context) {
          bool postStatus = false;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      'Stock Name',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 20.0),
                    child: Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      signalInfo[index]['tickerSymbol'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 5.0, left: 20.0),
                    child: Text(
                      'Description',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0, left: 20.0),
                    child: Text(
                      signalInfo[index]['signalPost'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              // Row(
              //   children: <Widget>[
              //     Padding(
              //       padding:
              //           EdgeInsets.only(top: 10.0, bottom: 5.0, left: 20.0),
              //       child: Text(
              //         'Signal Accuracy',
              //         style: TextStyle(color: Colors.grey, fontSize: 12.0),
              //       ),
              //     ),
              //     Expanded(
              //       child: SizedBox(),
              //     )
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(left: 20.0),
              //       child: RichText(
              //           text: TextSpan(
              //               text: '99% ',
              //               style:
              //                   TextStyle(color: Colors.green, fontSize: 14.0),
              //               children: <TextSpan>[
              //             TextSpan(
              //                 text: 'Accurate',
              //                 style: TextStyle(
              //                     color: Colors.white, fontSize: 14.0))
              //           ])),
              //     ),
              //     Expanded(
              //       child: SizedBox(),
              //     )
              //   ],
              // ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 200.0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, bottom: 5.0),
                                    child: Text(
                                      'Posted By',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    alignment: Alignment.center,
                                    height: 25.0,
                                    width: 25.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[400],
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            signalInfo[index]
                                                ['userProfilePic']),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0, left: 5.0),
                                    child: Text(
                                      signalInfo[index]['user'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0, left: 2.0),
                                    child: Icon(Icons.check_circle_rounded,
                                        color: Colors.blue[300], size: 12.0),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (postStatus == true) {
                          print('Liked Already');
                        } else {
                          postStatus = true;
                          print('Liked');
                          if (getGoodSignal.data()!['badSignal'] != 0) {
                            firestoreInstance
                                .collection('posts')
                                .doc(signalInfo[index]['postID'])
                                .update({
                              "goodSignal": FieldValue.increment(1),
                              "badSignal": FieldValue.increment(-1)
                            });
                          } else {
                            firestoreInstance
                                .collection('posts')
                                .doc(signalInfo[index]['postID'])
                                .update({
                              "goodSignal": FieldValue.increment(1),
                            });
                          }
                        }
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        padding: EdgeInsets.all(8.0),
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.green[800],
                            border: Border.all(color: Colors.green, width: 1.0),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (postStatus == true) {
                            postStatus = false;
                            print('Disliked');
                            print('Liked Status: ' +
                                getGoodSignal.data()!['goodSignal'].toString());
                            if (getGoodSignal.data()!['goodSignal'] != 0) {
                              firestoreInstance
                                  .collection('posts')
                                  .doc(signalInfo[index]['postID'])
                                  .update({
                                "badSignal": FieldValue.increment(1),
                                "goodSignal": FieldValue.increment(-1)
                              });
                            } else {
                              firestoreInstance
                                  .collection('posts')
                                  .doc(signalInfo[index]['postID'])
                                  .update({
                                "badSignal": FieldValue.increment(1),
                              });
                            }
                          } else {
                            print('Disliked Already');
                          }
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 20.0),
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.red[800],
                              border: Border.all(color: Colors.red, width: 1.0),
                              shape: BoxShape.circle),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12.0,
                                  right: 10.0,
                                  bottom: 10.0,
                                  left: 9.0),
                              child: Text(
                                'X',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )))),
                ],
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          );
        });
  }

  searchUserBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        backgroundColor: Colors.grey[850],
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: searchUser,
                    onChanged: (text) {
                      setState(() {
                        text = text.toLowerCase();
                        filterUsers(text);
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[850],
                      hintText: 'Search Users',
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredNames.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        String getName = '';
                        String getImage = '';
                        for (final mapTest in filteredNames.entries) {
                          getName = mapTest.key;
                          getImage = mapTest.value;
                        }
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewProfile(
                                        userName: getName,
                                        profilePicture: getImage),
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.center,
                                    height: 35.0,
                                    width: 35.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(getImage),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      getName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('Follow Button Clicked');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ));
                      }),
                )
              ],
            );
          });
        }).whenComplete(() => {searchUser.clear(), filteredNames.clear()});
  }

  @override
  void initState() {
    super.initState();
    getUserLoginState();
    marketHours();
    checkVerifyUser();
    // getDataFromFirebase();
    getAllUsersFromFirebase();
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
          title: RichText(
            text: TextSpan(
                text: 'STOCKME',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic),
                children: <TextSpan>[
                  TextSpan(
                    text: 'UP',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0),
                  )
                ]),
          ),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {searchUserBottomSheet(context)},
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
                          margin: EdgeInsets.only(
                              top: 20.0, bottom: 25.0, left: 10.0, right: 10.0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: marketStatusCheck
                                  ? Colors.green[400]
                                  : Colors.red[400],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              marketStatusCheck
                                  ? Icon(Icons.lock_open_rounded,
                                      color: Colors.white)
                                  : Icon(Icons.lock_outline_rounded,
                                      color: Colors.white, size: 25.0),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                marketStatus,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Signals',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios_outlined,
                                  size: 14.0, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  backDate = DateTime(backDate.year,
                                      backDate.month, backDate.day - 1);
                                  signalInfo.clear();
                                  getDateAndFormat();
                                });
                              },
                            ),
                            Text(
                              formatMonthDate.format(backDate),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14.0,
                                  color: backDate.month == timeNow.month &&
                                          backDate.day == timeNow.day
                                      ? Colors.grey
                                      : dateArrow),
                              onPressed: () {
                                setState(() {
                                  if (backDate.month == timeNow.month &&
                                      backDate.day == timeNow.day) {
                                    print('Cant Go Past Today');
                                  } else {
                                    backDate = DateTime(backDate.year,
                                        backDate.month, backDate.day + 1);
                                    signalInfo.clear();
                                    getDateAndFormat();
                                  }
                                });
                              },
                            ),
                            SizedBox(width: 10.0)
                          ],
                        )),
                    Expanded(
                        child: signalInfo.length != 0
                            ? ListView.builder(
                                itemCount: signalInfo.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  var formatDate =
                                      signalInfo[index]['timePosted'];
                                  var parsedDate = DateTime.parse(
                                      formatDate.toDate().toString());

                                  formattedDate = formatter.format(parsedDate);
                                  var convertedTime = convertTime(parsedDate);

                                  return GestureDetector(
                                      onTap: () {
                                        signalBottomSheet(context, index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            bottom: 10.0),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                          fontSize: 22.0),
                                                    )),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0, right: 20.0),
                                                    child: Text(
                                                      signalInfo[index]
                                                          ['signal'],
                                                      style: TextStyle(
                                                          color: signalInfo[
                                                                          index]
                                                                      [
                                                                      'signal'] ==
                                                                  'BUY'
                                                              ? Colors
                                                                  .green[300]
                                                              : Colors.red[300],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0),
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
                                                          fontSize: 14.0),
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
                                                    '@' +
                                                        signalInfo[index]
                                                            ['user'],
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
                                })
                            : Center(
                                child: Container(
                                  child: Text(
                                    'No Signals Found',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 20.0),
                                  ),
                                ),
                              ))
                  ],
                ))),
        floatingActionButton: floatingButton());
  }
}
