// ignore_for_file: avoid_print, unused_field

import 'dart:async';

import 'package:aplicacion/controllers/Prolec_Controller/prolecd_a_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../api/data_imgc.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped }

bool _isPressed = false;

class ProlecCController extends GetxController {
  List<dynamic> resultsOption = [];
  List<dynamic> result = [];
  late FlutterTts flutterTts;
  late PageController pageController;
  String? language;
  String? enunciado = "Lea las historias y responda las siguientes preguntas";
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;
  var words = "".obs;
  var speed = "".obs;
  var isLisent = false.obs;
  int puntuacionText = 0;
  late User use;
  String tiempo = '';
  int puntos = 0;
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;
  TtsState ttsState = TtsState.stopped;
  SpeechToText speechToText = SpeechToText();
  var showButtons = false.obs;
  late Timer _textDisplayTimer;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  bool get isPressed => _isPressed;

  @override
  onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
  }

  void datos(User a, String tmp, int ptn) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    update();
  }

  List<Color> backgroundColors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    // Agrega más colores según sea necesario
  ];

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

  void results() {
    print("Los resultados son $resultsOption");
  }

  Future<void> startRecognition() async {
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          speed = result.recognizedWords.obs;
        },
        localeId: 'es_Es',
      );
    }
  }

  void changeVariableValue() {
    isLisent.value = !isLisent.value;
  }

  void puntuacion(String text, String answers) {
    final comparison = text.similarityTo(answers);
    print(comparison);
    if (comparison > 0.5) {
      puntuacionText++;
      print(use.fullname);
      print("tiempo $tiempo");
      print("Puntuacion $puntos");
      print("Puntuacion Texto $puntuacionText");
    } else {
      print(use.fullname);
      print("tiempo $tiempo");
      print("Puntuacion $puntos");
      print("Puntuacion Sin Sumar $puntuacionText");
    }
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == ImgC().optionsText.length - 1) {
        Get.offAllNamed('/prolecD_A');
        Get.find<ProlecDAController>()
            .datos(use, tiempo, puntos, puntuacionText);
      } else {
        _isPressed = false;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }
}
