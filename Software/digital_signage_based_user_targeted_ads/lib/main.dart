import 'package:flutter/material.dart';
import 'package:project_api/services/authservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "ESLE",
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E35),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        accentColor: Colors.blueGrey,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey,
          shape: StadiumBorder(),
        ),
      ),
      debugShowCheckedModeBanner: false,      
      home: AuthService().handleAuth(),

      // initialRoute: Home.id,
      // routes: {
      //   Home.id: (context) => Home(),
      //   // Profile.id: (context) => Profile(),
      // },

    ),
  );
}
