import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newrandomproject/routes.dart';

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

  //Check if Time is Between Market Hours
  marketHours() {
    DateFormat dateFormat = new DateFormat.Hm();

    DateTime marketOpen = dateFormat.parse("9:30");
    DateTime marketClose = dateFormat.parse("16:00");

    DateTime now = DateTime.now();
    now = DateTime.parse(now.toString());

    if (now.isAfter(marketOpen) && now.isBefore(marketClose)) {
      print("Market is Open");
      marketStatus = "Market Open";
      marketStatusCheck = true;
    } else {
      print("Market is Closed");
      marketStatus = "Market Closed";
      marketStatusCheck = false;
    }
  }

  void initState() {
    super.initState();
    marketHours();
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
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: Text(
                    marketStatus,
                    style: TextStyle(
                        color: marketStatusCheck
                            ? Colors.green[400]
                            : Colors.red[400],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => {print('Clicked')},
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 20.0, left: 10.0, right: 10.0),
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
                                width: MediaQuery.of(context).size.width - 30,
                                height: 85.0,
                                child: Row(
                                  children: <Widget>[
                                    Container(
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
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 5.0),
                                          child: Text(
                                            'Joshua Alanis',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      'BUY',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'AMC',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
            )));
  }
}
