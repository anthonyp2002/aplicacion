// ignore_for_file: unnecessary_overrides

import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/user.dart';

/// `ProlecController` es una subclase de `GetxController` que se utiliza para manejar varias operaciones en la aplicación.
///
/// Esta clase contiene varios métodos y variables observables para manejar operaciones como el reconocimiento de voz,
/// la manipulación de palabras y el cronómetro. También se encarga de la interacción con Firestore para obtener y actualizar datos.
///
/// La clase `ProlecController` se utiliza principalmente en la aplicación para controlar el flujo de la aplicación,
/// manejar el estado de la aplicación y realizar operaciones de reconocimiento de voz.
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

  void iniciarCronometro() {
    cronometro = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value++;
    });
  }

  void datos(User a) {
    use = a;
    print("El use es $use");
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
      print(use.fullname);
      cronometro.cancel();
      dispose();
      Get.put(InitController());
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
