// ignore: file_names
import 'package:aplicacion/controllers/UseController/studentcontroller.dart';
import 'package:aplicacion/models/seudo.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        BuildContext,
        Curves,
        PageController,
        Text,
        TextButton,
        showDialog;
import "package:get/get.dart";
import '../../models/user.dart';

enum TtsState { playing, stopped }

class ProlecRCController extends GetxController {
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
  int puntosIB = 0;
  int puntosIC = 0;

  @override
  onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO, int pntIA,
      int pntIB, int pntIC) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    puntosIB = pntIB;
    puntosIC = pntIC;
    update();
  }

  void nextQuestions() {
    if (pageController.positions.isNotEmpty) {
      if (pageController.page == seuModel.length - 1) {
        // ignore: avoid_print
        print("Acabado");
        addCuestionario(use.fullname, tiempo, puntos, puntosH, puntosO,
            puntosIA, puntosIB, puntosIC, puntuacion);
        addInforme(badResult, "Sinonimos", "ERRORES");
        addInforme(goodResult, "Sinonimos", "ACIERTOS");
        _mostrarAgradecimiento();
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  void _mostrarAgradecimiento() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Gracias!'),
          content: const Text('Gracias por completar el cuestionario.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.lazyPut(() => StudentController());
                Get.offAllNamed('/studentPage');
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
