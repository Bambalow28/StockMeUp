import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:newrandomproject/routes.dart';

//View News Page Widget
class StocksInfo extends StatefulWidget {
  @override
  _StocksInfo createState() => _StocksInfo();

  String stockName;
  StocksInfo({Key? key, required this.stockName}) : super(key: key);
}

//View News Widget State
class _StocksInfo extends State<StocksInfo> {
  String appBarTitle = "Stocks";
  int pageIndex = 1;

  String fullStockName = '';

  List getStockPrice = [];

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
      fullStockName = stockInfo[0]['displayName'];
    });
  }

  @override
  void initState() {
    super.initState();
    getTrendingStocksInfo(widget.stockName);
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
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10.0),
                    child: Text(
                      fullStockName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                width: MediaQuery.of(context).size.width - 20,
                height: 250.0,
                decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  print('Thumbs Up');
                                },
                                child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Colors.green[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Icon(
                                                Icons.thumb_up_alt_rounded,
                                                color: Colors.white)),
                                        Expanded(
                                          child: Text('1000',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ))),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    print('Thumbs Down');
                                  },
                                  child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red[300],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Icon(
                                                  Icons.thumb_down_alt_rounded,
                                                  color: Colors.white)),
                                          Expanded(
                                            child: Text('500',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      ))))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                            child: Container(
                          height: 80.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ))
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                            child: Container(
                          height: 80.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}