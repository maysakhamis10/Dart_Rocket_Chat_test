import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jitsi/services/http_service.dart';
import 'package:rocket_chat_dart/models/models.dart';

class AuthenticationService {
  HttpService _httpService;

  AuthenticationService(this._httpService);
}
