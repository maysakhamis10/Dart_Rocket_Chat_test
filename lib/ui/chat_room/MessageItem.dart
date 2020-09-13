import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/resourses/Dimens.dart';
import 'CustomAudioMessages.dart';
import '../CustomProfileImage.dart';
import 'CustomMessageText.dart';

class MessageItem extends StatelessWidget {
  String message;
  MessageType messageType;
  DateTime time;
  double maxWidth;
  double minWidth;
  String userImageUrl;
  String messageAttachments;

  MessageItem(
      {this.message,
      this.messageType,
      this.time,
      this.minWidth,
      this.maxWidth,
      this.userImageUrl,
      this.messageAttachments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: DIMEN_12,
        horizontal: DIMEN_24,
      ),
      child: Row(
        children: <Widget>[
          messageType == MessageType.received
              ? CustomProfileImage(userImageUrl: "")
              : Container(),
          messageAttachments == "Audio"
              ? MessagesCustomAudio(
                  url:
                      "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3",
                )
              : CustomMessageText(
                  message: message,
                  time: time,
                  messageType: messageType,
                ),
          messageType == MessageType.received
              ? Container()
              : CustomProfileImage(userImageUrl: ""),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: messageRowAlignment(),
      ),
    );
  }

  MainAxisAlignment messageRowAlignment() {
    if (messageType == null || messageType == MessageType.received) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }
}
