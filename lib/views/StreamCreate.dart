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

class StreamCreate extends StatefulWidget {
  @override
  _StreamCreateState createState() => _StreamCreateState();
}

class _StreamCreateState extends State<StreamCreate> {
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
              Icons.add,
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
  int _currentStep = 0;
  static MyFormData data = MyFormData();
  FSBStatus drawerStatus = FSBStatus.FSB_OPEN;

  String test1;

  @override
  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
              return Column(
                children: <Widget>[
                    Container(
                      color: Colors.lightBlue,
                    ),
                    Expanded(
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        steps: [
                          Step(
                            title: Text('Poll Title'),
                            isActive: true,
                            state: StepState.indexed,
                            content: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                data.title = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter Poll Title',
                                hintText: '',
                                icon: Icon(Icons.poll),
                              ),
                            ),
                          ),
                          Step(
                            title: Text('Poll Answers'),
                            isActive: _currentStep == 1 ? true : false,
                            state: StepState.indexed,
                            content: TextFormField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (String value) {
                                      data.choice1 = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Choice',
                                      hintText: '',
                                      icon: Icon(Icons.question_answer),
                                    ),
                                  ),
                          ),
                          Step(
                            title: Text('Poll Answers'),
                            isActive: _currentStep == 2 ? true : false,
                            state: StepState.indexed,
                            content: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                data.choice2 = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Choice',
                                hintText: '',
                                icon: Icon(Icons.question_answer),
                              ),
                            ),
                          ),
                          Step(
                            title: Text('Poll Answers'),
                            isActive: _currentStep == 3 ? true : false,
                            state: StepState.indexed,
                            content: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                data.choice3 = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Choice',
                                hintText: '',
                                icon: Icon(Icons.question_answer),
                              ),
                            ),
                          ),
                          Step(
                            title: Text('Poll Answers'),
                            isActive: _currentStep == 4 ? true : false,
                            state: StepState.indexed,
                            content: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                data.choice4 = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Choice',
                                hintText: '',
                                icon: Icon(Icons.question_answer),
                              ),
                            ),
                          ),

                        ],

                        onStepCancel: () {
                          setState(() {
                            if (_currentStep > 0) {
                              _currentStep = _currentStep - 1;
                            } else {
                              _currentStep = 0;
                            }
                          });
                        },
                        onStepContinue: () {
                          setState(() {
                            if(_currentStep == 4 ){
                              createNewPollFirestore(data.title, data.choice1, data.choice2,
                                  data.choice3, data.choice4);
                              showSnackBar(context, 'Poll Created');

                            }
                            if (_currentStep < 4) {
                              _currentStep = _currentStep + 1;
                            } else {
                              _currentStep = _currentStep;
                            }


                          });

                        },
                      ),
                    ),
                ],
              );
  }
}



class MyFormData {
  String title;
  String choice1;
  String choice2;
  String choice3;
  String choice4;
}

void showSnackBar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: TextStyle(fontSize: 22),
    ),
  ));
}
