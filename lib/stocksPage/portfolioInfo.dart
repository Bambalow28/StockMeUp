import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

//View News Page Widget
class PortfolioInfo extends StatefulWidget {
  @override
  _PortfolioInfo createState() => _PortfolioInfo();

  int portfolioCount;
  List portfolioName;
  PortfolioInfo(
      {Key? key, required this.portfolioCount, required this.portfolioName})
      : super(key: key);
}

//View News Widget State
class _PortfolioInfo extends State<PortfolioInfo> {
  String appBarTitle = "My Portfolio";
  int pageIndex = 2;

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
          automaticallyImplyLeading: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Colors.blue[300],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[],
                          );
                        });
                  }),
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
            onTap: () => {FocusScope.of(context).unfocus()},
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
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
                  child: ListView.builder(
                      itemCount: widget.portfolioCount,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                          margin: EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 20.0),
                                    child: Text(
                                      widget.portfolioName[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('Test');
                                    },
                                    child: Container(
                                      height: 35.0,
                                      margin: EdgeInsets.only(
                                          right: 20.0, top: 10.0),
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      })),
            )));
  }
}
