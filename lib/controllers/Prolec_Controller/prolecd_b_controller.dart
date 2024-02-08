// ignore_for_file: avoid_print, override_on_non_overriding_member
import 'dart:async';
import 'package:aplicacion/controllers/initController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../../api/instrucciones.dart';
import '../../models/user.dart';

class ProlecDBController extends GetxController {
  String valueAnte = "";
  int mb = 0;
  int mc = 0;
  late PageController pageController;
  bool shouldRunValidation = true;
  RxBool isCameraOn = false.obs;
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  CameraImage? _cameraImage;
  CameraImage? get cameraImage => _cameraImage;
  RxString result = ''.obs;
  RxBool isWorking = false.obs;
  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;

  @override
  void initState() {
    initState();
    loadModel();
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    update();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await _cameraController!.initialize();
    isCameraOn.value = true;
    _cameraController!.startImageStream((imageFromStream) {
      if (!isWorking.value) {
        isWorking = true.obs;
        _cameraImage = imageFromStream;
        runModelOnFrame();
      }
    });
  }

  runModelOnFrame() async {
    print(puntosO);
    if (shouldRunValidation && cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: _cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: _cameraImage!.height,
          imageWidth: _cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true);
      result = "".obs;

      final newResult =
          recognitions?.map((response) => response["label"]).join("\n") ?? "";
      result.value = newResult;
      isWorking.value = false;
    }
    validacion();
  }

  validacion() async {
    if (pageController.page == 0.0) {
      if (result.value == "0 Lapiz") {
        print("Estas seleccionando un lapiz");
        bool positionMatched =
            await Future.delayed(const Duration(seconds: 3), () {
          return (result.value == "0 Lapiz");
        });
        if (positionMatched) {
          pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        }
      }
    } else if (pageController.page == 1.0) {
      print("Calificacion $valueAnte y ${result.value}");
      if ((valueAnte == "1 Mano Abierta" && result.value == "3 Mano Cerrada") ||
          (result.value == "1 Mano Abierta" && valueAnte == "3 Mano Cerrada")) {
        print("Estas realoizando la accion");
        mb++;
        mc++;
        print("LA cantidad es $mb y $mc");
        if (mb == 2 && mc == 2) {
          shouldRunValidation = false;
          _cameraController?.dispose();

          print("Creo que vale");
          puntosO = 5;
          print(puntosO);
          await Future.delayed(const Duration(seconds: 1), () {
            User as = User("", "age", "", "gmail", "password", "phone");
            Get.offAllNamed('/prolecR');
            Get.find<InitController>()
                .datos(as, tiempo, puntos, puntosH, puntosO, 0, 0, 0, 0);
          });
        }
      }
      valueAnte = result.value;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> toggleCamera() async {
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized) {
        await _cameraController!.dispose();
        isCameraOn.value = false;
      } else {
        await initializeCamera();
      }
    }
  }

  @override
  void onClose() {
    _cameraController?.dispose();
    super.onClose();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == Instruc().optionsText.length - 1) {
        User as = User("", "age", "", "gmail", "password", "phone");
        Get.offAllNamed('/prolecR');
        Get.find<InitController>()
            .datos(as, tiempo, puntos, puntosH, puntosO, 0, 0, 0, 0);
        print("Pase");
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }
}
