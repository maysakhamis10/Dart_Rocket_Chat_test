import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';

import 'network_error.dart';

class Mappable {
  Map<String, dynamic> toJson() => {};

  Mappable.fromJson(Map<String, dynamic> json) {}


  Mappable() {}
}

enum ServerMethods { GET, POST, UPDATE, DELETE }

enum Environment { Dev, Live}


class Network with NetworkError {
  static final Network shared = new Network._private();
  Environment _environment = Environment.Live;
  String get baseURL {
    if (_environment == Environment.Live)
      return "http://popcorn-chat.com/api/";


  }
  Dio client = Dio();
  factory Network() {
    return shared;
  }

  Network._private() {
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (_client) {
      _client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  Future getData(String endpoint, Map<String, dynamic> parms) async {
    return _performRequest(endpoint,
        // bodyParms: parms,
        queryParms: parms,
        method: ServerMethods.GET.toString().split('.').last);
  }

  Future getData_header(String endpoint, Map<String, String> parms) async {
    return _performRequest(endpoint,
        // bodyParms: parms,
        queryParms: parms,
        method: ServerMethods.GET.toString().split('.').last);
  }

  Future postData(String endpoint, Map<String, dynamic> parms) async {
    return _performRequest(endpoint,
        bodyParms: parms,
        method: ServerMethods.POST.toString().split('.').last);
  }

  Future _performRequest(String endpoint,
      {Map<String, dynamic> bodyParms,
      Map<String, dynamic> queryParms,
      String method}) async {
    try {
      print("the url>>===$endpoint?$queryParms");

      Response response = await client.request(endpoint,
          data: bodyParms,
          queryParameters: queryParms,
          options: Options(method: method ?? "GET"));
      print("the response is ===${response.toString()}");
      print(response);
      return response;
    } catch (e) {
      return handleError(e);
    }
  }
}
