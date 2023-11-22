import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/seudo.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import '../../models/user.dart';

class ProlecRAController extends GetxController {
  late int puntuacion = 0;
  late PageController pageController;
  List<String> goodResult = [];
  List<String> badResult = [];
  List<SeudoModel> seuModel = [];
  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;
  int puntosIA = 0;

  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO, int pntIA) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == seuModel.length - 1) {
        Get.offAllNamed('/prolecRB');
        Get.find<InitController>().datos(
            use, tiempo, puntos, puntosH, puntosO, puntosIA, puntuacion, 0, 0);
        addInforme(badResult, "Antonimos", "ERRORES");
        addInforme(goodResult, "Antonimos", "ACIERTOS");
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void results(bool result, String palabra) {
    if (result == true) {
      puntuacion++;
      goodResult.add(palabra);
      print("Plabras correctas $goodResult puntuacion:$puntuacion");
    } else {
      badResult.add(palabra);
      print("Plabras incorrectas $badResult puntuacion:$puntuacion");
    }
  }
}
