import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomChatIconButton extends StatefulWidget {
  final Widget icon;
  final String iconAsset;
  final Color iconColor;
  final double iconSize;
  final double scale;
  final Function onPressed;
  final List<Permission> permission;

  @override
  State<StatefulWidget> createState() {
    return CustomChatIconButtonState();
  }

  CustomChatIconButton(
      {this.icon,
      this.iconAsset,
      this.iconColor,
      this.iconSize,
      this.scale = 1.0,
      this.permission,
      this.onPressed});
}

class CustomChatIconButtonState extends State<CustomChatIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Transform.scale(
        scale: widget.scale,
        child: widget.icon ??
            ImageIcon(
              AssetImage(widget.iconAsset),
              color: widget.iconColor,
              size: widget.iconSize,
            ),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        if (widget.permission != null)
          for (Permission p in widget.permission) await requestPermission(p);
        if (widget.onPressed != null) widget.onPressed();
      },
    );
  }

  Future<void> requestPermission(Permission permission) async {
    await permission.request();
  }
}
