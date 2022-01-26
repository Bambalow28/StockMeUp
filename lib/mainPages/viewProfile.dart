import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';

//View News Page Widget
class ViewProfile extends StatefulWidget {
  @override
  _ViewProfile createState() => _ViewProfile();

  String userName;
  String profilePicture;
  ViewProfile({Key? key, required this.userName, required this.profilePicture})
      : super(key: key);
}

//View News Widget State
class _ViewProfile extends State<ViewProfile> {
  int pageIndex = 0;

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
          Navigator.of(context).push(profileRoute());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Search'),
            backgroundColor: const Color.fromRGBO(38, 38, 38, 1.0),
            automaticallyImplyLeading: true),
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
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
                  widget.profilePicture != ''
                      ? Container(
                          margin: EdgeInsets.only(top: 40.0),
                          alignment: Alignment.center,
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                widget.profilePicture,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 40.0),
                          alignment: Alignment.center,
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100.0,
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
                            Text(widget.userName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                            // Row(
                            //   children: <Widget>[
                            //     userVerified
                            //         ? Text('Verified',
                            //             style: TextStyle(
                            //                 color: Colors.cyan[400],
                            //                 fontSize: 16.0,
                            //                 fontWeight: FontWeight.bold))
                            //         : Text('Not Verified',
                            //             style: TextStyle(
                            //                 color: Colors.grey[700],
                            //                 fontSize: 16.0,
                            //                 fontWeight: FontWeight.bold)),
                            //     SizedBox(width: 3.0),
                            //     userVerified
                            //         ? Icon(Icons.check_circle_rounded,
                            //             color: Colors.blue[300], size: 16.0)
                            //         : Container()
                            //   ],
                            // )
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('0', style: TextStyle(color: Colors.white)),
                              Text('Following',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        )),
                        VerticalDivider(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        Expanded(
                            child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('0', style: TextStyle(color: Colors.white)),
                              Text('Followers',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 40.0,
                            margin: EdgeInsets.only(left: 20.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Text(
                              'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        child: Container(
                            width: 70.0,
                            height: 40.0,
                            margin: EdgeInsets.only(right: 20.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Icon(Icons.mail_outline_rounded,
                                color: Colors.grey[800])),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
