import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//View News Page Widget
class postSignal extends StatefulWidget {
  @override
  _postSignal createState() => _postSignal();
}

//View News Widget State
class _postSignal extends State<postSignal> {
  String appBarTitle = "Post Signal";
  bool buy = false;
  bool addMore = false;
  bool sell = false;
  String signal = '';

  TextEditingController tickerSymbol = new TextEditingController();
  TextEditingController signalPost = new TextEditingController();
  TextEditingController messageTime = new TextEditingController();

  //Create Firebase Instance
  final firestoreInstance = FirebaseFirestore.instance;

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

                                addMore = false;
                                sell = false;
                              })
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, left: 10.0, right: 5.0),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.green[300],
                                    border: Border.all(
                                        color: buy
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2.0),
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
                                if (addMore != true) {
                                  addMore = true;
                                  signal = 'ADD MORE';
                                }

                                buy = false;
                                sell = false;
                              })
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, left: 5.0, right: 5.0),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.orange[300],
                                    border: Border.all(
                                        color: addMore
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ADD MORE',
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
                                addMore = false;
                              }),
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, right: 10.0, left: 10.0),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    border: Border.all(
                                        color: sell
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2.0),
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
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Signal History',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        firestoreInstance
                            .collection("verifiedUsers")
                            .doc("Bambalow28")
                            .collection("signalPosts")
                            .doc('post_02')
                            .set({
                          "tickerSymbol": tickerSymbol.text,
                          "signalPost": signalPost.text,
                          "signal": signal,
                          "timePosted": '00:00 AM'
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 15.0, right: 20.0, left: 20.0, bottom: 40.0),
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Send Signal',
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
