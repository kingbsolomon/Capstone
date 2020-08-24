import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_test/helper/authenticate.dart';
import 'package:login_test/helper/constants.dart';
import 'package:login_test/helper/helperFunctions.dart';
import 'package:login_test/views/chatRoomsScreen.dart';
import 'package:login_test/views/feed.dart';
import 'package:login_test/views/myPolls.dart';
import 'package:login_test/views/myProfile.dart';
import 'package:login_test/views/signin.dart';
import 'package:login_test/services/auth.dart';
import 'package:login_test/services/database.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {


  initiateCons() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  void initState() {
    initiateCons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:[
          UserAccountsDrawerHeader(
            accountEmail: Text(Constants.myEmail), // keep blank text because email is required
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/giphy.gif'),
              radius: 50,
            ),
            accountName: Text(Constants.myName),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserFeed()))
          },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfilePage()))},
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Private Messages'),
            onTap: () => {Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChatRoom()))
             },
          ),
          ListTile(
            leading: Icon(Icons.view_stream),
            title: Text('My Streams'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('My Polls'),
            onTap: () => {Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyResults()))},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              }
          ),
        ],
      ),
    );
  }
}
