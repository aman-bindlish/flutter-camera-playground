import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {

  @override
  State createState() => CameraScreenState();
}

class CameraScreenState extends State {

  /// for connection with device camera
  CameraController controller;
  /// list of cameras available on device (0-index for back, 1-index for front camera)
  List cameras;
  /// for current selected camera index
  int selectedCameraIdx;
  /// for holding the path of the clicked image
  String imagePath;

  /// lifecycle method of StateFulWidget, will be called when CameraScreen is inserted into widget
  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Playground'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  /// its responsibility is controller and would be asynchronous, hence return type is Future
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    // If the controller is updated then update the UI.
    // will be called when switching the camera
    controller.addListener(() {
      // mounted represents whether the CameraScreenState is in widget tree or not
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// To display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    // CameraPreview object is responsible for showing preview
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// To display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blue,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  /// To display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    return Spacer();
  }

  void _onCapturePressed(context) async {
    // TODO: Logic for capture picture
  }
}