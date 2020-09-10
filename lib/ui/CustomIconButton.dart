import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final String iconAsset;
  final Color iconColor;
  final double iconSize;
  final double scale;
  final Function onPressed;

  CustomIconButton({
    this.icon,
    this.iconAsset,
    this.iconColor,
    this.iconSize,
    this.scale = 1.0,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Transform.scale(
        scale: scale,
        child: icon ?? ImageIcon(
          AssetImage(iconAsset),
          color: iconColor,
          size: iconSize,
        ),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
    );
  }
}
