import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_test/model/vote.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:login_test/helper/vote.dart';



// firestore collection name
const String kVotes = 'votes';
const String kTitle = 'title';

void getVoteListFromFirestore(BuildContext context) async {

  Firestore.instance.collection(kVotes).getDocuments().then((snapshot) {
    List<Vote> voteList = List<Vote>();

    snapshot.documents.forEach((DocumentSnapshot document) {
      voteList.add(mapFirestoreDocToVote(document));
    });

    Provider.of<VoteState>(context, listen: false).voteList = voteList;
  });
}

Vote mapFirestoreDocToVote(document) {
  Vote vote = Vote(voteId: document.documentID);
  List<Map<String, int>> options = List();
  document.data.forEach((key, value) {
    if (key == kTitle) {
      vote.voteTitle = value;
    } else {
      options.add({key: value});
    }
  });

  vote.options = options;
  return vote;
}

void markVote(String voteId, String option) async {
  // increment value

  Firestore.instance.collection(kVotes).document(voteId).updateData({
    option: FieldValue.increment(1),
  });
}

void retrieveMarkedVoteFromFirestore({String voteId, BuildContext context}) {
  // Retrieve updated doc from server
  Firestore.instance.collection(kVotes).document(voteId).get().then((document) {
    Provider.of<VoteState>(context, listen: false).activeVote =
        mapFirestoreDocToVote(document);
  });
}

void createNewPollFirestore(String title, String choice1, String choice2,
    String choice3, String choice4 ) async{
  await Firestore.instance.collection(kVotes).add({
    'title': title,
    '$choice1': 0,
    '$choice2': 0,
    '$choice3': 0,
    '$choice4': 0,
  });
}


