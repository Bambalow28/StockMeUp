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

  List cryptoHoldings = ['Bitcoin', 'Ethereum', 'Solana'];

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
                                          right: 5.0, top: 10.0),
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
                                        color: Colors.red[300],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                itemCount: cryptoHoldings.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      Card(
                                          elevation: 5,
                                          color: Colors.grey[800],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          margin: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: 10.0),
                                          child: ExpansionTile(
                                            trailing: Text(
                                              '0.000123BTC',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            title: Row(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                          text: cryptoHoldings[
                                                              index],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: ' BTC',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0))
                                                          ]),
                                                    )),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Date',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Holdings',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Price',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                  height: 50.0,
                                                  child: ListView.builder(
                                                      itemCount: 2,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    right: 10.0,
                                                                    bottom:
                                                                        5.0),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    top: 8.0,
                                                                    right: 10.0,
                                                                    bottom:
                                                                        8.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[800],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0))),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10.0),
                                                                  child: Text(
                                                                    '02/11/22',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10.0),
                                                                  child: Text(
                                                                    '0.00050BTC',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(),
                                                                ),
                                                                Text(
                                                                  '\$10.00',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                              ],
                                                            ));
                                                      }))
                                            ],
                                          ))
                                    ],
                                  );
                                },
                              ))
                            ],
                          ),
                        );
                      })),
            )));
  }
}
