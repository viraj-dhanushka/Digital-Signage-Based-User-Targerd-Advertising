import 'package:flutter/material.dart';
import 'package:project_api/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: "Drawer App",
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E35),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey,
          shape: StadiumBorder(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
