import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jitsi/sample/RoomsPage.dart';

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
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue,
        fontFamily: "Roboto",
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
      ),
      home: ChatRooms()));
}
