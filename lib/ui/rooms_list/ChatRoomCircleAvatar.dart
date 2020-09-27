import 'package:flutter/material.dart';
import 'package:jitsi/resourses/AppColors.dart';
import 'package:jitsi/resourses/Dimens.dart';
import 'package:jitsi/resourses/Images.dart';

class ChatRoomCircleAvatar extends StatelessWidget {
  String userImageUrl;
  ChatStatus status;
  double raduis;

  ChatRoomCircleAvatar({this.userImageUrl, this.status, this.raduis});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            getUserImage(),
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

  Widget getUserImage() {
    return Container(
        width: raduis ?? DIMEN_50,
        height: raduis ?? DIMEN_50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
            image: DecorationImage(
              image: userImageUrl != null && userImageUrl.isNotEmpty
                  ? NetworkImage(userImageUrl)
                  : AssetImage(MEMBERS_IMAGE),
              fit: BoxFit.fill,
            )));
  }
}

enum ChatStatus {
  online,
  offline,
  busy,
}
