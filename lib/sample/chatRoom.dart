import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/CustomMessageInput.dart';
import 'package:jitsi/ui/CustomMessageText.dart';
import 'package:jitsi/ui/MessageItem.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  String id = "";
  ClientReal clientReal;

  ChatRoom(this.id, this.clientReal);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
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
//      widget.clientReal.login(userCredentials);
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
    Future<ChannelSubscription> channel = client.getSubscriptionsOne(widget.id);
    channel.then((onValue) {
      print(onValue.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Message>> messages;
    messages = client.loadIMHistory(widget.id);

    return Scaffold(
        appBar: AppBar(
          title: Text("Item "),
        ),
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blue,
            primaryColorDark: Colors.blue,
            fontFamily: "Roboto",
            primarySwatch: Colors.blue,
//            platform: TargetPlatform.android,
          ),
          home: Container(
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    /*  SizedBox(
                      height: 65,
                      child: Container(
                        color: Colors.black12,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Jimi Cooke",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  "online",
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                              child: Container(
                                child: ClipRRect(
                                  child: Container(color: Colors.amber),
                                  borderRadius: new BorderRadius.circular(50),
                                ),
                                height: 55,
                                width: 55,
                                padding: const EdgeInsets.all(0.0),
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          spreadRadius: -1,
                                          offset: Offset(0.0, 5.0))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Colors.black54,
                    ),*/
                    Flexible(
                      fit: FlexFit.tight,
                      // height: 500,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(

                            // reverse: true,
                            child: FutureBuilder<List<Message>>(
                                future: messages,
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (_, int position) {
                                            final item =
                                                snapshot.data[position];
                                            return MessageItem(
                                              message: item.msg,
                                              time: getTime(item.timestamp.millisecondsSinceEpoch),
                                              messageType: MessageType.sent,
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
                    ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void sendMessage() {
    clientReal.sendMessage(widget.id, _text.text);
  }

  String getTime(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }
}
