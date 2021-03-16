import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_api/components/showToast.dart';
import 'package:project_api/constants.dart';
import 'package:project_api/widgets/header.dart';
import 'package:project_api/widgets/rounded_btn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_api/adslides.dart';
import 'package:project_api/services/web_view_container.dart';
import 'package:project_api/screens/home.dart';

class Usertarget extends StatefulWidget {
  @override
  _UsertargetState createState() => _UsertargetState();
}

enum UserTargetState {
  turnOn,
  turnOff,
}

class _UsertargetState extends State<Usertarget> {
  TextEditingController clearController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String deviceDetails = "";
  bool userTargettingState;
  UserTargetState selectState;

  String selectedSignageUnit;

  List<Gender> genders = new List<Gender>();
  List<Age> ages = new List<Age>();

  int genderActiveIndex = 0;
  int ageActiveIndex = 5;
  String currentURL;
  String currentPreview;

  bool addBtnClicked = false;
  bool renameBtnClicked = false;
  bool removeBtnClicked = false;

  _launchURL(int index1, int index2) async {
    currentURL = Adlist().selectAd(index1, index2);

    if (await canLaunch(currentURL)) {
      await launch(currentURL);
    } else {
      throw 'Could not launch $currentURL';
    }
    print("success!!!");
  }

