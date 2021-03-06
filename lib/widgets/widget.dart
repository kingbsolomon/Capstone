import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title:
      Image.asset("assets/text.gif",
        height: 40,
      ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

TextStyle voteCountTextStyle() {
  return TextStyle(color: Colors.black, fontSize: 18);
}


bool validEmail(String value){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  return emailValid;
}

Container loadingScreen(){
  return Container(
      child: Center(
        child: CircularProgressIndicator(),)
  );
}