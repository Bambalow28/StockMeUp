import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:newrandomproject/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//View News Page Widget
class VerifiedHome extends StatefulWidget {
  @override
  _VerifiedHome createState() => _VerifiedHome();
}

//View News Widget State
class _VerifiedHome extends State<VerifiedHome> {
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
                            itemCount: 2,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, bottom: 10.0),
                                width: MediaQuery.of(context).size.width,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    border: Border.all(
                                        color: Colors.green, width: 1.0),
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
                                              'APPL',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.0),
                                            )),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, right: 20.0),
                                            child: Text(
                                              'BUY',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
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
                                              'BUY @ \$179.60',
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
                                            '@Bambalow28',
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
                                            '1/1/2022 10:40PM',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }))
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          child: Icon(Icons.create_rounded),
          backgroundColor: Colors.green[300],
          onPressed: () {
            Navigator.of(context).push(postSignalRoute());
          },
        ));
  }
}
