import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newrandomproject/routes.dart';
import 'package:newrandomproject/stocksPage/portfolioInfo.dart';
import 'package:newrandomproject/stocksPage/stocksInfo.dart';
import 'package:newrandomproject/stocksPage/newsInfo.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  TextEditingController addStockName = new TextEditingController();

  late User user;
  late var userId;

  List newsArticles = [];

  TextEditingController searchStocks = TextEditingController();

  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat.yMd().add_jm();
  late String formatDate;
  String formattedDate = '';

  List watchlistNames = [];
  List cryptoHoldings = ['Bitcoin', 'Ethereum', 'Dogecoin'];

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

  //Convert News Timestamp to Ago
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

  getWatchlists() async {
    // var check = await firestoreInstance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('watchlists')
    //     .get();

    // setState(() {
    //   check.docs
    //       .map((e) => {signalNum = e.data().length, tickerInfo.add(e.data())});
    // });

    // print(check.docs.map((e) => {tickerInfo.add(e.data())}));
    var getWatchlist = await firestoreInstance
        .collection('users')
        .doc(userId)
        .collection("watchlists")
        .get();

    getWatchlist.docs.forEach((watchList) {
      setState(() {
        watchlistNames.add(watchList.id);
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
          // getTrendingStocksInfo(symbol['symbol']);
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

  //Get Information about trending stocks
  test() async {
    var yfinance = Uri.parse(
        'https://api.polygon.io/v1/meta/symbols/APPL/company?apiKey=KoqKkSeNoEgp2qToI4l3mfyE0PmEriOf');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'KoqKkSeNoEgp2qToI4l3mfyE0PmEriOf'
    };
    var res = await http.get(yfinance, headers: headers);

    var jsonResp = convert.jsonDecode(res.body);
    setState(() {
      List stockInfo = [];
      print(jsonResp);
      // fullStockName = stockInfo[0]['symbol'];
      // fiftyTwoWeekRange = '123';
      // marketCap = 123;
      // formattedMarketCap =
      //     NumberFormat.compactCurrency(decimalDigits: 1, symbol: '\$')
      //         .format(marketCap);
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
    test();
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
                onTap: () => {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      builder: (BuildContext context) {
                        return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextField(
                                    controller: searchStocks,
                                    onChanged: (text) {
                                      setState(() {
                                        text = text.toLowerCase();
                                        // filterUsers(text);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.grey[850],
                                      hintText: 'Search Stocks',
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 5.0, left: 20.0),
                                      child: Text(
                                        'Results',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    )
                                  ],
                                )
                              ],
                            ));
                      })
                },
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
                                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Trending Stocks',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PortfolioInfo(
                                        portfolioCount: watchlistNames.length,
                                        portfolioName: watchlistNames,
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
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
                                      'Portfolio',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(right: 5.0, top: 5.0),
                                    child: IconButton(
                                      icon: Icon(
                                          Icons.add_circle_outline_rounded,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 20.0,
                                                              ),
                                                              child: Text(
                                                                'Folder Name',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        24.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10.0,
                                                                      left:
                                                                          15.0,
                                                                      bottom:
                                                                          5.0),
                                                              width: 230.0,
                                                              child: TextField(
                                                                controller:
                                                                    watchlistName,
                                                                decoration:
                                                                    InputDecoration(
                                                                  filled: true,
                                                                  isDense: true,
                                                                  fillColor:
                                                                      Colors.grey[
                                                                          850],
                                                                  hintText:
                                                                      'Enter Name',
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
                                                                              Radius.circular(10.0))),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: const BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1.0),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10.0))),
                                                                ),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(),
                                                        ),
                                                        Container(
                                                          width: 80.0,
                                                          height: 80.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 25.0,
                                                                  right: 30.0),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  // border: Border.all(
                                                                  //     color: Colors
                                                                  //         .blue,
                                                                  //     width: 1.0),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Add Emoji',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(
                                                              //   height: 7.0,
                                                              // ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_reaction_rounded,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  print(
                                                                      'Add Emoji');
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                bottom: 10.0),
                                                        child: Text(
                                                          'Add Stocks',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                          color:
                                                              Colors.grey[850],
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
                                                                    bottom:
                                                                        10.0),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: TextField(
                                                              controller:
                                                                  addStockName,
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                filled: true,
                                                                fillColor:
                                                                    Colors.grey[
                                                                        850],
                                                                hintText:
                                                                    'Search',
                                                                suffixIcon:
                                                                    Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .grey,
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
                                                                            Radius.circular(10.0))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
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
                                                                    bottom:
                                                                        25.0),
                                                            width: 200.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green[800],
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 1.0),
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
                                                              children: <
                                                                  Widget>[
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
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors
                                                      .grey[850],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      30.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      30.0))),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15.0,
                                                                  left: 20.0,
                                                                  bottom: 20.0),
                                                          child: Text(
                                                            watchlistNames[
                                                                index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      cryptoHoldings
                                                                          .length,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Card(
                                                                        elevation:
                                                                            5,
                                                                        color: Colors.grey[
                                                                            800],
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10.0))),
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20.0,
                                                                            right:
                                                                                20.0,
                                                                            bottom:
                                                                                10.0),
                                                                        child:
                                                                            ExpansionTile(
                                                                          trailing:
                                                                              Text(
                                                                            '0.000123BTC',
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 10.0,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          title:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                // margin: EdgeInsets.only(left: 10.0),
                                                                                width: 33.0,
                                                                                height: 33.0,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(left: 15.0),
                                                                                  child: RichText(
                                                                                    text: TextSpan(text: cryptoHoldings[index], style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold), children: <TextSpan>[
                                                                                      TextSpan(text: ' BTC', style: TextStyle(color: Colors.grey, fontSize: 12.0))
                                                                                    ]),
                                                                                  )),
                                                                              Expanded(
                                                                                child: SizedBox(),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  'Date',
                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                                                                ),
                                                                                Expanded(
                                                                                  child: SizedBox(),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    'Holdings',
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: SizedBox(),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    'Price',
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                                height: 80.0,
                                                                                child: ListView.builder(
                                                                                    itemCount: 2,
                                                                                    scrollDirection: Axis.vertical,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return Container(
                                                                                          margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                                                                                          padding: EdgeInsets.only(left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                                                                                          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(right: 10.0),
                                                                                                child: Text(
                                                                                                  '02/11/22',
                                                                                                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: SizedBox(),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(right: 10.0),
                                                                                                child: Text(
                                                                                                  '0.00050BTC',
                                                                                                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: SizedBox(),
                                                                                              ),
                                                                                              Text(
                                                                                                '\$10.00',
                                                                                                style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                                                              ),
                                                                                            ],
                                                                                          ));
                                                                                    }))
                                                                          ],
                                                                        ));
                                                                  }),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            // Container(
                                            //                                   width: MediaQuery.of(context).size.width,
                                            //                                   height: 50.0,
                                            //                                   child: Row(
                                            //                                     children: <Widget>[
                                            //                                       Container(
                                            //                                         margin: EdgeInsets.only(left: 10.0),
                                            //                                         width: 33.0,
                                            //                                         height: 33.0,
                                            //                                         decoration: BoxDecoration(
                                            //                                           shape: BoxShape.circle,
                                            //                                           color: Colors.grey,
                                            //                                         ),
                                            //                                       ),
                                            //                                       Padding(
                                            //                                           padding: EdgeInsets.only(left: 15.0),
                                            //                                           child: RichText(
                                            //                                             text: TextSpan(text: cryptoHoldings[index], style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold), children: <TextSpan>[
                                            //                                               TextSpan(text: ' BTC', style: TextStyle(color: Colors.grey, fontSize: 12.0))
                                            //                                             ]),
                                            //                                           )),
                                            //                                       Expanded(
                                            //                                         child: SizedBox(),
                                            //                                       ),
                                            //                                       Padding(
                                            //                                         padding: EdgeInsets.only(right: 20.0),
                                            //                                         child: Text(
                                            //                                           '0.000123BTC',
                                            //                                           style: TextStyle(color: Colors.green, fontSize: 12.0, fontWeight: FontWeight.bold),
                                            //                                         ),
                                            //                                       )
                                            //                                     ],
                                            //                                   ),
                                            //                                 ),
                                            child: Container(
                                                width: 130.0,
                                                margin: EdgeInsets.only(
                                                    left: 10.0, bottom: 15.0),
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          unselectedWidgetColor:
                                                              Colors.white),
                                                  child: Card(
                                                      color: Colors.grey[100]!
                                                          .withOpacity(0.1),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors
                                                                .grey[700]!,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0),
                                                            child: Icon(
                                                              Icons
                                                                  .attach_money_rounded,
                                                              color:
                                                                  Colors.green,
                                                              size: 80.0,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: Text(
                                                                watchlistNames[
                                                                    index],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ))
                                                        ],
                                                      )),
                                                )));
                                      }))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(left: 15.0, top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Latest News',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          getNews();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.blue[300],
                                          size: 20.0,
                                        ))
                                  ],
                                )),
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
                                  var convertedTime = convertTime(parsedDate);

                                  // formattedDate = formatter.format(parsedDate);

                                  var newsImage =
                                      newsArticles[index]['urlToImage'];

                                  return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0))),
                                            backgroundColor: Colors.grey[850],
                                            builder: (BuildContext context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.0,
                                                        left: 20.0,
                                                        right: 20.0,
                                                        bottom: 5.0),
                                                    child: Text(
                                                      newsArticles[index]
                                                          ['title'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.0,
                                                                bottom: 10.0),
                                                        child: Text(
                                                          convertedTime,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10.0),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 150.0,
                                                      margin: EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: newsImage == null
                                                            ? Image.asset(
                                                                'lib/src/images/noImagePhoto.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                alignment:
                                                                    FractionalOffset(
                                                                        1,
                                                                        0.85),
                                                              )
                                                            : Image.network(
                                                                newsArticles[
                                                                        index][
                                                                    'urlToImage'],
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                return Image.network(
                                                                    newsArticles[
                                                                            index]
                                                                        [
                                                                        'urlToImage'],
                                                                    fit: BoxFit
                                                                        .cover);
                                                              }),
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5.0,
                                                        left: 20.0,
                                                        right: 20.0),
                                                    child: Divider(
                                                      color: Colors.grey,
                                                      height: 5.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.0,
                                                        top: 5.0,
                                                        right: 20.0),
                                                    child: Text(
                                                      newsArticles[index][
                                                                  'description'] ==
                                                              null
                                                          ? 'Description Not Available'
                                                          : newsArticles[index]
                                                              ['description'],
                                                      style: TextStyle(
                                                          color: newsArticles[
                                                                          index]
                                                                      [
                                                                      'description'] ==
                                                                  null
                                                              ? Colors.grey
                                                              : Colors.white,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      NewsInfo(
                                                                        newsUrl:
                                                                            newsArticles[index]['url'],
                                                                      ))).then(
                                                          (value) => {
                                                                Navigator.pop(
                                                                    context)
                                                              });
                                                    },
                                                    child: Container(
                                                        width: 150.0,
                                                        height: 30.0,
                                                        margin: EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 25.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.blue[900],
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  6.0),
                                                          child: Text(
                                                            'Article Link',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              );
                                            });
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
                                              color: Colors.grey[100]!
                                                  .withOpacity(0.1),
                                              border: Border.all(
                                                  color: Colors.grey[700]!,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                      width: 100.0,
                                                      height: 100.0,
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 10.0,
                                                          right: 5.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: newsImage == null
                                                            ? Image.asset(
                                                                'lib/src/images/noImagePhoto.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                newsArticles[
                                                                        index][
                                                                    'urlToImage'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      )),
                                                  Flexible(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: AutoSizeText(
                                                          newsArticles[index]
                                                              ['title'],
                                                          overflow: TextOverflow
                                                              .visible,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          maxLines: 5,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    bottom:
                                                                        5.0),
                                                            child: Text(
                                                              newsArticles[
                                                                          index]
                                                                      ['source']
                                                                  ['name'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[200],
                                                                fontSize: 12.0,
                                                              ),
                                                            )),
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
                                                              convertedTime,
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
