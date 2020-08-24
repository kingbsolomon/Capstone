
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:login_test/helper/vote.dart';
import 'package:login_test/services/sideMenu.dart';
import 'package:login_test/views/results.dart';
import 'package:login_test/widgets/widget.dart';
import 'package:polls/polls.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:login_test/services/services.dart';
import 'package:login_test/widgets/poll_list.dart';
import 'package:login_test/widgets/vote.dart';
import 'package:login_test/helper/video_player.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class StreamView extends StatefulWidget {
  @override
  _StreamViewState createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  FSBStatus drawerStatus;
  int voteCount = 1000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: appBarMain(context),
        body: FoldableSidebarBuilder(
          drawerBackgroundColor: Colors.deepPurple,
          drawer: CustomDrawer(
            closeDrawer: () {
              setState(() {
                drawerStatus = FSBStatus.FSB_CLOSE;
              });
            },
          ),
          screenContents: MainScreen(),
          status: drawerStatus,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.poll,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              });
            }),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          color: Colors.deepPurple,
          onPressed: () {
            setState(() {
              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                // If the video is paused, play it.
                _controller.play();
              }
            });
          },
          // Display the correct icon depending on the state of the player.
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 40.0,
          ),
        ),

      ],
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
      child: VoteHomeScreen(),
    );
  }
}

class VoteHomeScreen extends StatefulWidget {
  @override
  _VoteHomeScreenState createState() => _VoteHomeScreenState();
}

class _VoteHomeScreenState extends State<VoteHomeScreen> {
  int voteCount = 1000;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // loading votes
    Future.microtask(() {
      Provider.of<VoteState>(context, listen: false).clearState();
      Provider.of<VoteState>(context, listen: false).loadVoteList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<VoteState>(builder: (builder, voteState, child) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Current Vote Count:  $voteCount",
                        style: voteCountTextStyle(),
                      ),
                    ),
                    if (voteState.voteList == null)
                      Container(
                        color: Colors.lightBlue,
                      ),
                    if (voteState.voteList != null)
                      Expanded(
                        child: Stepper(
                          type: StepperType.horizontal,
                          currentStep: _currentStep,
                          steps: [
                            getStep(
                              title: 'Choose',
                              child: VoteListWidget(),
                              isActive: true,
                            ),
                            getStep(
                              title: 'Vote',
                              child: VoteWidget(),
                              isActive: _currentStep >= 1 ? true : false,
                            ),
                          ],
                          onStepCancel: () {
                            if (_currentStep <= 0) {
                              voteState.activeVote = null;
                            } else if (_currentStep <= 1) {
                              voteState.selectedOptionInActiveVote = null;
                            }

                            setState(() {
                              _currentStep =
                                  (_currentStep - 1) < 0 ? 0 : _currentStep - 1;
                            });
                          },
                          onStepContinue: () {
                            if (_currentStep == 0) {
                              if (step2Required(voteState)) {
                                setState(() {
                                  _currentStep = (_currentStep + 1) > 2
                                      ? 2
                                      : _currentStep + 1;
                                });
                              } else {
                                showSnackBar(
                                    context, 'Please select a poll!');
                              }
                            } else if (_currentStep == 1) {
                              if (step3Required(voteState)) {
                                // submit vote
                                markMyVote(voteState);
                                // Go To Result Screen
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultScreen()));
                              } else {
                                showSnackBar(context, 'Please mark your vote!');
                              }
                            }
                          },
                        ),
                      ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  bool step2Required(VoteState voteState) {
    if (voteState.activeVote == null) {
      return false;
    }

    return true;
  }

  bool step3Required(VoteState voteState) {
    if (voteState.selectedOptionInActiveVote == null) {
      return false;
    }
    return true;
  }

  void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(fontSize: 22),
      ),
    ));
  }

  Step getStep({
    String title,
    Widget child,
    bool isActive = false,
  }) {
    return Step(
      title: Text(title),
      content: child,
      isActive: isActive,
    );
  }

  void markMyVote(VoteState voteState) {
    final voteId = voteState.activeVote.voteId;
    final option = voteState.selectedOptionInActiveVote;
    voteCount--;

    markVote(voteId, option);
  }
}
