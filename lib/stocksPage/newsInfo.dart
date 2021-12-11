import 'package:flutter/material.dart';
import 'package:newrandomproject/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

//View News Page Widget
class NewsInfo extends StatefulWidget {
  @override
  _NewsInfo createState() => _NewsInfo();
  String newsUrl;
  NewsInfo({Key? key, required this.newsUrl}) : super(key: key);
}

//View News Widget State
class _NewsInfo extends State<NewsInfo> {
  String appBarTitle = "News Info";
  int pageIndex = 2;

  late WebViewController _webViewController;

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
          appBarTitle = 'News Info';
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
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () {
                  _webViewController.reload();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Icon(Icons.bookmark_border_rounded, color: Colors.white),
                onPressed: () {
                  print('Save Article');
                },
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
                  color: Colors.green[300],
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
                child: WebView(
                  onWebViewCreated: (controller) {
                    setState(() {
                      _webViewController = controller;
                    });
                  },
                  initialUrl: widget.newsUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ))));
  }
}
