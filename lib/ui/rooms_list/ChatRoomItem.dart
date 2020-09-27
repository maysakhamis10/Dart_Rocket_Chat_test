import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/resourses/Styles.dart';

class ChatRoomItem extends StatefulWidget {
  final Widget leading;

  final Function onTapFunction;
  String name, lastMessage, roomId;
  DateTime timestamp;

  ChatRoomItem(
      {this.leading,
      this.onTapFunction,
      this.roomId,
      this.name,
      this.timestamp,
      this.lastMessage});

  @override
  _ChatRoomItemState createState() => _ChatRoomItemState();
}

class _ChatRoomItemState extends State<ChatRoomItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          widget.onTapFunction(widget.roomId);
        },
        child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(children: <Widget>[
                Expanded(
                    child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: widget.leading,
                  title: _getChatTitle(widget.name, widget.lastMessage ?? "",
                      widget.timestamp),
                ))
              ])),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            height: 1,
            thickness: 1,
          )
        ]));
  }

  Widget _getChatTitle(String name, String lastMessage, DateTime timestamp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(name ?? "",
                  style: BLUE_TITLE_TEXT_STYLE.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              lastMessage != null ? _getLastMessageText(lastMessage) : null,
            ],
          ),
        ),
        timestamp != null ? _getTimeText(getTime(timestamp)) : Container(),
      ],
    );
  }

  Widget _getLastMessageText(String message) {
    if (message != null) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(message,
            style: SUBLABEL_GRAY_BOLD.copyWith(fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      );
    } else {
      return Container();
    }
  }

  Widget _getTimeText(String chatTime) {
    if (chatTime != null) {
      return Text(
        chatTime,
        style: SUBLABEL_GRAY_BOLD.copyWith(fontSize: 14),
        textAlign: TextAlign.center,
      );
    } else {
      return Container();
    }
  }

  String getTime(DateTime timestamp) {
    var format = new DateFormat('yyyy-MM-dd – hh:mm a').format(timestamp);
    return format;
  }
}
