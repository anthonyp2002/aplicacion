import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/orto.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import '../../models/user.dart';

class ProlecRBController extends GetxController {
  late int puntuacion = 0;
  late PageController pageController;
  List<String> goodResult = [];
  List<String> badResult = [];
  List<OrtModel> seuModel = [];
  late User use;
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;
  int puntosIA = 0;
  int puntosIB = 0;

  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void datos(
      User a, String tmp, int ptn, int pntH, int pntO, int pntIA, int pntIB) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    puntosIB = pntIB;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == seuModel.length - 1) {
        Get.offAllNamed('/prolecRC');
        Get.find<InitController>().datos(use, tiempo, puntos, puntosH, puntosO,
            puntosIA, puntosIB, puntuacion, 0);
        addInforme(badResult, "Ortografia", "ERRORES");
        addInforme(goodResult, "Ortografia", "ACIERTOS");
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void results(bool result, String palabra) {
    if (result == true) {
      puntuacion++;
      print("Puntuacion Prolect 7");
      print(use.fullname);
      print(tiempo);
      print(puntos);
      print(puntosH);
      print(puntosO);
      print(puntosIA);
      print(puntosIB);
      goodResult.add(palabra);
      print("Plabras correctas $goodResult puntuacion:$puntuacion");
    } else {
      badResult.add(palabra);
      print("Plabras incorrectas $badResult puntuacion:$puntuacion");
    }
  }
}
