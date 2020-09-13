import 'dart:io';

import 'package:ddp/ddp.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/rest/client.dart';
import 'package:jitsi/sample/chatRoom.dart';

import 'my_channels.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue,
          fontFamily: "Roboto",
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
      ),
      home: MyApp()));
}

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
    test();

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

  test() async {
    list = await client.getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChannelSubscription>>(
        future: client.getSubscriptions(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data[position];
                    print(item.user.id);
                    return item.name.contains('call')
                        ? Container()
                        : RaisedButton(
                            child: Text(item.name),
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                          item.roomId, item.user.id, client2)),
                                  // MyChannels(client2)),
                                ));
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}
