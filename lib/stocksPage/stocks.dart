import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newrandomproject/routes.dart';
import 'package:newrandomproject/stocksPage/stocksInfo.dart';
import 'package:newrandomproject/stocksPage/newsInfo.dart';

//View News Page Widget
class StockPage extends StatefulWidget {
  @override
  _StockPage createState() => _StockPage();
}

//View News Widget State
class _StockPage extends State<StockPage> {
  String appBarTitle = "Stocks";
  int pageIndex = 1;

  List getStockNames = [];
  List getStockPrice = [];
  TextEditingController watchlistName = new TextEditingController();

  late User user;
  late var userId;

  List newsArticles = [];

  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat.yMd().add_jm();
  late String formatDate;
  String formattedDate = '';

  List watchlistNames = [];

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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
          appBarTitle = 'Stocks';
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

  //Get Logged In User Info
  Future getUserInfo() async {
    setState(() {
      user = auth.currentUser!;
      userId = user.uid;
    });
  }

  getWatchlists() async {
    // await firestoreInstance
    //     .collection('users')
    //     .doc(userId)
    //     .collection("watchlists")
    //     .get()
    //     .then((value) => value.docs
    //         .map((DocumentSnapshot documentSnapshot) =>
    //             {watchlistNames.add(documentSnapshot.id)})
    //         .toList());
    firestoreInstance
        .collection('users')
        .doc(userId)
        .collection("watchlists")
        .snapshots()
        .listen((value) {
      setState(() {
        value.docs
            .map((DocumentSnapshot documentSnapshot) =>
                {watchlistNames.add(documentSnapshot.id)})
            .toList();
      });
    });
  }

  //Get Trending Stocks From Yahoo Finance API
  getTrendingStocks() async {
    var yahooFinance = Uri.parse('https://yfapi.net/v1/finance/trending/US');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'vcsOn5TuqZ5vQKg71lSFdaYSylw4k06O9UCCBju9'
    };
    var res = await http.get(yahooFinance, headers: headers);

