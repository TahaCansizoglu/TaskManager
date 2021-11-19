import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
import 'package:task_management/core/constants/theme.dart';

final tab = ColorfulTabBar(
  tabs: [
    TabItem(
      color: lightblue,
      title: const Text(
        "Daily",
      ),
    ),
    TabItem(
      color: lightred,
      title: const Text(
        "Weekly",
      ),
    ),
    TabItem(
      color: lightorange,
      title: const Text(
        "Monthly",
      ),
    ),
  ],
  indicatorHeight: 6,
  verticalTabPadding: 6.0,
  labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  selectedHeight: 48,
  unselectedHeight: 40,
);
ThemeData myTheme = ThemeData(
  backgroundColor: Colors.blueGrey[100],
  primaryColor: const Color.fromRGBO(65, 87, 223, 1),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 32,
      height: 1.1,
      fontWeight: FontWeight.w600,
      color: Colors.grey[700],
    ),
    headline3: TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: Colors.grey[700],
    ),
    headline5: TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.1,
      color: Colors.grey[700],
    ),
    headline6: TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.grey[700],
    ),
    bodyText2: const TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 0.6,
      color: Colors.blue,
    ),
    bodyText1: TextStyle(
      fontFamily: "Baloo Tammudu 2",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[700],
    ),
  ),
);
