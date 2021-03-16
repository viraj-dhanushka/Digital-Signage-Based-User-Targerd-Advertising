import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_api/widgets/header.dart';

import 'package:project_api/validators.dart';
import 'home.dart';

class CreateAccount extends StatefulWidget {
  final FirebaseUser dispUser;

  CreateAccount({Key key, @required this.dispUser}) : super(key: key);
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> with ValidateEntries {
  Placemark placemark;
  final _formKey = GlobalKey<FormState>();

  String name;
  String age;
  String homeNumber;
  String street1;
  String street2;
  String city;
  String contactNum;

  @override
  void initState() {
    super.initState();
    // formattedAddress = getUserLocation();

    getUserLocation().then((value) {
      setState(() {
        placemark = value;
        street1 = placemark.thoroughfare;
        street2 = placemark.locality;
        city = placemark.subAdministrativeArea;
        // String completeAddress =
        //     '1${placemark.subThoroughfare} 2${placemark.thoroughfare}, 3${placemark.subLocality} 4${placemark.locality}, 5${placemark.subAdministrativeArea}, 6${placemark.administrativeArea} 7${placemark.postalCode}, 8${placemark.country}';
        // print(completeAddress);
      });
    });
  }

  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      showToast("Hi, $name");
      UserInfoDetails userInfoDetails = new UserInfoDetails(
          name, age, homeNumber, street1, street2, city, contactNum);

      userRef.document(widget.dispUser.uid).setData({
        "id": widget.dispUser.uid,
        "name": userInfoDetails.name,
        "age": userInfoDetails.age,
        "homeNumber": userInfoDetails.homeNumber,
        "street1": userInfoDetails.street1,
        "street2": userInfoDetails.street2,
        "city": userInfoDetails.city,
        "contactNum": userInfoDetails.contactNum,
        "photoUrl": widget.dispUser.photoUrl,
        "timestamp": timestamp,
      });
      Navigator.popUntil(
        context,
        ModalRoute.withName(Home.id),
      );
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context,
          titleText: "Set up your profile", removeBackbtn: false),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    validator: validateUsername,
                    onSaved: (val) => name = val,
                    initialValue: widget.dispUser.displayName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    validator: validateUserAge,
                    onSaved: (val) => age = val,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Age",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter Your age",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    validator: validateUserContact,
                    onSaved: (val) => contactNum = val,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contact Number",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Eg: 071-------",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Text(
                    "Shop Address",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    onSaved: (hn) => homeNumber = hn,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Shop Number",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your Shop number",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    key: Key(street1),
                    initialValue: street1,
                    onSaved: (strN1) => street1 = strN1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Street Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your street name 1",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    key: Key(street2),
                    initialValue: street2,
                    onSaved: (strN2) => street2 = strN2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Street Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your street name 2",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    key: Key(city),
                    initialValue: city,
                    onSaved: (cty) => city = cty,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "City",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your city",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<Placemark> getUserLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks = await Geolocator()
      .placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks[0];
}

void showToast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      // toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white);
}

class UserInfoDetails {
  UserInfoDetails(this.name, this.age, this.homeNumber, this.street1,
      this.street2, this.city, this.contactNum);

  String name;
  String age;
  String homeNumber;
  String street1;
  String street2;
  String city;
  String contactNum;
}
