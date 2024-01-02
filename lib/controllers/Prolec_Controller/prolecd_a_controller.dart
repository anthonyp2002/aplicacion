// ignore_for_file: unnecessary_null_comparison, unused_local_variable, avoid_prints, avoid_print, unused_field
import 'package:aplicacion/controllers/Prolec_Controller/prolecd_b_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/doc_model.dart';
import '../../models/user.dart';

/// `ProlecDAController` es una subclase de `GetxController` que se utiliza para manejar varias operaciones en la aplicación.
///
/// Esta clase contiene varios métodos y variables observables para manejar operaciones como el reconocimiento de voz,
/// la manipulación de palabras y el cronómetro. También se encarga de la interacción con Firestore para obtener y actualizar datos.
///
/// La clase `ProlecDAController` se utiliza principalmente en la aplicación para controlar el flujo de la aplicación,
/// manejar el estado de la aplicación y realizar operaciones de reconocimiento de voz.
class ProlecDAController extends GetxController {
  Dog dog = Dog();
  double pitch = 1.0;
  double rate = 0.5;
  int tap = 0;
  late PageController pageController;
  int tapCounter = 0;
  int puntuacion = 0;

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

  @override
  onInit() {
    pageController = PageController(initialPage: 0);
    screenWidth = Get.width;
    screenHeight = Get.height;
    super.onInit();
  }

  void datos(User a, String tmp, int ptn, int pntH) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      Get.lazyPut(() => ProlecDBController);

      if (pageController.page == 2) {
        Get.offAllNamed('/prolecD_B');

        Get.find<ProlecDBController>()
            .datos(use, tiempo, puntos, puntosH, puntuacion);
        Get.offAllNamed('/prolecD_B');
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
        xPosition = 0.0.obs;
        yPosition = 0.0.obs;
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
}
