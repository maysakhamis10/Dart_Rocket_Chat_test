import 'package:flutter/material.dart';
import 'package:jitsi/resourses/AppColors.dart';
import 'package:jitsi/resourses/Dimens.dart';
import 'package:jitsi/resourses/Styles.dart';

enum MessageType { sent, received }
enum AttachmentType { file, image, video, audio, text }

class CustomMessage extends StatelessWidget {
  double minWidth, maxWidth, minHeight, maxHeight;
  String message;
  String time;
  String attachmentUrl;
  MessageType messageType;
  AttachmentType attachmentType;

  CustomMessage(
      {this.messageType,
      @required this.message,
      @required this.time,
      this.attachmentType,
      this.attachmentUrl,
      this.maxWidth,
      this.minHeight,
      this.maxHeight,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.symmetric(
//        vertical: DIMEN_2,
//        horizontal: DIMEN_8,
//      ),
      margin: EdgeInsets.symmetric(
        vertical: DIMEN_4,
        horizontal: DIMEN_12,
      ),
      constraints: BoxConstraints(
          minWidth: minWidth ?? DIMEN_100, maxWidth: maxWidth ?? DIMEN_200),
      decoration: BoxDecoration(
        color: messageBgColor(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius()),
          topRight: Radius.circular(topRightRadius()),
          bottomLeft: Radius.circular(DIMEN_8),
          bottomRight: Radius.circular(DIMEN_8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: messageAlignment(),
        children: [
          attachmentType == AttachmentType.image && attachmentUrl != null
              ? imageMessage()
              : attachmentType == AttachmentType.video && attachmentUrl != null
                  ? Container()
                  : attachmentType == AttachmentType.file &&
                          attachmentUrl != null
                      ? Container()
                      : textMessageText(),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: DIMEN_2, horizontal: DIMEN_4),
            child: messageTime(),
          ),
        ],
      ),
    );
  }

  Color messageBgColor(BuildContext context) {
    if (messageType == null || messageType == MessageType.sent) {
      return LIGHT_CYN_MESSAGE_BG_COLOR;
    } else {
      return Colors.grey.shade200;
    }
  }

  Text messageTime() {
    return Text(time ?? "Time", style: TIME_STYLE);
  }

  double topLeftRadius() {
    if (messageType == null || messageType == MessageType.received) {
      return DIMEN_0;
    } else {
      return DIMEN_8;
    }
  }

  double topRightRadius() {
    if (messageType == null || messageType == MessageType.received) {
      return DIMEN_8;
    } else {
      return DIMEN_0;
    }
  }

  CrossAxisAlignment messageAlignment() {
    if (messageType == null || messageType == MessageType.received) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }

  Widget textMessageText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: DIMEN_6,
        horizontal: DIMEN_6,
      ),
      child: Text(message ?? "Message here...", style: MESSAGE_TEXT_STYLE),
    );
  }

  Widget imageMessage() {
    return Container(
      width: DIMEN_200,
      height: DIMEN_200,
      constraints: BoxConstraints(
          minWidth: minWidth ?? DIMEN_100, maxWidth: maxWidth ?? DIMEN_200),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(DIMEN_8),
          ),
          image: DecorationImage(
              image: NetworkImage(attachmentUrl), fit: BoxFit.cover)),
    );
  }

  Widget fileMessage() {
    return Container(
      width: DIMEN_100,
      height: DIMEN_100,
      child: Icon(
        Icons.insert_drive_file,
        size: 45,
      ),
      constraints: BoxConstraints(
          minWidth: minWidth ?? DIMEN_100, maxWidth: maxWidth ?? DIMEN_200),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
        Radius.circular(DIMEN_8),
      )),
    );
  }
}