    var jsonResponse = convert.jsonDecode(res.body);
    setState(() {
      List trendingStocks = [];
      trendingStocks = jsonResponse['finance']['result'];
      trendingStocks.forEach((element) {
        List stockNames = [];
        stockNames = element['quotes'];
        stockNames.forEach((symbol) {
          getStockNames.add(symbol['symbol']);
          getTrendingStocksInfo(symbol['symbol']);
        });
      });
    });
  }

  //Get Information about trending stocks
  getTrendingStocksInfo(String ticker) async {
    var yfinance = Uri.parse(
        'https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=$ticker');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'vcsOn5TuqZ5vQKg71lSFdaYSylw4k06O9UCCBju9'
    };
    var res = await http.get(yfinance, headers: headers);

    var jsonResp = convert.jsonDecode(res.body);
    setState(() {
      List stockInfo = [];
      stockInfo = jsonResp['quoteResponse']['result'];
      getStockPrice.add(stockInfo[0]['postMarketPrice']);
    });
  }

  //Get Information about Top Headlines in the US
  getNews() async {
    var newsApi = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&sapiKey');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': '811c1bd94fd5401f97c4c828ecde1cd6'
    };

    var resp = await http.get(newsApi, headers: headers);

    var jsonResp = convert.jsonDecode(resp.body);
    setState(() {
      newsArticles = jsonResp['articles'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    // getTrendingStocks();
    getNews();
    getWatchlists();
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
          leading: IconButton(
            icon: Icon(Icons.bar_chart_rounded),
            onPressed: () {
              print('Check Stocks');
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {print('Save Article')},
                child: Icon(Icons.search_rounded),
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
                  color: Colors.green[300],
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
        body: SingleChildScrollView(
            child: GestureDetector(
                onTap: () =>
                    {FocusScope.of(context).requestFocus(new FocusNode())},
                child: Container(
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
                          margin: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 130.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Text(
                                  'Trending',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: getStockNames.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StocksInfo(
                                                              stockName:
                                                                  getStockNames[
                                                                      index])))
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 5.0,
                                                  right: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              width: 130.0,
                                              height: 60.0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0, left: 10.0),
                                                    child: Text(
                                                      getStockNames[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.0,
                                                                left: 10.0),
                                                        child: Text(
                                                          '35.90',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.0,
                                                                  left: 5.0),
                                                          child: Icon(
                                                              Icons
                                                                  .trending_down_rounded,
                                                              color: Colors
                                                                  .red[400])),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin:
                            EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 5.0),
                                  child: Text(
                                    'Watchlist',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(right: 10.0, top: 5.0),
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle_outline_rounded,
                                        color: Colors.blue[300]),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.grey[900],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0))),
                                          context: context,
                                          builder: (context) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20.0,
                                                                left: 15.0),
                                                        child: Text(
                                                          'Add a Watchlist',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 24.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 10.0,
                                                            bottom: 5.0),
                                                        width: 300.0,
                                                        child: TextField(
                                                          controller:
                                                              watchlistName,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            isDense: true,
                                                            fillColor: Colors
                                                                .grey[850],
                                                            hintText:
                                                                'Enter Watchlist Name',
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.0),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.0),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0))),
                                                          ),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 10.0),
                                                      child: Text(
                                                        'Add Stocks',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20,
                                                    height: 230.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[850],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20.0,
                                                                  left: 20.0,
                                                                  right: 20.0,
                                                                  bottom: 10.0),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextField(
                                                            controller:
                                                                watchlistName,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .grey[850],
                                                              hintText:
                                                                  'Search',
                                                              suffixIcon: Icon(
                                                                Icons.search,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0))),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0))),
                                                            ),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        try {
                                                          setState(() {
                                                            firestoreInstance
                                                                .collection(
                                                                    'users')
                                                                .doc(userId)
                                                                .collection(
                                                                    'watchlists')
                                                                .doc(
                                                                    watchlistName
                                                                        .text)
                                                                .set({
                                                              "high": 'test'
                                                            });
                                                          });
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20.0),
                                                          width: 200.0,
                                                          height: 40.0,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green[300],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30.0))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Create Watchlist',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          )))
                                                ],
                                              )).whenComplete(
                                          () => {watchlistName.clear()});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: watchlistNames.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                                unselectedWidgetColor:
                                                    Colors.white),
                                            child: Card(
                                              color: Colors.grey[800],
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ExpansionTile(
                                                iconColor: Colors.white,
                                                title: Text(
                                                    watchlistNames[index],
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: Expanded(
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        2,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .vertical,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Container(
                                                                        child:
                                                                            Text(
                                                                          'APPL',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                    }))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
                        width: MediaQuery.of(context).size.width - 20,
                        // height: 100.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 15.0, top: 10.0),
                              child: Text(
                                'News',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: newsArticles.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  formatDate =
                                      newsArticles[index]['publishedAt'];
                                  var parsedDate = DateTime.parse(formatDate);

                                  formattedDate = formatter.format(parsedDate);

                                  // print(formattedDate);
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NewsInfo(
                                                      newsUrl:
                                                          newsArticles[index]
                                                              ['url'],
                                                    )));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              bottom: 10.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300]!
                                                  .withOpacity(0.1),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: Row(
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width: 100.0,
                                                      height: 100.0,
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 15.0,
                                                          right: 5.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          newsArticles[index]
                                                              ['urlToImage'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 5.0),
                                                      child: Text(
                                                        newsArticles[index]
                                                            ['source']['name'],
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Text(
                                                          newsArticles[index]
                                                              ['title'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: SizedBox(),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10.0,
                                                                    bottom:
                                                                        5.0),
                                                            child: Text(
                                                              formattedDate,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12.0,
                                                              ),
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )));
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
