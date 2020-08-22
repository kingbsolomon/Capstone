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
  String h1 = "This is heading one";
  String descrip = "Putting more text here becasue this is going to be a brief description";

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
                    myArticles("https://i.insider.com/5a82fa30d03072c10e8b4588", "Dr. Disrespect", "commonly known by his online alias Dr Disrespect, is an American Internet celebrity, current YouTube streamer, and former Twitch streamer",context),
                    myArticles(url, h1, descrip,context),
                    myArticles(url, h1, descrip,context),
                    myArticles(url, h1, descrip,context),
                    myArticles(url, h1, descrip,context),
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
                    myArticles(url2, h1, descrip,context),
                    myArticles(url2, h1, descrip,context),
                    myArticles(url2, h1, descrip,context),
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
                    myArticles(url3, h1, descrip,context),
                    myArticles(url3, h1, descrip,context),
                    myArticles(url3, h1, descrip,context),
                    myArticles(url3, h1, descrip,context),
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
                    myArticles(url4, h1, descrip,context),
                    myArticles(url4, h1, descrip,context),
                    myArticles(url4, h1, descrip,context),
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
