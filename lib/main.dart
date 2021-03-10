import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mirnet_flutter/views/classifierPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({Key key, this.camera}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MIR-Net Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ClassifierPage(
          camera: camera,
        ));
  }
}
