// ignore_for_file: avoid_print, unused_field
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/prolcec_model.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import '../../models/user.dart';

/// `ProlecCController` es una subclase de `GetxController` que se utiliza para manejar varias operaciones en la aplicación.
///
/// La clase ProlecCController en Flutter es un controlador que se utiliza para manejar varias operaciones en la aplicación.
/// Se inicializa con un PageController y contiene métodos para actualizar el usuario actual, el tiempo y los puntos,
/// cambiar el valor de una variable observable, comparar respuestas y actualizar puntuaciones, y navegar a la siguiente pregunta o página.
/// También interactúa con Firestore para actualizar los resultados.
///
/// La clase `ProlecCController` se utiliza principalmente en la aplicación para controlar el flujo de la aplicación,
/// manejar el estado de la aplicación y realizar operaciones de reconocimiento de voz.
class ProlecCController extends GetxController {
  late PageController pageController;
  var isLisent = false.obs;
  int puntuacionText = 0;
  late User use;
  String tiempo = '';
  int puntos = 0;
  String tit = "";
  List<Map<String, Map<String, String>>> goodResult = [];
  List<Map<String, Map<String, String>>> badResult = [];
  Map<String, String> ansG = {};
  Map<String, String> ansD = {};
  Map<String, Map<String, String>> preG = {};
  Map<String, Map<String, String>> preD = {};
  List<OptionsText> optionsText = [];
  @override
  onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void datos(User a, String tmp, int ptn) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    update();
  }

  void changeVariableValue() {
    isLisent.value = !isLisent.value;
  }

  void puntuacion(String pregunta, String text, String answers) {
    final comparison = text.similarityTo(answers);
    print(comparison);
    print("Titulo $tit");
    if (comparison > 0.5) {
      puntuacionText++;
      ansG["Respuesta correcta: $answers"] = "Respuesta dada: $text";
      preG[pregunta] = Map.from(ansG);
      goodResult.add(Map.from(preG));
      ansG.clear();
      preG.clear();
    } else {
      ansD["Respuesta correcta: $answers"] = "Respuesta dada: $text";
      preD[pregunta] = Map.from(ansD);
      badResult.add(Map.from(preD));
      ansD.clear();
      preD.clear();
    }
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == optionsText.length - 1) {
        Get.offAllNamed('/prolecD_A');
        Get.find<InitController>()
            .datos(use, tiempo, puntos, puntuacionText, 0, 0, 0, 0, 0);
        addInformeSt(badResult, tit, "ERRORES");
        addInformeSt(goodResult, tit, "ACIERTOS");
      } else {
        print("cambio page");
        addInformeSt(badResult, tit, "ERRORES");
        addInformeSt(goodResult, tit, "ACIERTOS");
        badResult.clear();
        goodResult.clear();
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }
}
