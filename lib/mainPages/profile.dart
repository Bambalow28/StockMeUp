import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';

//View News Page Widget
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

//View News Widget State
class _ProfilePage extends State<ProfilePage> {
  String appBarTitle = "Profile";
  int pageIndex = 3;

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
          Navigator.of(context).push(stocksRoute());
          break;
        case 2:
          Navigator.of(context).push(groupChatRoute());
          break;
        case 3:
          appBarTitle = 'Profile';
      }
    });
  }

  //Logout Clicked
  logOutClicked() {
    Navigator.of(context).push(loginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.help_outline_rounded, color: Colors.grey[600]),
              onPressed: () {
                print('FAQ CLICKED');
              }),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => {logOutClicked()},
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red[300],
                ),
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
                  color: Colors.green[300],
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
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    alignment: Alignment.center,
                    height: 150.0,
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
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          children: <Widget>[
                            Text('Joshua Alanis',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              children: <Widget>[
                                Text('Verified',
                                    style: TextStyle(
                                        color: Colors.cyan[400],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 5.0),
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.blue[300], size: 20.0)
                              ],
                            )
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('10', style: TextStyle(color: Colors.white)),
                              Text('Following',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Container(
                          width: 150.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('12.5M',
                                  style: TextStyle(color: Colors.white)),
                              Text('Followers',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    'Stock Overview',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  )),
                              Expanded(
                                child: SizedBox(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                              ),
                              builder: (BuildContext context) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, left: 10.0),
                                        child: Text(
                                          'Verified User Application',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: TextField(
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                            width: 150.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.blue[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Icon(
                                    Icons.signal_cellular_alt_rounded,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                Text(
                                  "Apply to be a Signal",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Go To Premium');
                        },
                        child: Container(
                            width: 150.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Icon(
                                    Icons.attach_money_rounded,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                Text(
                                  "Premium",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            )));
  }
}
