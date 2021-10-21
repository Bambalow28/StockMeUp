import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';

//View News Page Widget
class StockPage extends StatefulWidget {
  @override
  _StockPage createState() => _StockPage();
}

//View News Widget State
class _StockPage extends State<StockPage> {
  String appBarTitle = "Stocks";
  int pageIndex = 1;

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
                      margin:
                          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
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
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => {print('Clicked')},
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, left: 5.0, right: 5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey[500],
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                      Color.fromRGBO(0, 0, 0, 1)
                                                          .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 4),
                                            ],
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
                                                    top: 5.0, left: 5.0),
                                                child: Text(
                                                  'APPL',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
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
                ],
              ),
            )));
  }
}
