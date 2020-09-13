import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/ui/rooms_list/ChatRoomCircleAvatar.dart';
import 'package:jitsi/ui/rooms_list/ChatRoomItem.dart';

import 'chatRoom.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  Client client = new Client(
      Uri(
        scheme: "http",
        host: "rocketdev.itgsolutions.com",
      ),
      false);

  UserCredentials userCredentials = new UserCredentials(
      id: "b5xdRX58zNb2DmqzA",
      token: "nTNC-NpoY2KChS184hQWPjtdvW_J6AzmsafJBJGBRGk");

  ClientReal client2 = new ClientReal(
      "pa0707",
      Uri(scheme: "https", host: "rocketdev.itgsolutions.com", port: 443),
      false);

  List<ChannelSubscription> list = new List();

  @override
  void initState() {
    super.initState();
    client.setCredentials(userCredentials);
//    client2.addStatusListener((status) async {
//      if (status == ConnectStatus.connected) {
//        final channels = await client2.getChannelsIn();
//        channels.forEach((channel) {
//          client2.subRoomMessages(channel.id);
//        });
//        client2.roomMessages().listen((data) => print(data.doc));
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<ChannelSubscription>>(
            future: client.getSubscriptions(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, int position) {
                        final item = snapshot.data[position];
                        return item != null && !item.name.contains("call")
                            ? ChatRoomItem(
                                leading: ChatRoomCircleAvatar(
                                  imageUrl: "",
                                  status: item.user.status == null
                                      ? ChatStatus.offline
                                      : item.user.status != null &&
                                              item.user.status == "online"
                                          ? ChatStatus.online
                                          : ChatStatus.busy,
                                ),
                                channel: item,
                                onTapFunction: navigateToChat,
                              )
                            : Container();
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }

  navigateToChat(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoom(id, client2)),
    );
  }
}
