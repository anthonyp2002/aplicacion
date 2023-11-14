// ignore_for_file: unnecessary_null_comparison, unused_local_variable, avoid_prints, avoid_print, unused_field
import 'package:aplicacion/controllers/Prolec_Controller/prolecd_b_controller.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/doc_model.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped, paused }

class ProlecDAController extends GetxController {
  late FlutterTts flutterTts;
  String? language;
  String? enunciado = "Realize lo que diga las siguientes acciones";
  String? engine;
  double volume = 0.5;
  Dog dog = Dog();
  bool showCollisionMessage = false;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  int tap = 0;
  String? speed = "Di la palabra";
  SpeechToText speechToText = SpeechToText();
  late Timer cronometro;
  late PageController pageController;
  int tapCounter = 0;
  int puntuacion = 0;
  TtsState ttsState = TtsState.stopped;
  String? _newVoiceText;
  get isPlaying => ttsState == TtsState.playing;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
  RxDouble xPosition = 0.0.obs;
  RxDouble yPosition = 0.0.obs;
  double containerWidth = 0.0;
  double containerHeight = 0.0;
  double screenWidth = 0.0;
  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  double screenHeight = 0.0;
  final GlobalKey<SignatureState> signatureKey = GlobalKey<SignatureState>();
  bool isWhiskersDrawn = false;
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;
  late Timer _textDisplayTimer;
  var showButtons = false.obs;

  @override
  onInit() {
    pageController = PageController(initialPage: 0);
    screenWidth = Get.width;
    screenHeight = Get.height;
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
    super.onInit();
  }

  void datos(User a, String tmp, int ptn, int pntH) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
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

  void showMatchingImagesMessage() {
    showCollisionMessage = false;
    Get.snackbar('¡Imágenes iguales!', 'Las dos imágenes son iguales');
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

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == 2) {
        Get.offAllNamed('/prolecD_B');
        Get.find<ProlecDBController>()
            .datos(use, tiempo, puntos, puntosH, puntuacion);
      } else {
        print("Paginas");
        print(pageController.positions.isNotEmpty);
        print(pageController.page);
        print(use.fullname);
        print(puntos);
        print(tiempo);
        print(puntosH);
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  Future<void> updatePosition(double newX, double newY) async {
    newX = newX.clamp(0, containerWidth - 100);
    newY = newY.clamp(0, containerHeight - 150);
    if (newX < 0) {
      newX = 0;
    } else if (newX > containerWidth - 100) {
      newX = containerWidth - 100;
    }
    if (newY < 0) {
      newY = 0;
    } else if (newY > containerHeight - 100) {
      newY = containerHeight - 100;
    }
    xPosition.value = newX;
    yPosition.value = newY;

    if ((xPosition.value >= 130 && xPosition.value <= 270) &&
        (yPosition.value >= 30 && yPosition.value <= 70)) {
      bool positionMatched =
          await Future.delayed(const Duration(seconds: 1), () {
        return (xPosition.value >= 130 && xPosition.value <= 270) &&
            (yPosition.value >= 30 && yPosition.value <= 70);
      });
      if (positionMatched) {
        nextQuestions();
        puntuacion++;
      }
    } else {}
  }

  void checkCompletion() {
    if (dog.noseTouched && dog.tailTouched) {
      nextQuestions();
      puntuacion++;
    }
  }

  void resetWhiskers(setState) {
    final signature = signatureKey.currentState;
    if (signature != null) {
      signature.clear();
      setState(() {
        isWhiskersDrawn = false;
      });
    }
  }
}
