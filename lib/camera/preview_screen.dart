import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class PreviewScreen extends StatefulWidget {

  /// for captured image path
  final String imagePath;

  PreviewScreen({this.imagePath});

  @override
  State createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.file(File(widget.imagePath), fit: BoxFit.cover)),
            SizedBox(height: 10.0),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: RaisedButton(
                  onPressed: () {
                    getBytesFromFile().then((bytes) {
                      Share.file('Share via:', basename(widget.imagePath),
                          bytes.buffer.asUint8List(), 'image/png');
                    });
                  },
                  child: Text('Share'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// converts the image file into bytes with ByteData
  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}