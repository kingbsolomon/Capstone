import 'package:flutter/material.dart';
import 'package:login_test/helper/vote.dart';
import 'package:login_test/services/services.dart';
import 'package:login_test/model/vote.dart';
import 'package:login_test/services/sideMenu.dart';
import 'package:login_test/views/StreamView.dart';
import 'package:login_test/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:login_test/model/vote.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}




class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    retrieveActiveVoteData(context);

    return Scaffold(
      drawer: NavDrawer(),
      appBar: appBarMain(context),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: createChart(context),
      ),
    );
  }

  Widget createChart(BuildContext context) {
    return Consumer<VoteState>(
      builder: (context, voteState, child) {
        return Container(
          child: charts.BarChart(
            retrieveVoteResult(context, voteState),
            animate: false,
          ),
        );
      },
    );
  }

  List<charts.Series<VoteData, String>> retrieveVoteResult(
      BuildContext context, VoteState voteState) {
    Vote activeVote = voteState.activeVote;

    List<VoteData> data = List<VoteData>();
    for (var option in activeVote.options) {
      option.forEach((key, value) {
        data.add(VoteData(key, value));
      });
    }

    return [
      charts.Series<VoteData, String>(
        id: 'VoteResult',
        colorFn: (_, pos) {
          if (pos % 2 == 0) {
            return charts.MaterialPalette.green.shadeDefault;
          }
          return charts.MaterialPalette.blue.shadeDefault;
        },
        domainFn: (VoteData vote, _) => vote.option,
        measureFn: (VoteData vote, _) => vote.total,
        data: data,
      )
    ];
  }

  void retrieveActiveVoteData(BuildContext context) {
    final voteId =
        Provider.of<VoteState>(context, listen: false).activeVote?.voteId;
    retrieveMarkedVoteFromFirestore(voteId: voteId, context: context);
  }
}

/// Sample ordinal data type.
class VoteData {
  final String option;
  final int total;

  VoteData(this.option, this.total);
}