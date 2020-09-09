import 'package:ddp/ddp.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/sample/chatRoom.dart';

import 'my_channels.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Client client = new Client(
      Uri(
        scheme: "http",
        host: "rocketdev.itgsolutions.com",
      ),
      false);
  UserCredentials userCredentials = new UserCredentials(
      id: " L5DTPyoPX7HMHJdTT",
      token: "I_ETZM5UfWS6AFc0YaWZJBYVn1tbRyeIUJKI3C0KWkU");
  ClientReal client2 = new ClientReal(
      "patient3104",
      Uri(scheme: "https", host: "rocketdev.itgsolutions.com", port: 443),
      false);
  Future<List<ChannelSubscription>> list;
  @override
  void initState() {
    super.initState();

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
    client.setCredentials(userCredentials);

    list = client.getSubscriptions();

    /// client2.roomMessages();

    //client2.sendMessage("G9D5YoNFfdhjXesdxGmbmTAKyFNsF7cDFa", "tyest");
    return MaterialApp(
        home: FutureBuilder<List<ChannelSubscription>>(
      future: list,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int position) {
                  final item = snapshot.data[position];
                  print(item.name);
                  return RaisedButton(
                      child: Text(item.name),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    //  ChatRoom(item.roomId,client2)),
                                    MyChannels(client2)),
                          ));
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ));
  }
}
