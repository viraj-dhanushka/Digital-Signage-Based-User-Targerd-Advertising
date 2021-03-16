import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_api/models/user.dart';
import 'package:project_api/screens/edit_profile.dart';
import 'package:project_api/screens/loginpage.dart';
import 'package:project_api/widgets/header.dart';
import 'package:project_api/widgets/progress.dart';
import 'package:project_api/widgets/rounded_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  final String currentUserId = currentUserWithInfo?.id;

  bool homeNumber = false;
  bool street1 = false;
  bool street2 = false;
  bool city = false;
  bool contactNum = false;

  buildProfile() {
    return FutureBuilder(
      future: userRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        // setState(() {
        if (user.homeNumber.isNotEmpty) homeNumber = true;
        if (user.street1.isNotEmpty) street1 = true;
        if (user.street2.isNotEmpty) street2 = true;
        if (user.city.isNotEmpty) city = true;
        if (user.contactNum.isNotEmpty) contactNum = true;
        // });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // padding: EdgeInsets.all(5.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                bottom: 20.0,
              ),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Name :",
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                  child: Text(user.name,
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                  child: Text(
                    "Shop Address :",
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                  ),
                ),
                homeNumber
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text(user.homeNumber,
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text("--------",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                street1
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text(user.street1,
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text("--------",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                street2
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text(user.street2,
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text("--------",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                city
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text(user.city,
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text("--------",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                  child: Text(
                    "Contact Number :",
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                  ),
                ),
                contactNum
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text(user.contactNum,
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                        child: Text("--------",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfile(currentUserId: widget.profileId)));
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedUserId');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName("/phoneAuth"));
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: RoundedButton(
              title: 'Logout',
              minWidth: 75.0,
              height: 25.0,
              color: Colors.redAccent,
              onPressed: _signOut,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: RoundedButton(
              title: 'Edit',
              minWidth: 75.0,
              height: 25.0,
              color: Theme.of(context).accentColor,
              onPressed: editProfile,
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 1,
        width: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: header(context, titleText: "My Profile"),
      body: ListView(
        children: <Widget>[
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              //   width: 250.0,
              //   height: 250.0,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage('assets/images/delivery_cab.jpg'),
              //         fit: BoxFit.cover),
              //   ),
              // ),

              buildProfile(),
              buildProfileButton(),
            ],
          ),
        ],
      ),
    );
  }
}
