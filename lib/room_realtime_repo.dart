import 'dart:async';
import 'package:jitsi/realtime/client.dart';
import 'package:jitsi/services/authentication_service.dart';
import 'package:jitsi/services/http_service.dart';
import 'package:ddp/ddp.dart';
import 'base_repo.dart';
import 'models/models.dart';

class RoomRealTimeRepo extends BaseRepo {
  static HttpService httpService;
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
            id: "g5LLpo3ba2EPPekBF",
            token: "N4znKscFWouwYYi9EaDWh8M4axbcqJ8ZSDBx99175de"));
        List<Channel> channels = await client.getChannelsIn();
        channels.forEach((channel) {
          if (channel.id == roomId) {
            // client.joinChannel(roomId);
            client.subRoomMessages(channel.id).then((onValue) {
              print("onValue ====>>${onValue}");
            });
          }
        });
      }
    });
    return client;
  }
}
