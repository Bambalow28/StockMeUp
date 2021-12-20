import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:newrandomproject/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//View News Page Widget
class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

//View News Widget State
class _MainPage extends State<MainPage> {
  String appBarTitle = "Home";
  String marketStatus = '';
  bool marketStatusCheck = false;
  int pageIndex = 0;
  int timeMarketOpen = 0;

  //Texts for each signals
  var signalCount = [];

  final firestoreInstance = FirebaseFirestore.instance;

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
    var check = await firestoreInstance
        .collection("verifiedUsers")
        .doc("Bambalow28")
        .collection("signalPosts")
        .get();
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

  void initState() {
    super.initState();
    getUserLoginState();
    marketHours();
    getDataFromFirebase();
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
                onTap: () => {print('Save Article')},
                child: Icon(Icons.notifications_none_rounded),
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
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showMarketStatus(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        color: marketStatusCheck
                            ? Colors.green[400]
                            : Colors.red[400],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                  child: StreamBuilder(
                    stream: firestoreInstance
                        .collection("verifiedUsers")
                        .doc("Bambalow28")
                        .collection("signalPosts")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: streamSnapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => {print('Clicked')},
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10.0, left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[900],
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 1)
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 4),
                                        ],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      height: 100.0,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 15.0,
                                                    left: 10.0,
                                                    bottom: 5.0),
                                                alignment: Alignment.center,
                                                width: 80.0,
                                                height: 55.0,
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 15.0, left: 15.0),
                                                    child: Text(
                                                      'APPL',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Container(
                                                      child: Text(
                                                        'BUY' + ' @ ' + '140',
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: SizedBox()),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 15.0, right: 20.0),
                                                child: Icon(
                                                  Icons.trending_up_rounded,
                                                  color: Colors.green,
                                                  size: 55.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 20.0),
                                            alignment: Alignment.bottomRight,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  '@Bambalow28',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10.0),
                                                ),
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 10.0,
                                                  color: Colors.blue,
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    '10:00AM',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }
}
