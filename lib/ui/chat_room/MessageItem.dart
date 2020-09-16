import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jitsi/resourses/Dimens.dart';
import 'CustomAudioMessages.dart';
import '../CustomProfileImage.dart';
import 'CustomMessage.dart';

class MessageItem extends StatelessWidget {
  String message;
  MessageType messageType;
  DateTime time;
  double maxWidth;
  double minWidth;
  String userImageUrl;
  AttachmentType messageAttachments;

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
          messageAttachments == AttachmentType.audio
              ? MessagesCustomAudio(
                  url:
                      "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3",
                  time: getTime(time))
              : CustomMessage(
                  message: message,
                  time: getTime(time),
                  messageType: messageType,
//                  attachmentType: AttachmentType.image,
//                  attachmentUrl:
//                      "https://image.shutterstock.com/z/stock-photo-mountains-during-sunset-beautiful-natural-landscape-in-the-summer-time-407021107.jpg",
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

  String getTime(DateTime timestamp) {
    var format = new DateFormat('yyyy-MM-dd – hh:mm a').format(timestamp);
    return format;
  }
}
