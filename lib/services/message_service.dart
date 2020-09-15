import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';

class MessageService {
  HttpService _httpService;

  MessageService(this._httpService);

  // Future<MessageNewResponse> postMessage(MessageNew message) async {
  //   http.Response response = await _httpService.post(
  //       '/api/v1/chat.postMessage', jsonEncode(message.toMap()));

  //   if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
  //     return MessageNewResponse.fromMap(jsonDecode(response.body));
  //   }
  //   return null;
  // }
}
