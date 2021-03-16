import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_api/models/user.dart';
import 'package:project_api/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_account.dart';

final int timestamp = DateTime.now().millisecondsSinceEpoch;

final userRef = Firestore.instance.collection('users');
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth _auth;
User currentUserWithInfo;

class UnAuth extends StatefulWidget {
  @override
  _UnAuthState createState() => _UnAuthState();
}

class _UnAuthState extends State<UnAuth> {
  bool showSpinner = false;
  bool isAuth = true;

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

  Future<void> shredprefUser(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUserId', uid);
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
    return isAuth ? Home() : buildUnAuthScreen();
  }
}