  void _handleURLButtonPress(BuildContext context, int index1, int index2) {
    currentPreview = Adlist().selectPreview(index1, index2);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(currentPreview)));
  }

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", FontAwesomeIcons.male, true));
    genders.add(new Gender("Female", FontAwesomeIcons.female, false));
    genders.add(new Gender("Generic", FontAwesomeIcons.users, false));

    ages.add(new Age("15 - 20", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("25 - 32", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("38 - 43", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("48 - 53", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("60 - 100", FontAwesomeIcons.peopleArrows, false));

    CustomRadio(genders[0]);
  }

  Future<bool> addValidateMAC() async {
    try {
      DocumentSnapshot documentSnapshot =
          await issuedSignageRef.document(deviceDetails).get();

      if (documentSnapshot.exists) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on Exception catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> removeValidateMAC() async {
    try {
      DocumentSnapshot documentSnapshot =
          await signageUnitRef.document(deviceDetails).get();

      if (documentSnapshot.exists) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on Exception catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  addDevice() async {
    setState(() {
      addBtnClicked = true;
      renameBtnClicked = false;
      removeBtnClicked = false;
    });
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      if (await addValidateMAC()) {
        setState(() {
          clearController.clear();
          formKey.currentState.reset();
          showToast(message: "Device added successfully");
          signageUnitRef.document(deviceDetails).setData({
            "isUserTargeting": false,
            "customerID": currentUserWithInfo?.id,
            "timestamp": timestamp,
            "unitName": deviceDetails
          });
        });
      } else {
        showToast(message: "Please check the Serial number again");
      }
    } else {
      showToast(message: "Please check the Serial number again");
    }
  }

  removeDevice() async {
    setState(() {
      addBtnClicked = false;
      renameBtnClicked = false;
      removeBtnClicked = true;
    });
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      if (await removeValidateMAC()) {
        setState(() {
          clearController.clear();
          formKey.currentState.reset();
          showToast(message: "Device deleted successfully");
          signageUnitRef.document(deviceDetails).delete();
        });
      } else {
        showToast(message: "Please check the Serial number again");
      }
    } else {
      showToast(message: "Please check the Serial number again");
    }
  }

  renameDevice() async {
    setState(() {
      addBtnClicked = false;
      renameBtnClicked = true;
      removeBtnClicked = false;
    });
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      if (selectedSignageUnit != null) {
        setState(() {
          //should happen afer firebase - todo check connection
          showToast(message: "Device renamed successfully");
          signageUnitRef
              .document(selectedSignageUnit)
              .updateData({"unitName": deviceDetails});
          clearController.clear();
          formKey.currentState.reset();
        });
      } else {
        showToast(message: "Please Choose a device from the dropdown menu");
      }
    } else {
      showToast(message: "Please check the Device name again");
    }
  }

  editDevices() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: TextFormField(
              controller: clearController,
              validator: (val) {
                if (val.trim().length != 17 &&
                    (addBtnClicked || removeBtnClicked)) {
                  return "Enter a valid Serial Number";
                } else if (val.trim().length == 0 && renameBtnClicked) {
                  return "Enter a valid Device Name";
                } else {
                  return null;
                }
              },
              onSaved: (val) => deviceDetails = val,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Device Details",
                labelStyle: TextStyle(fontSize: 15.0),
                hintText: "for add/remove use Serial Number",
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RoundedButton(
              title: 'Add',
              minWidth: 75.0,
              height: 25.0,
              color: Theme.of(context).accentColor,
              onPressed: addDevice,
            ),
            RoundedButton(
              title: 'Rename',
              minWidth: 75.0,
              height: 25.0,
              color: Colors.blueAccent,
              onPressed: renameDevice,
            ),
            RoundedButton(
              title: 'Delete',
              minWidth: 75.0,
              height: 25.0,
              color: Colors.redAccent,
              onPressed: removeDevice,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          header(context, titleText: "Control Assets", removeBackbtn: false),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 25.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: signageUnitRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    const Text("Loading.....");
                  else {
                    List<DropdownMenuItem> pwrSupplies = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      DocumentSnapshot snap = snapshot.data.documents[i];
                      pwrSupplies.add(
                        DropdownMenuItem(
                          child: Text(
                            snap.data["unitName"],
                            style: TextStyle(color: Colors.blue),
                          ),
                          value: "${snap.documentID}",
                        ),
                      );
                    }
                    var selectedDoc = snapshot.data.documents.firstWhere(
                      (doc) => doc.documentID == selectedSignageUnit,
                      orElse: () => null,
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.desktop,
                            size: 25.0, color: Colors.blue),
                        SizedBox(width: 50.0),
                        DropdownButton(
                          items: pwrSupplies,
                          onChanged: (signageUnitName) {
                            final snackBar = SnackBar(
                              content: Text(
                                'Signage unit serial is $signageUnitName',
                                style: TextStyle(color: Colors.blue),
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              selectedSignageUnit = signageUnitName;
                            });
                            // setupDevice(signageUnitName);
                            // get device power status
                            signageUnitRef
                                .document(signageUnitName)
                                .get()
                                .then((value) {
                              userTargettingState = value["isUserTargeting"];

                              if (userTargettingState == true) {
                                setState(() {
                                  selectState = UserTargetState.turnOn;
                                });
                              } else {
                                setState(() {
                                  selectState = UserTargetState.turnOff;
                                });
                              }
                            });
                          },
                          value: selectedDoc?.documentID,
                          isExpanded: false,
                          hint: new Text(
                            "Choose Signage Device",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              editDevices(),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  'Select Gender category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 700.0,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: genders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              //splashColor: Colors.blue,
                              onTap: () {
                                setState(() {
                                  genders.forEach(
                                      (gender) => gender.isSelected = false);
                                  //if (index == 2) {
                                  ages.forEach((age) => age.isSelected = false);
                                  CustomRadio1(ages[index]);
                                  if (index != 2) {
                                    ageActiveIndex = 5;
                                  } else {
                                    ageActiveIndex = 0;
                                  }
                                  //}
                                  genders[index].isSelected = true;
                                  genderActiveIndex = index;
                                  //print("Current Index = $index ");
                                });
                              },
                              child: CustomRadio(genders[index]),
                            );
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Text(
                          'Select Age category',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: ages.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  ages.forEach((age) => age.isSelected = false);
                                  if (genderActiveIndex != 2) {
                                    ages[index].isSelected = true;
                                    ageActiveIndex = index;
                                  } else {
                                    ageActiveIndex = 0;
                                  }
                                });
                              },
                              child: CustomRadio1(ages[index]),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  'Add new assets',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.centerLeft,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      onPressed: () {
                                        if (ageActiveIndex != 5) {
                                          _launchURL(genderActiveIndex,
                                              ageActiveIndex);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Alert!"),
                                              content:
                                                  Text("Select age category"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("Got it!"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.blueAccent,
                                      textColor: Colors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            child: Text(
                                              "Add assets",
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 5, 0, 5),
                                            child: Icon(
                                              Icons.add,
                                              size: 30.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 10, 5),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (ageActiveIndex != 5) {
                                          _handleURLButtonPress(
                                              context,
                                              genderActiveIndex,
                                              ageActiveIndex);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Alert!"),
                                              content:
                                                  Text("Select age category"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("Got it!"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.blueGrey,
                                      textColor: Colors.white,
                                      child: Text(
                                        'Watch preview',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //add
                              SizedBox(
                                height: 10.0,
                              ),
                              ReusableCard(
                                onPress: () {
                                  if (selectedSignageUnit == null) {
                                    showToast(
                                        message: "Please select a device");
                                  } else if (userTargettingState == false) {
                                    setState(() {
                                      selectState = UserTargetState.turnOn;
                                    });
                                    signageUnitRef
                                        .document(selectedSignageUnit)
                                        .updateData({
                                      "isUserTargeting": true,
                                    });
                                    userTargettingState = true;
                                  } else {
                                    setState(() {
                                      selectState = UserTargetState.turnOff;
                                    });
                                    signageUnitRef
                                        .document(selectedSignageUnit)
                                        .updateData({
                                      "isUserTargeting": false,
                                    });
                                    userTargettingState = false;
                                  }
                                },
                                colour: selectState == UserTargetState.turnOn
                                    ? kActiveCardColourON
                                    : kInactiveCardColour,
                                cardChild: IconContent(
                                  icon: FontAwesomeIcons.powerOff,
                                  label: selectState == UserTargetState.turnOn
                                      ? 'User Targetting ON'
                                      : 'User Targetting OFF',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

class Age {
  String age;
  IconData icon;
  bool isSelected;

  Age(this.age, this.icon, this.isSelected);
}

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  CustomRadio(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _gender.isSelected ? Color(0xFF3B4257) : Colors.white,
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        margin: new EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _gender.icon,
              color: _gender.isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _gender.name,
              style: TextStyle(
                  color: _gender.isSelected ? Colors.white : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class CustomRadio1 extends StatelessWidget {
  final Age _age;

  CustomRadio1(this._age);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _age.isSelected ? Color(0xFF3B4257) : Colors.white,
      child: Container(
        height: 45,
        width: 45,
        alignment: Alignment.center,
        margin: new EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _age.icon,
              color: _age.isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _age.age,
              style: TextStyle(
                  color: _age.isSelected ? Colors.white : Colors.grey,
                  fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.colour, this.cardChild, this.onPress});

  final Color colour;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
