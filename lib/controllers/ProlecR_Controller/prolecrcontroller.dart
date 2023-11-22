// ignore_for_file: avoid_print
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/seudo.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import '../../models/user.dart';

class ProlecRController extends GetxController {
  int puntuacion = 0;
  late PageController pageController;
  List<String> goodResult = [];
  List<String> badResult = [];
  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;

  List<SeudoModel> seuModel = [];

  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == seuModel.length - 1) {
        Get.offAllNamed('/prolecRA');
        Get.find<InitController>()
            .datos(use, tiempo, puntos, puntosH, puntosO, puntuacion, 0, 0, 0);
        addInforme(badResult, "Seudopalabras", "ERRORES");
        addInforme(goodResult, "Seudopalabras", "ACIERTOS");
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
    print(use.fullname);
    print(tiempo);
    print(puntosO);
    print(puntosH);
  }
}
