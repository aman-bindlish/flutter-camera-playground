import 'package:flutter/material.dart';
import 'package:fluttercameraplayground/camera/camera_screen.dart';
import 'package:fluttercameraplayground/camera/preview_screen.dart';
import 'package:image_picker/image_picker.dart';

class LauncherScreen extends StatefulWidget {

  @override
  State createState() => LauncherScreenState();
}

class LauncherScreenState extends State<LauncherScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Playground'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: RaisedButton(
                  onPressed: () {
                    _cameraOptionsDialogBox();
                  },
                  child: Text('Choose to take Picture'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// to show a dialog box for the available options to choose for taking picture
  Future<void> _cameraOptionsDialogBox() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take picture from native camera'),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: openGallery,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Take picture from in-App'),
                    onTap: openInAppCamera,
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// for device native camera app
  void openCamera() async {
    var camera = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imagePath: camera.path),
      ),
    );
  }

  /// for choosing from gallery
  void openGallery() async {
    var gallery = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imagePath: gallery.path),
      ),
    );
  }

  /// for opening in-app camera screen
  void openInAppCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(),
      ),
    );
  }
}