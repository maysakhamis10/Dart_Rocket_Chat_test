import 'package:flutter/material.dart';
import 'package:jitsi/resourses/AppColors.dart';

import '../CustomProfileImage.dart';

class ChatRoomCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final ChatStatus status;

  const ChatRoomCircleAvatar({this.imageUrl, this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            CustomProfileImage(
              userImageUrl: imageUrl,
            ),
            _getStatusWidget(),
          ],
        ),
      ],
    );
  }

  Widget _getStatusWidget() {
    if (status != null) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: getStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Color getStatusColor(ChatStatus status) {
    switch (status) {
      case ChatStatus.busy:
        return Colors.red;
        break;
      case ChatStatus.online:
        return Colors.green;
        break;
      default:
        return UNSELECTED_GREY;
    }
  }
}

enum ChatStatus {
  online,
  offline,
  busy,
}
