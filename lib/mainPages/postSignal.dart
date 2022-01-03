import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

//View News Page Widget
class postSignal extends StatefulWidget {
  @override
  _postSignal createState() => _postSignal();
}

//View News Widget State
class _postSignal extends State<postSignal> {
  String appBarTitle = "Post Signal";
  bool buy = false;
  bool sell = false;
  String signal = '';
  String signalMessage = 'Send Signal';

  bool publicPost = false;
  bool privatePost = false;
  late String postStatus;

  DateTime timeNow = DateTime.now();
  DateFormat formatter = DateFormat.yMd().add_jm();
  String formattedDate = '';

  TextEditingController tickerSymbol = new TextEditingController();
  TextEditingController signalPost = new TextEditingController();
  TextEditingController messageTime = new TextEditingController();

  //Create Firebase Instance
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userId;

  int signalNum = 0;
  List tickerInfo = [];

  signalData() async {
    var check = await firestoreInstance
        .collection('posts')
        .doc('public')
        .collection(userId)
        .get();

    setState(() {
      check.docs
          .map((e) => {signalNum = e.data().length, tickerInfo.add(e.data())});
    });

    print(check.docs.map((e) => {tickerInfo.add(e.data())}));
  }

  @override
  void initState() {
    super.initState();
    User user = auth.currentUser!;
    userId = user.uid;
    signalData();
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
        ),
        body: GestureDetector(
            onTap: () => {FocusScope.of(context).requestFocus(new FocusNode())},
            child: Container(
                height: MediaQuery.of(context).size.height,
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
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                      width: 300.0,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: tickerSymbol,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(45, 45, 45, 1),
                          hintText: 'Ticker Symbol',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: signalPost,
                        maxLines: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(45, 45, 45, 1),
                          hintText: 'Signal',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => {
                              setState(() {
                                if (buy != true) {
                                  buy = true;
                                  signal = 'BUY';
                                }
                                sell = false;
                              })
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, left: 10.0, right: 5.0),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: buy
                                        ? Colors.green[300]
                                        : Colors.grey[850],
                                    border: Border.all(
                                        color: Colors.green[300]!, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'BUY',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => {
                              setState(() {
                                if (sell != true) {
                                  sell = true;
                                  signal = 'SELL';
                                }

                                buy = false;
                              }),
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, right: 10.0, left: 10.0),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: sell
                                        ? Colors.red[300]
                                        : Colors.grey[850],
                                    border: Border.all(
                                        color: Colors.red[300]!, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'SELL',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (privatePost = true) {
                                  publicPost = true;
                                  postStatus = 'Public';
                                  privatePost = false;
                                }
                              });
                            },
                            child: Text(
                              'Public',
                              style: TextStyle(
                                  color:
                                      publicPost ? Colors.blue : Colors.white,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          )),
                          VerticalDivider(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                privatePost = true;

                                if (publicPost = true) {
                                  privatePost = true;
                                  postStatus = 'Private';
                                  publicPost = false;
                                }
                              });
                            },
                            child: Text(
                              'Private',
                              style: TextStyle(
                                  color:
                                      privatePost ? Colors.blue : Colors.white,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width - 80,
                          margin: EdgeInsets.only(top: 20.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Signal History',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: tickerInfo.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var formatDate =
                                            tickerInfo[index]['timePosted'];
                                        var parsedDate = DateTime.parse(
                                            formatDate.toDate().toString());

                                        formattedDate =
                                            formatter.format(parsedDate);

                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 10.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 10.0),
                                                      child: Text(
                                                        tickerInfo[index]
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
                                                          top: 10.0,
                                                          right: 20.0),
                                                      child: Text(
                                                        tickerInfo[index]
                                                            ['signal'],
                                                        style: TextStyle(
                                                            color: tickerInfo[
                                                                            index]
                                                                        [
                                                                        'signal'] ==
                                                                    'BUY'
                                                                ? Colors
                                                                    .green[300]
                                                                : Colors
                                                                    .red[300],
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
                                                        tickerInfo[index]
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
                                                        left: 10.0,
                                                        bottom: 5.0),
                                                    child: Text(
                                                      'Public',
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
                                                        right: 10.0,
                                                        bottom: 5.0),
                                                    child: Text(
                                                      formattedDate,
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
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        signalMessage = 'Posting...';
                        firestoreInstance
                            .collection("posts")
                            .doc("public")
                            .collection(userId)
                            .doc(timeNow.toString())
                            .set({
                          "tickerSymbol": tickerSymbol.text,
                          "signalPost": signalPost.text,
                          "signal": signal,
                          "postStatus": postStatus,
                          "timePosted": timeNow
                        }).then((value) => Timer(Duration(seconds: 1), () {
                                  setState(() {
                                    signalMessage = "Successfully Posted";
                                  });
                                }));
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 15.0, right: 20.0, left: 20.0, bottom: 40.0),
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.green[700],
                              border:
                                  Border.all(color: Colors.green, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              signalMessage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ],
                ))));
  }
}
