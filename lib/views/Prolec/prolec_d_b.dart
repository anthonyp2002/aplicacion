// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../api/instrucciones.dart';
import '../../controllers/Prolec_Controller/prolecd_b_controller.dart';

class ProlecDBPage extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<ProlecDBPage> {
  final ProlecDBController _cameraController = Get.put(ProlecDBController());

  @override
  void initState() {
    super.initState();
    _cameraController.pageController = PageController(initialPage: 0);
    _cameraController.initializeCamera();
    _cameraController.loadModel();
    _cameraController.initTts();
  }

  @override
  void dispose() {
    _cameraController.toggleCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cameraController.loadModel();
    _cameraController.pageController = PageController(initialPage: 0);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text("Prolec"),
      ),
      body: Column(children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _cameraController.speak();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Text(
              "Instrucciones del ejercicio",
              style: GoogleFonts.barlow(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        SizedBox(
          height: 70,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _cameraController.pageController,
            itemCount: Instruc().optionsText.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          Instruc().optionsText[index].text!,
                          style: GoogleFonts.barlow(fontSize: 20),
                        ),
                      )));
            },
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Obx(() {
          final isCameraOn = _cameraController.isCameraOn.value;
          if (isCameraOn && _cameraController.cameraController != null) {
            return SizedBox(
              width: 300,
              height: 450,
              child: AspectRatio(
                aspectRatio:
                    _cameraController.cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController.cameraController!),
              ),
            );
          } else {
            return const SizedBox(); // Espacio en blanco cuando la cámara está apagada.
          }
        }),
      ]),
      bottomNavigationBar: BottomAppBar(
          child: MaterialButton(
        onPressed: () {
          _cameraController.nextQuestions();
        },
        child: const Text("Cambiar"),
      )),
    );
  }
}
