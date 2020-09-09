import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/realtime/client.dart';




class MyChannels extends StatefulWidget {

  ClientReal clientReal;
  @override
  _MyChannelsState createState() => _MyChannelsState();
  MyChannels(this.clientReal) ;
}

class _MyChannelsState extends State<MyChannels> {

  UserCredentials userCredentials = new UserCredentials(
      id: "GmbmTAKyFNsF7cDFa",
      token: "ZiUsJymKtk1Sew1ILGy0WLaWIfevo0BVPI0UKIdnB6e");

  Future<List<Channel>> list;

  @override
  Widget build(BuildContext context) {

    widget.clientReal.login(userCredentials);
 //   list = widget.clientReal.getChannelSubscriptions();
   list = widget.clientReal.getChannelsIn();
   print(list);
    return MaterialApp(
        home: FutureBuilder<List<Channel>>(
          future: list,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int position) {
                  final item = snapshot.data[position];
                  print(item.name);
                  return RaisedButton(

                      child:Text(item.name != null? item.name :" "),

                     onPressed: () => Text(item.name));
                })
                : Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
