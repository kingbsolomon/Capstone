import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:polls/polls.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:login_test/helper/chat.dart';

class StreamView extends StatefulWidget {
  @override
  _StreamViewState createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  FSBStatus drawerStatus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(

        body: FoldableSidebarBuilder(
          drawerBackgroundColor: Colors.deepOrange,
          drawer: CustomDrawer(closeDrawer: (){
            setState(() {
              drawerStatus = FSBStatus.FSB_CLOSE;
            });
          },),
          screenContents: FirstScreen(),
          status: drawerStatus,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            child: Icon(Icons.poll,color: Colors.white,),
            onPressed: () {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
              });
            }),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(200),
      child: ChannelListPage(),
      //child: Center(child: Image.asset('assets/back.jpg')),
    );
  }
}


class CustomDrawer extends StatelessWidget {

  final Function closeDrawer;
  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MediaQueryData mediaQuery = MediaQuery.of(context);
    return Drawer(
      child: PollView(),
    );
  }
}

class PollView extends StatefulWidget {
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {

  double option1 = 2.0;
  double option2 = 0.0;
  double option3 = 2.0;
  double option4 = 3.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };

  String creator = "eddy@mail.com";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Duration _duration = Duration(seconds: 1000000);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SlideCountdownClock(
          duration: Duration(days: 1, minutes: 2),
          slideDirection: SlideDirection.Up,
          separator: ":",
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          shouldShowDays: true,
          onDone: () {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Clock 1 finished')));
          },
        ),

        Polls(
          children: [
            // This cannot be less than 2, else will throw an exception
            Polls.options(title: 'Cairo', value: option1),
            Polls.options(title: 'Mecca', value: option2),
            Polls.options(title: 'Denmark', value: option3),
            Polls.options(title: 'Mogadishu', value: option4),
          ],
          question: Text('WHAT GAME PLAY NEXT'),
          currentUser: this.user,
          creatorID: this.creator,
          voteData: usersWhoVoted,
          userChoice: usersWhoVoted[this.user],
          onVoteBackgroundColor: Colors.blue,
          leadingBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          onVote: (choice) {
            print(choice);
            setState(() {
              this.usersWhoVoted[this.user] = choice;
            });
            if (choice == 1) {
              setState(() {
                option1 += 1.0;
              });
            }
            if (choice == 2) {
              setState(() {
                option2 += 1.0;
              });
            }
            if (choice == 3) {
              setState(() {
                option3 += 1.0;
              });
            }
            if (choice == 4) {
              setState(() {
                option4 += 1.0;
              });
            }
          },
        ),
      ],
    );
  }
}



