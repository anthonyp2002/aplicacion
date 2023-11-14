// ignore: file_names
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        BuildContext,
        Curves,
        Navigator,
        PageController,
        Text,
        TextButton,
        showDialog;
import "package:get/get.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../api/sinonimos.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped }

class ProlecRCController extends GetxController {
  late FlutterTts flutterTts;
  String? language;
  String? enunciado =
      'Presione la palabra que signifique lo mismo que la palabra mostrada.';
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  late int puntuacion = 0;
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
  int puntosIC = 0;

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

  void datos(User a, String tmp, int ptn, int pntH, int pntO, int pntIA,
      int pntIB, int pntIC) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    puntosIB = pntIB;
    puntosIC = pntIC;
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
      if (pageController.page == SinoModel().seuModel.length - 1) {
        // ignore: avoid_print
        print("Acabado");
        addPunctuations(use.fullname, tiempo, puntos, puntosH, puntosO,
            puntosIA, puntosIB, puntosIC, puntuacion);
        _mostrarAgradecimiento();
      } else {
        _isPressed = false;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void _mostrarAgradecimiento() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Gracias!'),
          content: const Text('Gracias por completar el cuestionario.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void results(bool result) {
    resultsOption.add(result);
    if (result == true) {
      puntuacion++;
    }
  }

  void correct(BuildContext index) {}
}
