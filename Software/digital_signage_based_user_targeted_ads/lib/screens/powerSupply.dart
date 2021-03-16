import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_api/components/showToast.dart';
import 'package:project_api/screens/home.dart';
import 'package:project_api/widgets/header.dart';
import 'package:project_api/widgets/rounded_btn.dart';
import '../constants.dart';
import 'package:project_api/mqttClient/mqttclient.dart';
import 'package:project_api/validators.dart';

class PowerSupply extends StatefulWidget {
  @override
  _PowerSupplyState createState() => _PowerSupplyState();
}

enum PowerState {
  turnOn,
  turnOff,
}

class _PowerSupplyState extends State<PowerSupply> with ValidateEntries {
  TextEditingController clearController = TextEditingController();
  final powerFormKey = GlobalKey<FormState>();

  PowerState selectState;
  final MQTTClientWrapper mqttClientWrapper = new MQTTClientWrapper();

  String deviceDetails = "";
  bool pwrState;

  String selectedPwrSupply;

  bool addBtnClicked = false;
  bool renameBtnClicked = false;
  bool removeBtnClicked = false;

  setupDevice(deviceName) {
    mqttClientWrapper.prepareMqttClient(deviceName);
  }

  Future<bool> addValidateMAC() async {
    try {
      DocumentSnapshot documentSnapshot =
          await issuedPwrSupplyRef.document(deviceDetails).get();

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
          await powerSupplyRef.document(deviceDetails).get();

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
    final form = powerFormKey.currentState;
    form.save();
    if (form.validate()) {
      if (await addValidateMAC()) {
        setState(() {
          clearController.clear();
          powerFormKey.currentState.reset();
          showToast(message: "Device added successfully");
          powerSupplyRef.document(deviceDetails).setData({
            // "isVeryfied": true,
            "activeStatus": false,
            "unitName": deviceDetails,
            // "customerID": currentUserWithInfo?.id,
            // "timestamp": timestamp,
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
    final form = powerFormKey.currentState;
    form.save();
    if (form.validate()) {
      if (await removeValidateMAC()) {
        setState(() {
          clearController.clear();
          powerFormKey.currentState.reset();
          showToast(message: "Device deleted successfully");
          powerSupplyRef.document(deviceDetails).delete();
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
    final form = powerFormKey.currentState;
    form.save();
    if (form.validate()) {
      if (selectedPwrSupply != null) {
        setState(() {
          //should happen afer firebase - todo check connection
          clearController.clear();
          powerFormKey.currentState.reset();
          showToast(message: "Device renamed successfully");
          powerSupplyRef
              .document(selectedPwrSupply)
              .updateData({"unitName": deviceDetails});
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
          key: powerFormKey,
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
      appBar: header(context,
          titleText: "Smart Power Supply Unit", removeBackbtn: false),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: powerSupplyRef.snapshots(),
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
                      (doc) => doc.documentID == selectedPwrSupply,
                      orElse: () => null,
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.plug,
                            size: 25.0, color: Colors.blue),
                        SizedBox(width: 50.0),
                        DropdownButton(
                          items: pwrSupplies,
                          onChanged: (pwrSupplyName) {
                            final snackBar = SnackBar(
                              content: Text(
                                'Power Supply Serial Number is $pwrSupplyName',
                                style: TextStyle(color: Colors.blue),
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              selectedPwrSupply = pwrSupplyName;
                            });
                            setupDevice(pwrSupplyName);
                            //get device power status
                            powerSupplyRef
                                .document(pwrSupplyName)
                                .get()
                                .then((value) {
                              pwrState = value["activeStatus"];

                              if (pwrState == true) {
                                setState(() {
                                  selectState = PowerState.turnOn;
                                });
                              } else {
                                setState(() {
                                  selectState = PowerState.turnOff;
                                });
                              }
                            });
                          },
                          value: selectedDoc?.documentID,
                          isExpanded: false,
                          hint: new Text(
                            "Choose Power Supply",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              editDevices(),
              SizedBox(
                height: 40.0,
              ),
              ReusableCard(
                onPress: () {
                  if (pwrState == false) {
                    setState(() {
                      selectState = PowerState.turnOn;
                    });
                    mqttClientWrapper.publishMessage("1");
                    powerSupplyRef.document(selectedPwrSupply).updateData({
                      "activeStatus": true,
                    });
                    pwrState = true;
                  } else {
                    setState(() {
                      selectState = PowerState.turnOff;
                    });
                    mqttClientWrapper.publishMessage("0");
                    powerSupplyRef.document(selectedPwrSupply).updateData({
                      "activeStatus": false,
                    });
                    pwrState = false;
                  }
                },
                colour: selectState == PowerState.turnOn
                    ? kActiveCardColourON
                    : kInactiveCardColour,
                cardChild: IconContent(
                  icon: FontAwesomeIcons.powerOff,
                  label: selectState == PowerState.turnOn
                      ? 'Screen currently ON'
                      : 'Screen currently OFF',
                ),
              ),
            ],
          ),
        ],
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
