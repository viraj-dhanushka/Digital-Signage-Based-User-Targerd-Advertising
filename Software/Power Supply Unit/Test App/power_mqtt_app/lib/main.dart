import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'package:power_mqtt_app/mqttclient.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: MyHomePage(),
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

  void setup() {
    mqttClientWrapper.prepareMqttClient();
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Power Supply"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ReusableCard(
              onPress: () {
                setState(() {
                  selectState = PowerState.turnOn;
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
            child: ReusableCard(
              onPress: () {
                setState(() {
                  selectState = PowerState.turnOff;
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
          BottomButton(
            buttonTitle: 'CONFIRM',
            onTap: () {
              if (selectState == PowerState.turnOn) {
                print("Screen ON");
                mqttClientWrapper.publishMessage("1");
              } else {
                print("Screen OFF");
                mqttClientWrapper.publishMessage("0");
              }
            },
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
        margin: EdgeInsets.all(15.0),
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

class BottomButton extends StatelessWidget {
  BottomButton({@required this.onTap, @required this.buttonTitle});

  final Function onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
            child: Text(
          buttonTitle,
          style: kLargeButtonTextStyle,
        )),
        //color: Color(0xFFEB15555),
        color: Colors.blueGrey,
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        height: kBottomContainerHeight,
      ),
    );
  }
}
