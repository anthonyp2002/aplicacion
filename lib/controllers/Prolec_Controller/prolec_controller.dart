// ignore_for_file: unnecessary_overrides

import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/user.dart';

class ProlecController extends GetxController {
  final RxList<String> palabrasVisibles = <String>[].obs;
  final RxInt indexPalabra = 0.obs;
  bool isMicrophoneActive = false;
  Rx<Color> containerColor = Rx<Color>(Colors.blue);
  RxInt selectedContainerIndex = RxInt(0);
  String words = "";
  List<String> p = [];
  RxInt seconds = 0.obs;
  var isLisent = false.obs;
  SpeechToText speechToText = SpeechToText();
  List<String> palabras = [];
  late Timer cronometro;
  late User use;
  String name = '';

  @override
  onInit() async {
    super.onInit();
    palabras = await getPal();
    cargarPalabras();
  }

  @override
  void dispose() {
    super.dispose();
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
      dispose();
      Get.offAllNamed('/prolecB');
      Get.find<InitController>()
          .datos(use, obtenerTiempoFormateado(), 0, 0, 0, 0, 0, 0, 0);
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
