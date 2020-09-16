import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomIconButton extends StatefulWidget {
  final Widget icon;
  final String iconAsset;
  final Color iconColor;
  final double iconSize;
  final double scale;
  final Function onPressed;
  final Permission permission;

  @override
  State<StatefulWidget> createState() {
    return CustomIconButtonState();
  }

  CustomIconButton(
      {this.icon,
      this.iconAsset,
      this.iconColor,
      this.iconSize,
      this.scale = 1.0,
      this.permission,
      this.onPressed});
}

class CustomIconButtonState extends State<CustomIconButton> {
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

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
//        _listenForPermissionStatus();
        if (widget.permission != null)
          await requestPermission(widget.permission);
        widget.onPressed();
      },
    );
  }

  void _listenForPermissionStatus() async {
    final status = await widget.permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void checkServiceStatus(BuildContext context, Permission permission) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
