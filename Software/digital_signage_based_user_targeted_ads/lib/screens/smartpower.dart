import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import 'package:project_api/mqttClient/mqttclient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Smartpower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Power Control"),
      ),
      body: MyHomePage(),
    );
  }
}

enum PowerState {
  turnOn,
  turnOff,
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PowerState selectState;
  final MQTTClientWrapper mqttClientWrapper = new MQTTClientWrapper();

  TextEditingController macAddress = new TextEditingController();

  String userMAC = "";
  bool result;

  void setup() {
    mqttClientWrapper.prepareMqttClient(userMAC);
  }

  Future<bool> validateMAC(String inputMac) async {
    try {
      final addresses = await _firestore.collection('MacAddresses').get();
      for (var mac in addresses.docs) {
        for (var val in mac.data().values) {
          if (val == inputMac) {
            return Future.value(true);
          }
        }
      }
      return Future.value(false);
    } on FirebaseException catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
            child: TextFormField(
              controller: macAddress,
              decoration: InputDecoration(
                labelText: 'MAC Address',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: () async {
                userMAC = macAddress.text;
                result = await validateMAC(userMAC);
                setState(() {
                  if (result == true) {
                    setup();
                    print("valid MacAddress  - $userMAC ");
                  } else {
                    print("Invalid Mac Address");
                    selectState = null;
                  }
                });
              },
              color: Colors.blueAccent,
              textColor: Colors.white,
              child: Text('Submit'),
            ),
          ),
          Expanded(
            flex: 4,
            child: ReusableCard(
              onPress: () {
                setState(() {
                  if (result == true) {
                    selectState = PowerState.turnOn;
                  }
                });
              },
              colour: selectState == PowerState.turnOn
                  ? kActiveCardColourON
                  : kInactiveCardColour,
              cardChild: IconContent(
                icon: FontAwesomeIcons.powerOff,
                label: 'Screen ON',
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ReusableCard(
              onPress: () {
                setState(() {
                  if (result == true) {
                    selectState = PowerState.turnOff;
                  }
                });
              },
              colour: selectState == PowerState.turnOff
                  ? kActiveCardColourOFF
                  : kInactiveCardColour,
              cardChild: IconContent(
                icon: FontAwesomeIcons.powerOff,
                label: 'Screen OFF',
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton.extended(
              onPressed: () {
                if (selectState == PowerState.turnOn && result == true) {
                  print("Screen ON");
                  mqttClientWrapper.publishMessage("1");
                } else if ((selectState == PowerState.turnOff &&
                    result == true)) {
                  print("Screen OFF");
                  mqttClientWrapper.publishMessage("0");
                } else {
                  print("enter valid MacAddress or select a state");
                }
              },
              label: Text(
                'CONFIRM',
                style: TextStyle(fontSize: 30),
              ),
              icon: Icon(
                Icons.thumb_up,
                size: 30,
              ),
              backgroundColor: Colors.blueGrey,
            ),
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
      ],
    );
  }
}
