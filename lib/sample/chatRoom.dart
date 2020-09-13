import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/CustomMessageInput.dart';
import 'package:jitsi/ui/CustomMessageText.dart';
import 'package:jitsi/ui/MessageItem.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  String roomId = "";
  String receiverId = "";
  ClientReal clientReal;

  ChatRoom(this.roomId, this.receiverId, this.clientReal);

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

  @override
  void initState() {
    super.initState();
    clientReal = widget.clientReal;
    client.setCredentials(userCredentials);
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
                            return snapshot.hasData
                                ? ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, int position) {
                                      final item = snapshot.data[position];
                                      return MessageItem(
                                        message: item.msg,
                                        time: getTime(item
                                            .timestamp.millisecondsSinceEpoch),
                                        messageType:
                                            userCredentials.id == item.user.id
                                                ? MessageType.sent
                                                : MessageType.received,
                                      );
                                    })
                                : Center(
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
            ],
          )
        ])));
  }

  void sendMessage() {
    clientReal.sendMessage(widget.roomId, _text.text);
  }

  String getTime(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }
}
