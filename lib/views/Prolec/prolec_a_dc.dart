// ignore_for_file: unnecessary_null_comparison

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({required this.cameras, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mire a la camara xD',
      home: HomePage(cameras: cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({required this.cameras, super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraImage cameraImage;
  late CameraController cameraController;

  bool isWorking = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  void initCamera() async {
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    await cameraController.initialize();
    if (mounted) {
      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            cameraImage = imageFromStream;
            runModelOnFrame();
          }
        });
      });
    }
  }

  runModelOnFrame() async {
    if (cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true);
      result = "";

      recognitions?.forEach((response) {
        result += response["label"] + "\n";
      });

      setState(() {
        //result
      });

      isWorking = false;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: result.isEmpty
                ? Text('Enfoque el Rostro')
                : Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
            centerTitle: true,
          ),
          body: Container(
            child: (!cameraController.value.isInitialized)
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    ),
                  ),
          ),
          backgroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
