import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jitsi/models/models.dart';
import 'package:jitsi/resourses/Styles.dart';


class ChatRoomItem extends StatefulWidget {
  final Widget leading;

  final ChannelSubscription channel;
//  final Channel channel;
  final Function onTapFunction;

  ChatRoomItem({
    this.leading,
    this.channel,
    this.onTapFunction,
  });

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
        setState(() {
          widget.onTapFunction(widget.channel.roomId);
//          widget.onTapFunction(widget.channel);
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: widget.leading,
                    title: _getChatTitle(widget.channel),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            height: 1,
            thickness: 1,
          )
        ],
      ),
    );
  }

  Widget _getChatTitle(ChannelSubscription sender) {
//  Widget _getChatTitle(Channel sender) {
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
              Text(sender.name ?? "",
                  style: BLUE_TITLE_TEXT_STYLE.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
//              _getLastMessageText(sender.lastMessage != null ? sender.lastMessage.msg : ""),
            ],
          ),
        ),
        _getTimeText(
            /*sender.lastMessage != null
            ? getTime(sender.lastMessage.timestamp)
            :*/
            ""),
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
