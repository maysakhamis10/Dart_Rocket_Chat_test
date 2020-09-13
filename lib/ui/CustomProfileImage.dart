import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi/resourses/Dimens.dart';
import 'package:jitsi/resourses/Images.dart';

class CustomProfileImage extends StatelessWidget {
  String userImageUrl;
  double raduis;

  CustomProfileImage({@required this.userImageUrl, this.raduis});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: raduis ?? DIMEN_50,
      height: raduis ?? DIMEN_50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        image: DecorationImage(
          image: userImageUrl != null && userImageUrl.isNotEmpty
              ? NetworkImage(
                  userImageUrl,
                )
              : AssetImage(MEMBERS_IMAGE),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
