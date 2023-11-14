import 'package:aplicacion/controllers/ProlecR_Controller/prolecrccontroller.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../api/ortografia.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped }

class ProlecRBController extends GetxController {
  late FlutterTts flutterTts;
  late int puntuacion = 0;
  String? language;
  String? enunciado = 'Presiona la palabra que esta escrita correctamente.';
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;
  late PageController pageController;
  List<dynamic> resultsOption = [];
  // ignore: unused_field
  bool _isPressed = false;
  TtsState ttsState = TtsState.stopped;
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;
  var showButtons = false.obs;
  // ignore: unused_field
  late Timer _textDisplayTimer;

  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;
  int puntosIA = 0;
  int puntosIB = 0;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  @override
  onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
  }

  void datos(
      User a, String tmp, int ptn, int pntH, int pntO, int pntIA, int pntIB) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    puntosIB = pntIB;
    update();
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

  Future speak() async {
    await Future.delayed(const Duration(seconds: 1));
    flutterTts.setLanguage("es-ES");
    _newVoiceText = enunciado;
    if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
      await flutterTts.speak(_newVoiceText!);
      List<String> words = _newVoiceText!.split(' ');
      const fragmentDisplayInterval = 225;
      int currentIndex = 0;
      _textDisplayTimer = Timer.periodic(
        const Duration(milliseconds: fragmentDisplayInterval),
        (timer) {
          if (currentIndex < words.length) {
            String fragmentToShow =
                words.sublist(0, currentIndex + 1).join(' ');
            _speechTextStreamController.sink.add(fragmentToShow);
            currentIndex++;
          } else {
            timer.cancel();
          }
        },
      );
      flutterTts.setCompletionHandler(() {
        _speechTextStreamController.sink.add(_newVoiceText!);
        showButtons.value = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == OrotModel().seuModel.length - 1) {
        Get.offAllNamed('/prolecRC');
        Get.find<ProlecRCController>().datos(use, tiempo, puntos, puntosH,
            puntosO, puntosIA, puntosIB, puntuacion);
        //GuardarExcel().puntuacionOrto(puntuacion);
      } else {
        _isPressed = false;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void results(bool result) {
    resultsOption.add(result);
    if (result == true) {
      puntuacion++;
      print("Puntuacion Prolect 7");
      print(use.fullname);
      print(tiempo);
      print(puntos);
      print(puntosH);
      print(puntosO);
      print(puntosIA);
      print(puntosIB);
    }
  }

  void correct(BuildContext index) {}
}
