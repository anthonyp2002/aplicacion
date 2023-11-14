// ignore_for_file: avoid_print, override_on_non_overriding_member
import 'dart:async';
import 'dart:io';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrcontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../api/instrucciones.dart';
import '../../models/user.dart';

class ProlecDBController extends GetxController {
  late FlutterTts flutterTts;
  String? language;
  String? enunciado = "Realize lo que diga las siguientes acciones";
  String? engine;
  double volume = 0.5;
  String valueAnte = "";
  bool showCollisionMessage = false;
  double pitch = 1.0;
  int mb = 0;
  int mc = 0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  late PageController pageController;
  bool shouldRunValidation = true;
  int tap = 0;
  String? speed = "Di la palabra";
  SpeechToText speechToText = SpeechToText();
  late Timer cronometro;
  int tapCounter = 0;
  TtsState ttsState = TtsState.stopped;
  String? _newVoiceText;
  get isPlaying => ttsState == TtsState.playing;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
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
  bool isTransitioningPage = false;

  @override
  void initState() {
    initState();
    initTts();
    loadModel();
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    update();
  }

  Future speak() async {
    flutterTts.setLanguage("es-ES");
    _newVoiceText = enunciado;
    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
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
            Get.offAllNamed('/prolecR');
            Get.find<ProlecRController>()
                .datos(use, tiempo, puntos, puntosH, puntosO);
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
    flutterTts.stop();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == Instruc().optionsText.length - 1) {
        Get.offAllNamed('/prolec');
        print("Pse");
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }
}
