// ignore_for_file: avoid_print, unnecessary_overrides
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/prolecb_model.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import '../../models/user.dart';

/// `ProlecbController` es una subclase de `GetxController` que se utiliza para manejar varias operaciones en la aplicación.
///
/// Esta clase contiene varios métodos y variables para manejar operaciones como la navegación entre páginas,
/// el seguimiento de los resultados de las preguntas y la interacción con Firestore para obtener y actualizar datos.
///
/// La clase `ProlecbController` se utiliza principalmente en la aplicación para controlar el flujo de la aplicación,
/// manejar el estado de la aplicación y realizar operaciones relacionadas con las preguntas y respuestas de la aplicación.
class ProlecbController extends GetxController {
  int puntuacion = 0;
  late PageController pageController;
  Map<String, String> badResult = {};
  Map<String, String> goodResult = {};
  String numImg = "";
  late User use;
  String tiempo = '';
  List<OptionsModel> imgOption = [];

  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void results(bool result, String frase, String num) {
    numImg = identificarImagen(num);
    if (result == true) {
      puntuacion++;
      goodResult[frase] = "Número Img: $numImg";
      print(goodResult);
      print(puntuacion);
    } else {
      badResult[frase] = "Número Img: $numImg";
      print(puntuacion);
      print(badResult);
    }
  }

  String identificarImagen(String nombreImagen) {
    final terminaciones = {
      "1.png": "1",
      "2.png": "2",
      "3.png": "3",
      "4.png": "4",
    };
    for (final entry in terminaciones.entries) {
      if (nombreImagen.endsWith(entry.key)) {
        return entry.value;
      }
    }
    return "No identificado";
  }

  void datos(User a, String crono) {
    use = a;
    tiempo = crono;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == imgOption.length - 1) {
        print(puntuacion);
        Get.offAllNamed('/prolecC');
        Get.find<InitController>()
            .datos(use, tiempo, puntuacion, 0, 0, 0, 0, 0, 0);
        addInformeImg(badResult, "ERRORES");
        addInformeImg(goodResult, "Aciertos");
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
        print(use.fullname);
        print(tiempo);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
