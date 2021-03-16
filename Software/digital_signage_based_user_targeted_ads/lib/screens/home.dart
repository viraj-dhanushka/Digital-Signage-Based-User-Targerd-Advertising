import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_api/screens/create_account.dart';
import 'package:project_api/screens/powerSupply.dart';
import 'package:project_api/screens/usertarget.dart';
import 'package:project_api/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_api/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_api/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_api/services/web_view_container.dart';

final shopsRef = Firestore.instance.collection('shop details');

//get server timestamp
final int timestamp = DateTime.now().millisecondsSinceEpoch;

final userRef = Firestore.instance.collection('users');
final powerSupplyRef = Firestore.instance.collection('power supply units');
final signageUnitRef = Firestore.instance.collection('signage units');
final issuedPwrSupplyRef =
    Firestore.instance.collection('issued power supply units');
final issuedSignageRef = Firestore.instance.collection('issued signage units');

final customerCountRef = Firestore.instance.collection('signage units');
// .document("b8:27:eb:88:85:92")
// .collection("customers");

final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth _auth;
User currentUserWithInfo;

class Home extends StatefulWidget {
  static const String id = "home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isAuth = false

  TextEditingController female_25to32_Controller = TextEditingController();
  String female_25to32 = 'unavailable';
  String male_25to32 = 'unavailable';

  // FirebaseUser mCurrentUser;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();

    // signageUnitRef
    //     .document("b8:27:eb:88:85:92")
    //     .collection("customers")
    //     .document("analysis")
    //     .snapshots()
    //     .listen((DocumentSnapshot documentSnapshot) {
    //   Map<String, dynamic> analysisInfo = documentSnapshot.data;

