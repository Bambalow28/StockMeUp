import 'package:flutter/material.dart';
import 'package:newrandomproject/main.dart';
import 'package:newrandomproject/mainPages/home.dart';
import 'package:newrandomproject/signupPage/signup.dart';
import 'package:newrandomproject/mainPages/stocks.dart';
import 'package:newrandomproject/mainPages/groupChats.dart';
import 'package:newrandomproject/mainPages/profile.dart';
import 'package:newrandomproject/mainPages/postSignal.dart';

//Transition to Login Page
Route loginRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        LoginPage(title: "Stock Me Up"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

//Transition to Home Page
Route homeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

//Transition To Stocks Page
Route stocksRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => StockPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

//Transition To Group Chats Page
Route groupChatRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => GroupChatPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

//Transition To Profile Page
Route profileRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

//Transition To Post Signal Page
Route postSignalRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => postSignal(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
