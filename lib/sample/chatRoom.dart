import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/resourses/Styles.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/chat_room/CustomMessageInput.dart';
import 'package:jitsi/ui/chat_room/CustomMessageText.dart';
import 'package:jitsi/ui/chat_room/MessageItem.dart';

class ChatRoom extends StatefulWidget {
  String roomId = "";
  ClientReal clientReal;

  ChatRoom(this.roomId, this.clientReal);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _text = new TextEditingController();
  var childList = <Widget>[];
  Client client = new Client(
      Uri(
        scheme: "http",
        host: "rocketdev.itgsolutions.com",
      ),
      false);

  ClientReal clientReal;
  UserCredentials userCredentials = new UserCredentials(
      id: "b5xdRX58zNb2DmqzA",
      token: "nTNC-NpoY2KChS184hQWPjtdvW_J6AzmsafJBJGBRGk");
  ScrollController _scrollController;
  StreamController<bool> streamController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    clientReal = widget.clientReal;
    client.setCredentials(userCredentials);
    _scrollController = new ScrollController();

//    Future<List<Channel>> channels = widget.clientReal.getChannelsIn();
//    Stream<Channel> streamChannel=widget.clientReal.roomsChanged();
//    streamChannel.listen((onData){
//      print(onData);
//    });
//    Stream<UpdateEvent> roomMessage= widget.clientReal.roomMessages();
//    roomMessage.listen((onData){
//      print(onData);
//    });
/*
    widget.clientReal.subRoomsChanged(widget.id);
*/
    streamController.stream.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder<ChannelSubscription>(
              future: client.getSubscriptionsOne(widget.roomId),
              builder: (_, response) {
                return response.hasData && response.data != null
                    ? Text(response.data.name)
                    : Text("");
              }),
        ),
        body: Container(
            child: Stack(fit: StackFit.loose, children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        child: FutureBuilder<List<Message>>(
                            future: client.loadIMHistory(widget.roomId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                if (snapshot.data.length == 0) {
                                  return Center(
                                    child: Text(
                                      "Start messaging...",
                                      style: MESSAGE_TEXT_STYLE,
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                      controller: _scrollController,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, int position) {
                                        final item = snapshot.data[position];
                                        streamController.add(true);
                                        return MessageItem(
                                          message: item.msg,
                                          time: item.timestamp,
                                          messageType:
                                              userCredentials.id == item.user.id
                                                  ? MessageType.sent
                                                  : MessageType.received,
                                        );
                                      });
                                }
                              } else
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                            })),
                  ),
                ),
                Divider(height: 0, color: Colors.black26),
                Container(
                  color: Colors.white,
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomMessageInput(
                        sendMessage: sendMessage,
                      )),
                )
              ])
        ])));
  }

  void sendMessage() {
    clientReal.sendMessage(widget.roomId, _text.text);
  }

  void didUpdateWidget(ChatRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
