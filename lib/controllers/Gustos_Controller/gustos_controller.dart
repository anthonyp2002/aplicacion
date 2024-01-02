// ignore_for_file: unnecessary_overrides

import "package:aplicacion/controllers/UseController/studentcontroller.dart";
import "package:aplicacion/models/img_gustos.dart";
import "package:aplicacion/services/firebase_service.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

/// `GustosController` es una subclase de `GetxController` que se utiliza para manejar varias operaciones en la aplicación.
///
/// Esta clase contiene varios métodos y variables observables para manejar operaciones como el reconocimiento de voz,
/// la manipulación de palabras y el cronómetro. También se encarga de la interacción con Firestore para obtener y actualizar datos.
///
/// La clase `GustosController` se utiliza principalmente en la aplicación para controlar el flujo de la aplicación,
/// manejar el estado de la aplicación y realizar operaciones.
class GustosController extends GetxController {
  int puntuacion = 0;
  late PageController pageController;
  Map<String, String> badResult = {};
  Map<String, String> goodResult = {};
  String numImg = "";
  String tiempo = '';
  List<ImgGustos> imggustos = [];
  List selectedImages = []; // Agregar esta línea
  List misGustos = [];
  String tipe = "";
  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void nextQuestions() {
    addGusto(selectedImages, tipe);
    selectedImages.clear();
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == imggustos.length - 1) {
        Get.lazyPut(() => StudentController());
        Get.offAllNamed('/studentPage');
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void gustos(String img) {
    if (selectedImages.contains(img)) {
      // Si existe, eliminar el dato antes de agregar el nuevo
      selectedImages.remove(img);
    } else {
      selectedImages.add(img);
      print(selectedImages);
      print(tipe);
    }
  }
}
