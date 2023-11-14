// ignore_for_file: avoid_print

import 'package:aplicacion/controllers/Prolec_Controller/prolecc_controller.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import '../../api/data_img.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped }

class ProlecbController extends GetxController {
  late FlutterTts flutterTts;
  String? language;
  String? enunciado = "Presione la imagen que coincida con el enunciado";
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;
  int puntuacion = 0;
  late PageController pageController;
  List<dynamic> resultsOption = [];
  // ignore: unused_field
  bool _isPressed = false;
  TtsState ttsState = TtsState.stopped;

  Color isTrue = Colors.green;
  Color isWrong = Colors.red;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
  late User use;
  String tiempo = '';
  SpeechToText speechToText = SpeechToText();
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;
  // ignore: unused_field
  late Timer _textDisplayTimer;
  var showButtons = false.obs;

  @override
  onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
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
    _speechTextStreamController.close();
  }

  void results(bool result) {
    resultsOption.add(result);
    print(resultsOption);
    if (result == true) {
      puntuacion++;
    }
  }

  void datos(User a, String crono) {
    use = a;
    tiempo = crono;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == Img().imgOption.length - 1) {
        print(puntuacion);
        Get.offAllNamed('/prolecC');
        Get.find<ProlecCController>().datos(use, tiempo, puntuacion);
        // GuardarExcel().puntuacionImg(puntuacion);
      } else {
        _isPressed = false;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
        print(use.fullname);
        print(tiempo);
      }
    }
  }
}
