import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/resourses/AppColors.dart';
import 'package:jitsi/resourses/Images.dart';

import 'CustomIconButton.dart';

class CustomMessageInput extends StatefulWidget {
  Function sendMessage;

  CustomMessageInput({@required this.sendMessage});

  @override
  State<StatefulWidget> createState() {
    return CustomMessageInputState();
  }
}

class CustomMessageInputState extends State<CustomMessageInput> {
  String hintText = 'Type a message...';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomIconButton(
            iconSize: 55,
            iconAsset: CAMERA_MESSAGE,
            iconColor: BLUE_WHITE,
            onPressed: () {},
          ),
          CustomIconButton(
            iconSize: 55,
            iconAsset: ATTACHMENT_MESSAGE,
            iconColor: BLUE_WHITE,
            onPressed: () {},
          ),
          _getTextField(),
          CustomIconButton(
            iconSize: 55,
            iconColor: BLUE_WHITE,
            icon: Icon(
              Icons.send,
              color: BLUE_WHITE,
            ),
            onPressed: () {},
          ),
          CustomIconButton(
            iconSize: 55,
            iconAsset: MIC_MESSAGE,
            iconColor: BLUE_WHITE,
            onPressed: () {},
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
