import 'package:flutter/material.dart';
import 'package:login_test/views/chatRoomsScreen.dart';
import 'package:login_test/views/feed.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Sidebar',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                ),
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
            onTap: () => {Navigator.of(context).pop()},
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
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
