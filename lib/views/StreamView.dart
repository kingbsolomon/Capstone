import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:login_test/helper/vote.dart';
import 'package:login_test/services/sideMenu.dart';
import 'package:login_test/views/results.dart';
import 'package:polls/polls.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:login_test/services/services.dart';
import 'package:login_test/widgets/poll_list.dart';
import 'package:login_test/widgets/vote.dart';


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
        drawer: NavDrawer(),
        appBar: AppBar(
          title: const Text('Choose Your Adventure'),

        ),

        body: FoldableSidebarBuilder(
          drawerBackgroundColor: Colors.deepPurple,
          drawer: CustomDrawer(closeDrawer: (){
            setState(() {
              drawerStatus = FSBStatus.FSB_CLOSE;
            });
          },),
          screenContents: MainScreen(),
          status: drawerStatus,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
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

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(200),
      child: Image.asset('assets/giphy.gif'),
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
                                    context, 'Please select a vote first!');
                              }
                            } else if (_currentStep == 1) {
                              if (step3Required(voteState)) {
                                // submit vote
                                markMyVote(voteState);
                                // Go To Result Screen
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => ResultScreen()));
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

    markVote(voteId, option);
  }
}