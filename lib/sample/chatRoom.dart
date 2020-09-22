import 'dart:async';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/resourses/Styles.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/chat_room/CustomMessage.dart';
import 'package:jitsi/ui/chat_room/CustomMessageInput.dart';
import 'package:jitsi/ui/chat_room/MessageItem.dart';
import 'MessagesModel.dart';
import 'dart:math';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';

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
  StreamController<bool> streamControllerForRecording =
      StreamController<bool>();
  Future<ChannelSubscription> messages;

  ClientReal clientReal;

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
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<Message>>(
                            future: widget.client.loadIMHistory(widget.roomId),
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
                                    stream: streamControllerForMessages.stream,
                                    initialData: newList,
                                    builder: (context, responseList) {
                                      return ListView.builder(
                                          controller: _scrollController,
                                          itemCount: responseList.data.length,
                                          itemBuilder: (_, int position) {
                                            final item =
                                                responseList.data[position];
                                            streamController.add(true);
                                            return MessageItem(
                                              message: item.msg,
                                              time: item.timestamp,
//                                              userImageUrl: getUserImage(),
                                              messageAttachments:
                                                  getAttachmentType(
                                                      item.attachments),
                                              attachmentUrl:
                                                  "https://rocketdev.itgsolutions.com/${getAttachmentUrl(item.attachments)}?rc_uid=${widget.client.getId()}&rc_token=${widget.client.getToken()}",
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
                      child: StreamBuilder<bool>(
                        stream: streamControllerForRecording.stream,
                        initialData: false,
                        builder: (context, snap) {
                          return CustomMessageInput(
                            sendMessage: sendMessage,
                            uploadFile: uploadFile,
                            startRecord: start,
                            isRecording: snap.data,
                            stopRecording: stop,
                          );
                        },
                      )),
                ),
              ])
        ])));
  }

  void sendMessage(String text) async {
    Message newMessageSent =
        await widget.clientReal.sendMessage(widget.roomId, text);
  }

  Recording _recording = new Recording();

//  bool _isRecording = false;
  Random random = new Random();
  final LocalFileSystem localFileSystem = LocalFileSystem();

  start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;
        streamControllerForRecording.sink.add(isRecording);
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
//          _isRecording = isRecording;
        });
      } else {
        print("doesn't have permission");
//        Scaffold.of(context).showSnackBar(
//            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");

    streamControllerForRecording.sink.add(isRecording);
    setState(() {
      _recording = recording;
    });
//    _controller.text = recording.path;
  }

  void uploadFile(String path) async {
//    await widget.clientReal.Upload(
//        file: new File(path),
//        roomId: widget.roomId,
//        token: widget.client.getToken(),
//        id: widget.client.getId());
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
    streamControllerForRecording.close();
    super.dispose();
  }

  AttachmentType getAttachmentType(List<Attachment> attachments) {
    if (attachments != null) {
      if (attachments.length != 0 &&
          attachments[0].imageUrl != null &&
          attachments[0].imageUrl.isNotEmpty)
        return AttachmentType.image;
      else if (attachments.length != 0 &&
          attachments[0].audioUrl != null &&
          attachments[0].audioUrl.isNotEmpty)
        return AttachmentType.audio;
      else if (attachments.length != 0 &&
          attachments[0].videoUrl != null &&
          attachments[0].videoUrl.isNotEmpty)
        return AttachmentType.video;
      else
        return AttachmentType.text;
    } else
      return AttachmentType.text;
  }

  String getAttachmentUrl(List<Attachment> attachments) {
    if (attachments != null) {
      if (attachments.length != 0 &&
          attachments[0].imageUrl != null &&
          attachments[0].imageUrl.isNotEmpty)
        return attachments[0].imageUrl;
      else if (attachments.length != 0 &&
          attachments[0].audioUrl != null &&
          attachments[0].audioUrl.isNotEmpty)
        return attachments[0].audioUrl;
      else if (attachments.length != 0 &&
          attachments[0].videoUrl != null &&
          attachments[0].videoUrl.isNotEmpty)
        return attachments[0].videoUrl;
      else
        return "";
    } else
      return "";
  }

  getUserImage(String uid) async {
    String image_url = await widget.clientReal.getAvatar(uid);
    return image_url;
  }
}
