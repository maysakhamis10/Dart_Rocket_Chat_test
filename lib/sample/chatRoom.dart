import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/resourses/Styles.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/chat_room/CustomMessage.dart';
import 'package:jitsi/ui/chat_room/CustomMessageInput.dart';
import 'package:jitsi/ui/chat_room/MessageItem.dart';
import 'MessagesModel.dart';

class ChatRoom extends StatefulWidget {
  String roomId = "";
  Channel channel;
  Client client;
  ClientReal clientReal;

  ChatRoom(this.roomId, this.client, this.clientReal, {this.channel});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  MessagesModel messagesModel = MessagesModel();
  ScrollController _scrollController;
  StreamController<bool> streamController = StreamController<bool>();
  StreamController<List<Message>> streamControllerForMessages =
  StreamController<List<Message>>();
  Future<ChannelSubscription> messages;

  ClientReal clientReal;t

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    WidgetsBinding.instance.addObserver(this);
    clientReal = widget.clientReal;

    clientReal.roomMessages().listen((data) {
      if (data.doc != null && data.doc.values != null) {
        var valuesList = data.doc.values.toList();
        Message message = new Message();
        if (valuesList.length >= 2) {
          var list = valuesList[1];
          if (list.isNotEmpty && list.length >= 1) {
            var messageData = list[0];
            var mm = Message.fromJson(messageData);
            print("messsss ${mm.msg}");
            messagesModel.add(mm);
            print(message.msg);
          }
        }
        print("new Value ====>>${valuesList.length}");
      }
    });
    streamController.stream.listen((event) {
      if (event)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut);
        });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return Scaffold(
        appBar: AppBar(
            title: FutureBuilder<ChannelSubscription>(
                future: widget.client.getSubscriptionsOne(widget.roomId),
                builder: (_, response) {
                  return response.hasData && response.data != null
                      ? Text(response.data.name)
                      : Text("");
                })),
        body: Container(
            child: Stack(fit: StackFit.loose, children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: FutureBuilder<List<Message>>(
                                future: widget.client.loadIMHistory(
                                    widget.roomId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    if (snapshot.data.length == 0) {
                                      return Center(
                                        child: Text(
                                          "Start messaging...",
                                          style: MESSAGE_TEXT_STYLE,
                                        ),
                                      );
                                    } else {
                                      messagesModel.removeAll();
                                      List newList =
                                      snapshot.data.reversed.toList();
                                      messagesModel.addAll(newList);
                                      messagesModel.addListener(() {
                                        streamControllerForMessages
                                            .add(messagesModel.messagesList);
                                        streamController.add(true);
                                      });
                                      return StreamBuilder<List<Message>>(
                                        stream: streamControllerForMessages
                                            .stream,
                                        initialData: newList,
                                        builder: (context, responseList) {
                                          return ListView.builder(
                                              controller: _scrollController,
                                              itemCount: responseList.data
                                                  .length,
                                              itemBuilder: (_, int position) {
                                                final item =
                                                responseList.data[position];
                                                streamController.add(true);
                                                return MessageItem(
                                                  message: item.msg,
                                                  time: item.timestamp,
                                                  messageType:
                                                  widget.client.getId() ==
                                                      item.user.id
                                                      ? MessageType.sent
                                                      : MessageType.received,
                                                );
                                              });
                                        },
                                      );
                                    }
                                  } else
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                }))),
                    Divider(height: 0, color: Colors.black26),
                    Container(
                      color: Colors.white,
                      height: 50,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomMessageInput(
                            sendMessage: sendMessage,
                            uploadFile:uploadFile,
                          )),
                    ),
                  ])
            ])));
  }

  void sendMessage(String text) async {
    Message newMessageSent =
    await widget.clientReal.sendMessage(widget.roomId, text);
  }

  void uploadFile(String path) async {
    await widget.clientReal.Upload(file: File(path),
        roomId: widget.roomId,
        token: widget.client.getToken(),
        id: widget.client.getId());
  }

  void didUpdateWidget(ChatRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }


  @override
  void dispose() {
    streamController.close();
    streamControllerForMessages.close();
    super.dispose();
  }

}