    //   setState(() {
    //     female_25to32_Controller.text = analysisInfo['female_25to32'];
    //     // male_25to32 = analysisInfo['male_25to32'];
    //   });
    // }).onError((e) => print(e));
  }

  _getCurrentUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedUserId = prefs.getString('loggedUserId');
    if (loggedUserId != null) {
      DocumentSnapshot documentSnapshot =
          await userRef.document(loggedUserId).get();

      if (documentSnapshot.exists) {
        setState(() {
          currentUserWithInfo = User.fromDocument(documentSnapshot);
        });
        print(currentUserWithInfo);
        // print(currentUserWithInfo.name);
        setState(() {
          isAuth = true;
        });
      } else {
        //block user => delete document/auth
        setState(() {
          isAuth = false;
        });
      }
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        // toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }
//google stuff
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    handleSignIn(googleSignInAccount);
  }

  handleSignIn(GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount != null) {
      // print('User signed in!: $googleSignInAccount');

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      // showToast("Hi, " + user.displayName);
      try {
        await createUserInFirestore(user);
      } catch (err) {
        showToast(user.displayName + ", please try again");
        setState(() {
          showSpinner = false;
          isAuth = false;
        });
        _signOut();
      }

      // return 'signInWithGoogle succeeded: $user';
      shredprefUser(user.uid);

      setState(() {
        showSpinner = false;
        isAuth = true;
      });
    } else {
      setState(() {
        showSpinner = false;
        isAuth = false;
      });
    }
  }

  Future<void> shredprefUser(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUserId', uid);
  }

  createUserInFirestore(FirebaseUser user) async {
    DocumentSnapshot documentSnapshot = await userRef.document(user.uid).get();
    //go to createAccount page - only for first reigstration
    if (!documentSnapshot.exists) {
      final userInfoDetails = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateAccount(
                    dispUser: user,
                  )));
      // userRef.document(user.uid).setData({
      //   "id": user.uid,
      //   "name": userInfoDetails.name,
      //   "company": userInfoDetails.company,
      //   "companyBranch": userInfoDetails.companyBranch,
      //   "jobTitle": userInfoDetails.jobTitle,
      //   "whatsappNum": userInfoDetails.whatsappNum,
      //   "contactNum": userInfoDetails.contactNum,
      //   "photoUrl": user.photoUrl,
      //   "timestamp": timestamp
      // });

    }
    documentSnapshot = await userRef.document(user.uid).get();

    currentUserWithInfo = User.fromDocument(documentSnapshot);
    print(currentUserWithInfo);
    print(currentUserWithInfo.name);
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedUserId');

    setState(() {
      isAuth = false;
    });
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  Widget customerProfile(IconData icon, String age) {
    return GestureDetector(
      onTap: customerCount,
      child: Card(
        color: Colors.white,
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
                icon,
                color: Colors.grey,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                age,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  customerCount() {
    showToast("will be available soon");
    //   customerCountRef.document("b8:27:eb:88:85:92").get().then((value) {
    //     // print(value["ad_age"].toString());
    //     showToast(value["ad_age"].toString());
    //   });
    // powerSupplyRef.document("1010").get().then((value) {
    //   showToast(value["activeStatus"]);

    // });
    // if (documentSnapshot.exists) {

    //   showToast(documentSnapshot.data);
    // }else{
    //   showToast("No data available");

    // }
  }

  Widget buildAuthScreen() {
    return Scaffold(
      appBar: header(context, titleText: "Dashboard", removeBackbtn: false),
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
                      image: AssetImage("assets/images/FaceDetect.jpg"),
                      fit: BoxFit.cover)),
            ),
            CustomListTile(
              Icons.dashboard,
              'DASHBOARD',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
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
                  MaterialPageRoute(builder: (context) => PowerSupply()),
                ),
              },
            ),
            CustomListTile(
              Icons.person,
              'PROFILE',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Profile(profileId: currentUserWithInfo?.id)),
                ),
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                alignment: Alignment.centerLeft,
                child: Text('Current Playlist',
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                  color: Color(0xFF848484),
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 40, 5),
                          //width: c_width,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "Age 25-32",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25, fontStyle: FontStyle.italic),
                              ),
                              new Text(
                                "female target Ads",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(40, 15, 20, 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Preview',
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 40,
                            ),
                            onPressed: () => _handleURLButtonPress(context,
                                'https://docs.google.com/presentation/d/e/2PACX-1vQSfEVaOqFgEW3dI1A6mcAMeWv6IWRlgEssaTYSBJ3F-aVEouapLdUCLK-rdcHAp5hkswqSDmZqenCG/pub?start=true&loop=true&delayms=3000'),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ])
                      ])),
              Container(
                  color: Color(0xFF848484),
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 40, 5),
                          //width: c_width,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "Age 25-32",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25, fontStyle: FontStyle.italic),
                              ),
                              new Text(
                                "male target Ads",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(40, 15, 20, 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Preview',
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 40,
                            ),
                            onPressed: () => _handleURLButtonPress(context,
                                'https://docs.google.com/presentation/d/e/2PACX-1vQ_08Rg6fD76TwWhCkZtpcnZV9fenokNVFS3qZB_ET4VT_XRwbJ8m6glftXxO_KkesJjI3hSSwshBwy/pub?start=true&loop=true&delayms=3000'),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ])
                      ])),
              Container(
                color: Color(0xFF848484),
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 40, 5),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "Age All",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25, fontStyle: FontStyle.italic),
                          ),
                          new Text(
                            "generic target Ads",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 15, 20, 2),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Preview',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 40,
                          ),
                          onPressed: () => _handleURLButtonPress(context,
                              'https://docs.google.com/presentation/d/e/2PACX-1vT_jiaWYIqNXIomiqOHcT3mERf-lxJsin-Q4tOK4bxejttQ190wiQCcbdEcSSw7YyNzbOrAlCaaM7Sm/pub?start=true&loop=true&delayms=3000'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                alignment: Alignment.centerLeft,
                child: Text('Customer Analytics',
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customerProfile(FontAwesomeIcons.male, "25:32"),
                  customerProfile(FontAwesomeIcons.female, "38:43"),
                  customerProfile(FontAwesomeIcons.male, "48:53"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            // color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ESLE SIGNAGE',
                  style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 70.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 250.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GoogleSignInButton(
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    // login();
                    signInWithGoogle();
                  },
                  darkMode: true, // default: false
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
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
