// ignore_for_file: avoid_print, unused_field
import 'package:aplicacion/controllers/Prolec_Controller/prolecb_controller.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/user.dart';

enum TtsState { playing, stopped, paused }

class ProlecController extends GetxController {
  final RxList<String> palabrasVisibles = <String>[].obs;
  final RxInt indexPalabra = 0.obs;
  late FlutterTts flutterTts;
  bool isMicrophoneActive = false;
  Rx<Color> containerColor = Rx<Color>(Colors.blue);
  RxInt selectedContainerIndex = RxInt(0);
  String words = "";
  List<dynamic> result = [];
  List<String> p = [];
  String? language;
  String? enunciado =
      "Lea las palabras en voz alta que aparezcan en la pantalla";
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  MaterialColor colorsp = Colors.green;
  MaterialColor colorsLec = Colors.green;
  bool isCurrentLanguageInstalled = false;
  RxInt seconds = 0.obs;
  var isLisent = false.obs;
  var isSelect = false;
  String? speed = "Di la palabra";
  SpeechToText speechToText = SpeechToText();
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;
  List<String> palabras = [];

  late Timer cronometro;
  late User use;
  String name = '';

  String? _newVoiceText;

  late Timer _textDisplayTimer;
  TtsState ttsState = TtsState.stopped;
  var showButtons = false.obs;
  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  @override
  onInit() async {
    super.onInit();
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
    palabras = await getPal();
    cargarPalabras();
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

  void iniciarCronometro() {
    cronometro = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value++;
    });
  }

  void datos(User a) {
    use = a;
    update();
  }

  Future<void> startRecognition() async {
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          words = result.recognizedWords;
          results();
        },
        localeId: 'es_Es',
      );
    }
  }

  void changeVariableValue() {
    isLisent.value = !isLisent.value;
  }

  String obtenerTiempoFormateado() {
    int segundos = seconds.value % 60;
    int minutos = (seconds ~/ 60) % 60;
    String segundosStr = (segundos < 10) ? '0$segundos' : segundos.toString();
    String minutosStr = (minutos < 10) ? '0$minutos' : minutos.toString();
    return '$minutosStr:$segundosStr';
  }

  void cargarPalabras() {
    palabrasVisibles.value =
        palabras.sublist(indexPalabra.value, indexPalabra.value + 4);
    p = palabras.sublist(indexPalabra.value, indexPalabra.value + 4);
  }

  void cambiarPalabras() {
    indexPalabra.value += 4;
    if (indexPalabra.value >= palabras.length) {
      cronometro.cancel();
      print(obtenerTiempoFormateado());
      print("pase");
      Get.offAllNamed('/prolecB');
      Get.find<ProlecbController>().datos(use, obtenerTiempoFormateado());
      isLisent = false.obs;
    }
    cargarPalabras();
  }

  int numberPalabras() {
    int a;
    if (selectedContainerIndex.value == palabrasVisibles.length - 1) {
      a = selectedContainerIndex.value = 0;
      return a;
    } else {
      a = selectedContainerIndex.value + 1;
      return a;
    }
  }

  void results() {
    List<String> f = [];
    for (String pal in p) {
      if (!words.toLowerCase().contains(pal.toLowerCase())) {
        f.add(pal);
      }
    }

    if (f.isEmpty) {
      cambiarPalabras();
      startRecognition();
    } else {
      startRecognition();
    }
  }
}
