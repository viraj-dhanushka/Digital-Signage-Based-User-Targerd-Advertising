import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:project_api/models/user.dart';
import 'package:project_api/screens/loginpage.dart';
import 'package:project_api/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dispNameController = TextEditingController();
  TextEditingController dispAgeController = TextEditingController();
  TextEditingController homeNumberController = TextEditingController();
  TextEditingController streetName1Controller = TextEditingController();
  TextEditingController streetName2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController contactNumController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _dispNameValid = true;
  bool _ageValid = true;
  bool _hNumValid = true;
  bool _str1Valid = true;
  bool _str2Valid = true;
  bool _cityValid = true;
  bool _contactNumValid = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await userRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    dispNameController.text = user.name;
    dispAgeController.text = user.age;
    homeNumberController.text = user.homeNumber;
    streetName1Controller.text = user.street1;
    streetName2Controller.text = user.street2;
    cityController.text = user.city;
    contactNumController.text = user.contactNum;

    setState(() {
      isLoading = false;
    });
  }

  Column buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: dispNameController,
          decoration: InputDecoration(
            hintText: "Update Your Name",
            errorText: _dispNameValid ? null : "Enter a valid name",
          ),
        )
      ],
    );
  }

  Column buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Age",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: dispAgeController,
          decoration: InputDecoration(
            hintText: "Update Your Age",
            errorText: _ageValid ? null : "Enter a valid age",
          ),
        )
      ],
    );
  }

  Column buildHNumField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Shop Number",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: homeNumberController,
          decoration: InputDecoration(
            hintText: "Update Shop Number",
            errorText: _hNumValid ? null : "Enter a valid Shop Number",
          ),
        )
      ],
    );
  }

  Column buildStr1Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Street Name 1",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: streetName1Controller,
          decoration: InputDecoration(
            hintText: "Update Street Name 1",
            errorText: _str1Valid ? null : "Enter a valid Street Name",
          ),
        )
      ],
    );
  }

  Column buildStr2Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Street Name 2",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: streetName2Controller,
          decoration: InputDecoration(
            hintText: "Update Street Name 2",
            errorText: _str2Valid ? null : "Enter a valid Street Name",
          ),
        )
      ],
    );
  }

  Column buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "City",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            hintText: "Update City",
            errorText: _cityValid ? null : "Enter a valid City",
          ),
        )
      ],
    );
  }

  Column buildContactNumField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Contact Number",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: contactNumController,
          decoration: InputDecoration(
            errorText: _contactNumValid ? null : "Enter a valid Contact Number",
            hintText: "Update Contact Number",
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      dispNameController.text.trim().length < 3 ||
              dispNameController.text.isEmpty
          ? _dispNameValid = false
          : _dispNameValid = true;

      dispAgeController.text.trim().length > 2 ||
              dispAgeController.text.isEmpty ||
              int.parse(dispAgeController.text.trim()) < 18
          ? _ageValid = false
          : _ageValid = true;

      homeNumberController.text.trim().length < 3 ||
              homeNumberController.text.isEmpty
          ? _hNumValid = false
          : _hNumValid = true;

      streetName1Controller.text.trim().length < 3 ||
              streetName1Controller.text.isEmpty
          ? _str1Valid = false
          : _str1Valid = true;

      streetName2Controller.text.trim().length < 3 ||
              streetName2Controller.text.isEmpty
          ? _str2Valid = false
          : _str2Valid = true;
      cityController.text.trim().length < 3 || cityController.text.isEmpty
          ? _cityValid = false
          : _cityValid = true;

      contactNumController.text.trim().length != 10 ||
              contactNumController.text.contains(RegExp(r'[^0-9]')) ||
              !contactNumController.text.startsWith('07')
          ? _contactNumValid = false
          : _contactNumValid = true;
    });

    if (_dispNameValid &&
        _ageValid &&
        _hNumValid &&
        _str1Valid &&
        _str2Valid &&
        _cityValid &&
        _contactNumValid) {
      userRef.document(widget.currentUserId).updateData({
        "name": dispNameController.text,
        "age": dispAgeController.text,
        "homeNumber": homeNumberController.text,
        "street1": streetName1Controller.text,
        "street2": streetName2Controller.text,
        "city": cityController.text,
        "contactNum": contactNumController.text,
      });
      SnackBar snackBar = SnackBar(content: Text("Profile Updated!"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Signatra",
            fontSize: 30.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildNameField(),
                            buildAgeField(),
                            buildHNumField(),
                            buildStr1Field(),
                            buildStr2Field(),
                            buildCityField(),
                            buildContactNumField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          onPressed: _signOut,
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
