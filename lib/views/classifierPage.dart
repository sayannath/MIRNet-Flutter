import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mirnet_flutter/services/transfer.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ClassifierPage extends StatefulWidget {
  final CameraDescription camera;

  const ClassifierPage({Key key, this.camera}) : super(key: key);

  @override
  _ClassifierPageState createState() => _ClassifierPageState();
}

class _ClassifierPageState extends State<ClassifierPage> {
  Classifier _classifier;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _classifier = Classifier();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'MIR-Net TF Lite',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: IconButton(
                    iconSize: 60,
                    onPressed: () {
                      _runModel(context);
                    },
                    icon: Icon(Icons.camera),
                  ),
                ),
                _loading ? CircularProgressIndicator() : Container(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  bool _loading = false;
  void _runModel(context) async {
    setState(() {
      _loading = true;
    });
    // try {
    await _initializeControllerFuture;
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );

    await _controller.takePicture(path);
    var loadImage = await _classifier.loadImage(path);
    var loadResult = await _classifier.runModel(loadImage);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enhanced Image"),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  img.encodeJpg(loadResult),
                  height: 400,
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      _loading = false;
    });
  }
}
