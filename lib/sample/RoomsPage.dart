import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/room_realtime_repo.dart';
import 'package:jitsi/ui/rooms_list/ChatRoomCircleAvatar.dart';
import 'package:jitsi/ui/rooms_list/ChatRoomItem.dart';
import 'chatRoom.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> with WidgetsBindingObserver {
  Client client;
  ClientReal clientReal;
  String roomId;
  List<ChannelSubscription> list = new List();

  @override
  void initState() {
    super.initState();
    client = new Client(
        Uri(scheme: "http", host: "rocketdev.itgsolutions.com"), false);

    UserCredentials userCredentials = new UserCredentials(
        id: "g5LLpo3ba2EPPekBF",
        token: "Ra70SCY4FMh5SEHpvMYmBALZm0W8KF6pkGqKc9PEE4g");
    client.setCredentials(userCredentials);
  }

  @override
  void dispose() {
    super.dispose();
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
                        roomId = item != null ? item.roomId : "";
                        return item != null && !item.name.contains("call")
                            ? ChatRoomItem(
                                leading: ChatRoomCircleAvatar(
                                  userImageUrl: "",
                                  status: item.user != null &&
                                          item.user.status == null
                                      ? ChatStatus.offline
                                      : item.user != null &&
                                              item.user.status != null &&
                                              item.user.status == "online"
                                          ? ChatStatus.online
                                          : ChatStatus.busy,
                                ),
                                name: item.name,
                                roomId: item.roomId,
                                onTapFunction: navigateToChat,
                              )
                            : Container();
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }

  navigateToChat(String id) async {
    clientReal =
        await RoomRealTimeRepo.startRoomChat(id, 'pa0707', 'Ab@123456');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoom(id, client, clientReal)),
    );
  }
}
