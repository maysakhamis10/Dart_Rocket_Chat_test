import 'dart:async';
import 'dart:convert';

import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/services/authentication_service.dart';
import 'package:jitsi/services/http_service.dart';

import 'package:ddp/ddp.dart';
import 'package:http/http.dart' as http;

import 'base_repo.dart';
import 'models/models.dart';

class RoomRealTimeRepo extends BaseRepo {
  static HttpService httpService;
  // Authentication authentication;
  AuthenticationService authenticationService;

  setUp() async {
    httpService = new HttpService('rocketdev.itgsolutions.com');
    authenticationService = AuthenticationService(httpService);
  }

  static Future<ClientReal> startRoomChat(
      String roomId, String username, String password) async {
    ClientReal client = ClientReal(
        'POST',
        Uri(scheme: "https", host: "rocketdev.itgsolutions.com", port: 443),
        true);

    client.addStatusListener((status) async {
      if (status == ConnectStatus.connected) {
        User user = await client.login(new UserCredentials(
            id: "b5xdRX58zNb2DmqzA",
            token: "nTNC-NpoY2KChS184hQWPjtdvW_J6AzmsafJBJGBRGk"));
        List<Channel> channels = await client.getChannelsIn();
        channels.forEach((channel) {
          if (channel.id == roomId) {
            // client.joinChannel(roomId);
            client.subRoomMessages(channel.id);
          }
        });
//        print('response room.. $status');
//        client.roomMessages().listen((data) => print('ahmed room.${data.doc}'));
      }
    });
    return client;
  }

  // static Future<RoomMessages> getRoomChatMessages(String roomId, bool isGroup) async {
  //   RoomMessages roomMessages = new RoomMessages();
  //   String methodName= "groups.messages";
  //   if(isGroup==false)
  //     methodName= "im.messages";
  //   var response =
  //   await Singleton().httpService.get('/api/v1/$methodName?roomId=$roomId');
  //   if (response != null &&
  //       response?.statusCode == 200 &&
  //       response.body?.isNotEmpty == true) {
  //     roomMessages = RoomMessages.fromMap(jsonDecode(utf8.decode(response.bodyBytes)));
  //   }
  //   return roomMessages;
  // }

  // authentateUser(String userName, String password) async {
  //   authentication = await authenticationService.login(userName, password);
  //   httpService.authentication = authentication;
  //   print('$authentication');

  //   // to be used on all upcoming apis calls ..
  //   Singleton().httpService = httpService;
  // }

//
  Future<Map<String, dynamic>> _setuserloginParameters(
      String email, String password) async {
    Map<String, dynamic> parms = {"email": email, "password": password};
    return parms;
  }

// @override
// void handleError(PopcornError error) {
//   print("call from inside>>>" + error.errorMessage);
// }
}
