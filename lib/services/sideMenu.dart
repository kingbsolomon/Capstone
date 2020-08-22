import 'package:flutter/material.dart';
import 'package:login_test/helper/authenticate.dart';
import 'package:login_test/views/chatRoomsScreen.dart';
import 'package:login_test/views/feed.dart';
import 'package:login_test/views/myProfile.dart';
import 'package:login_test/views/signin.dart';
import 'package:login_test/services/auth.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:[
          UserAccountsDrawerHeader(
            accountEmail: Text('KennyG@gmail.com'), // keep blank text because email is required
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/giphy.gif'),
              radius: 50,
            ),
            accountName: Text('Kenny G'),
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
            onTap: () => {Navigator.of(context).pop()},
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
