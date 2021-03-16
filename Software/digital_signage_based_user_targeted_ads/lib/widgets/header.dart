import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText, bool removeBackbtn = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackbtn ? false:true,
    title: Text(
      isAppTitle ? "Find Delivery" : titleText,
      style: TextStyle(
        color: Colors.white,
        // fontFamily: isAppTitle ? "Signatra" : "",
        // fontSize: isAppTitle ? 30.0 : 22.0,
        fontFamily:"Signatra",
        fontSize: 30.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
