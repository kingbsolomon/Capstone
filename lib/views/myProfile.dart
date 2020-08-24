import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_test/helper/constants.dart';
import 'package:login_test/helper/helperFunctions.dart';
import 'package:login_test/services/database.dart';
import 'package:login_test/services/sideMenu.dart';
import 'package:login_test/widgets/widget.dart';
import 'dart:io';
import 'package:path/path.dart';


class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  QuerySnapshot searchResultSnapshot;
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  String userNameText;
  String emailText;
  String addressText;
  String zipText;
  String stateText;
  String documentID;
  File _image;
  final picker = ImagePicker();

  initiateSearch() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
      await databaseMethods.getUserInfo(Constants.myEmail)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        });

    userNameText = searchResultSnapshot.documents[0].data["name"];
    emailText = searchResultSnapshot.documents[0].data["email"];
    addressText = searchResultSnapshot.documents[0].data["address"];
    zipText = searchResultSnapshot.documents[0].data["zipCode"];
    stateText = searchResultSnapshot.documents[0].data["state"];
    documentID = searchResultSnapshot.documents[0].documentID;

    userName = TextEditingController(text:'$userNameText');
    email = TextEditingController(text:emailText);
    address = TextEditingController(text:addressText);
    zipCode = TextEditingController(text:zipText);
    state = TextEditingController(text:stateText);

    }

    updateRecord() async{
     await Firestore.instance.collection('users').document(documentID).updateData({
        'name': userName.text,
        'email': email.text,
        'address': address.text,
        'zipCode': zipCode.text,
        'state': state.text,
      });
    }

    Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);

    });
    }

    Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }



  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return  Scaffold(
        drawer: NavDrawer(),
        appBar: appBarMain(context),
        body:  Container(
          color: Colors.white,
          child:  ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                   Container(
                    height: 250.0,
                    color: Colors.white,
                    child:  Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:  Stack(fit: StackFit.loose, children: <Widget>[
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.circle,
                                      image:  DecorationImage(
                                        image:  ExactAssetImage(
                                            'assets/search_white.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                   child: (_image!=null)?Image.file(_image): Image.asset('assets/giphy.gif'),
                                 ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                     CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child:  IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        onPressed: (){
                                          getImage();
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                   Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() :  Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter User Name"),
                                      enabled: !_status,
                                      autofocus: !_status,
                                      controller: userName,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Flexible(
                                    child:  TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email"),
                                      enabled: !_status,
                                      //initialValue: searchResultSnapshot.documents[0].data["email"] ?? " ",
                                      controller: email,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Flexible(
                                    child:  TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Address"),
                                      enabled: !_status,
                                      //initialValue: searchResultSnapshot.documents[0].data["address"] ?? " ",
                                      controller: address,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child:  Text(
                                        'State',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child:  Text(
                                        'Zip Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child:  TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter State"),
                                        enabled: !_status,
                                        //initialValue: searchResultSnapshot.documents[0].data["state"] ?? " ",
                                        controller: state,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child:  TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Zip Code"),
                                      enabled: !_status,
                                      //initialValue: searchResultSnapshot.documents[0].data["zipCode"] ?? " " ,
                                      controller: zipCode,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() :  Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child:  RaisedButton(
                    child:  Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        updateRecord();
                        //uploadPic(context);
                        //FocusScope.of(context).requestFocus( FocusNode());
                      });
                    },
                    shape:  RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child:  RaisedButton(
                    child:  Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        //FocusScope.of(context).requestFocus( FocusNode());
                      });
                    },
                    shape:  RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return  GestureDetector(
      child:  CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child:  Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}