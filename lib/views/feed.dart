import 'package:flutter/material.dart';
import 'package:login_test/services/sideMenu.dart';
import 'package:login_test/views/StreamView.dart';
import 'package:login_test/views/StreamCreate.dart';
import 'package:login_test/helper/video_player.dart';
import 'package:login_test/widgets/widget.dart';

class UserFeed extends StatefulWidget {
  @override
  UserFeedState createState() {
    return UserFeedState();
  }
}

//apparently new is not needed
class UserFeedState extends State<UserFeed> {

  GestureDetector myArticles(String imageVal, String heading, String subHeading, context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StreamView()));
      },
      child: Container(
        width: 160.0,
        child: Card(
          child: Wrap(
            children: [
              Image.network("$imageVal") ,
              ListTile(
                title: Text("$heading"),
                subtitle: Text("$subHeading"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String url = "https://images.unsplash.com/photo-1503875154399-95d2b151e3b0?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60";
  String url2 ="https://images.unsplash.com/photo-1484581400079-58a319a15a2a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjIxMTIzfQ&auto=format&fit=crop&w=500&q=60";
  String url3 ="https://images.unsplash.com/photo-1515875294982-4796669a7932?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  String url4 ="https://images.unsplash.com/photo-1528155124528-06c125d81e89?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  String h1 = "Video Game Streamer";
  String descrip = "Twitch TV";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: NavDrawer(),
      appBar: appBarMain(context),

      body:
      Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            RaisedButton(
                child: Text('Create Stream'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StreamCreate()));
                }),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    myArticles("https://prosettings.net/wp-content/uploads/2018/09/drdisrespect-profile-picture.jpg",
                        "Dr. Disrespect", "Twitch TV",context),
                    myArticles("https://prosettings.net/wp-content/uploads/2018/11/ninja-profile-picture-6.png", "Ninja", "Youtube",context),
                    myArticles("https://prosettings.net/wp-content/uploads/2018/10/tfue-profile-picture-2.png", 'Tfue', 'Twitch TV',context),
                    myArticles("https://prosettings.net/wp-content/uploads/2018/09/lothar-profile-picture.jpg", 'Lothar', 'Youtube',context),
                    myArticles('https://prosettings.net/wp-content/uploads/2018/07/chocotaco-profile-picture.jpg', 'Choco Taco', 'Twitch TV',context),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    myArticles("https://prosettings.net/wp-content/uploads/2019/09/mrfreshasian-profile-picture-2.png", 'Ares', descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2018/08/00flour-profile-picture-2.jpg', "Poseidon", descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2019/04/ares-profile-picture-2.png', h1, descrip,context),
                    myArticles(url2, h1, descrip,context),
                    myArticles(url2, h1, descrip,context),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    myArticles("https://prosettings.net/wp-content/uploads/2019/05/martoz-profile-picture-2.png", "TwoKillz", descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2018/09/slaappie-profile-picture.jpg', "Suckaaa", descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2019/06/ex-profile-picture.png', h1, descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2019/05/sway-profile-picture.png', h1, descrip,context),
                    myArticles(url3, h1, descrip,context),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    myArticles("https://prosettings.net/wp-content/uploads/2018/12/motor-profile-picture.jpg", "dizko", descrip,context),
                    myArticles('https://prosettings.net/wp-content/uploads/2019/06/razorx-profile-picture.png', h1, descrip,context),
                    myArticles("https://prosettings.net/wp-content/uploads/2019/12/dizko-profile-picture-2.png", h1, descrip,context),
                    myArticles(url4, h1, descrip,context),
                    myArticles(url4, h1, descrip,context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
