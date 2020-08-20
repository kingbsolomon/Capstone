import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void mainChat() async {
  final client = Client(
    'kbucrhjkpcjp',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(
      id: 'round-cell-6',
      extraData: {
        'image': 'https://getstream.io/random_png/?id=round-cell-6&amp;name=Round+cell',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoicm91bmQtY2VsbC02In0.Yp-S3e7YgtdJf0J9tpF1S5lKDYSfKuMlQgKQ1SqcHew',
  );





  runApp(MyChat(client));
}

class MyChat extends StatelessWidget {
  final Client client;


  MyChat(this.client);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChannelListPage()



    );
  }

}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChannelsBloc(
        child: ChannelListView(
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user.id],
            }
          },
          sort: [SortOption('last_message_at')],
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
        ),
      );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}












