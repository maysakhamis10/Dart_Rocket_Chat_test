import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/resourses/AppColors.dart';
import 'package:jitsi/resourses/Images.dart';

import '../../Singletoon.dart';
import 'CustomIconButton.dart';

class CustomMessageInput extends StatefulWidget {
  Function sendMessage;
  double iconSize;
  Color iconColor;
  String roomId;
  String id;
  String token;

  CustomMessageInput(
      {@required this.sendMessage, this.roomId, this.id, this.token});

  @override
  State<StatefulWidget> createState() {
    return CustomMessageInputState();
  }
}

class CustomMessageInputState extends State<CustomMessageInput> {
  String hintText = 'Type a message...';
  TextEditingController _text = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(
            visible: true,
            child: CustomIconButton(
              iconSize: 35,
              iconAsset: CAMERA_MESSAGE,
              iconColor: BLUE_WHITE,
              onPressed: () {},
            ),
          ),
          Visibility(
            visible: true,
            child: CustomIconButton(
              iconSize: 35,
              iconAsset: ATTACHMENT_MESSAGE,
              iconColor: BLUE_WHITE,
              onPressed: () {},
            ),
          ),
          _getTextField(),
          CustomIconButton(
            iconSize: 35,
            iconColor: BLUE_WHITE,
            icon: Icon(
              Icons.send,
              color: BLUE_WHITE,
            ),
            onPressed: () {
              if (_text.text.isNotEmpty) {
                widget.sendMessage(_text.text);
                _text.text = "";
              }
            },
          ),
          Visibility(
            visible: true,
            child: CustomIconButton(
              iconSize: 35,
              iconAsset: MIC_MESSAGE,
              iconColor: BLUE_WHITE,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xfff9f9f9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: TextField(
          controller: _text,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
