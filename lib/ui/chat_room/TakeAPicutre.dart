import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakeAPicture extends StatefulWidget {
  final CameraDescription camera;

  const TakeAPicture({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TakePictureScreenState();
  }
}

class TakePictureScreenState extends State<TakeAPicture> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagePath == ""
          ? Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final path = join(
                          (await getTemporaryDirectory()).path,
                          '${DateTime.now()}.png',
                        );
                        await _controller.takePicture(path);
                        setState(() {
                          imagePath = path;
                        });
                        /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayPictureScreen(imagePath: path),
                    ),
                  );*/
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            )
          : Container(
              child: DisplayPictureScreen(
                imagePath: imagePath,
                sendImage: sendImage,
                closeCamera: closeCamera,
              ),
            ),
    );
  }

  void sendImage() {
    Navigator.pop(context, imagePath);
  }

  void closeCamera() {
    setState(() {
      imagePath = "";
    });
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  Function closeCamera, sendImage;

  DisplayPictureScreen(
      {Key key, this.imagePath, this.closeCamera, this.sendImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: FileImage(File(imagePath)), fit: BoxFit.cover)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              closeCamera();
//                  Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(24.0),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 45,
              ),
              decoration: BoxDecoration(
//                shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.red, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(100.0)),
            ),
          ),
          GestureDetector(
            onTap: () {
              sendImage();
              /* Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) {
                    return ChatRoom()
                  }));*/
            },
            child: Container(
              margin: EdgeInsets.all(24.0),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.done,
                color: Colors.green,
                size: 45,
              ),
              decoration: BoxDecoration(
//                shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.green, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(100.0)),
            ),
          ),
        ],
      ),
    ));
  }
}
