import 'package:digital_signage_based_user_targeted_ads/pages/dashboard.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESLE Digital Signage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.pink,
      ),
      home: Dashboard(),
    );
  }
}

