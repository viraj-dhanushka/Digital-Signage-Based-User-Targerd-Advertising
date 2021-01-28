import 'package:flutter/material.dart';
import 'package:project_api/smartpower.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DIGITAL SIGNAGE'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'DIGITAL SIGNAGE',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/FaceDetect.jpg"),
                      fit: BoxFit.cover)),
            ),
            CustomListTile(
              Icons.dashboard,
              'DASHBOARD',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                ),
              },
            ),
            CustomListTile(
              Icons.image,
              'USER TARGETED SIGNAGE',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Usertarget()),
                ),
              },
            ),
            CustomListTile(
              Icons.device_hub,
              'SMART POWER SUPPLY',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Smartpower()),
                ),
              },
            ),
            CustomListTile(
              Icons.person,
              'PROFILE',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ),
              },
            ),

            /*
            CustomListTile(
              Icons.schedule,
              'SCHEDULES',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Schedules()),
                ),
              },
            ),

            CustomListTile(
              Icons.playlist_add,
              'PLAYLISTS',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Playlists()),
                ),
              },
            ),
            */
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile(this.icon, this.text, this.onTap);

  final IconData icon;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          splashColor: Colors.blueGrey,
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class Usertarget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

/*
class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 2 Page"),
      ),
      /*
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
      */
    );
  }
}

class Schedules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}


*/
