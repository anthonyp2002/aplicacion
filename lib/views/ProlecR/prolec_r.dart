// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../api/seudolapalabras.dart';
import '../../controllers/ProlecR_Controller/prolecrcontroller.dart';
import '../../models/user.dart';

class ProlecRPage extends GetView<ProlecRController> {
  @override
  Widget build(BuildContext context) {
    controller.speak();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(85, 0, 255, 0.808),
              Color.fromRGBO(176, 252, 255, 0.808)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Instrucciones del Ejercicio",
                style: GoogleFonts.ysabeau(fontSize: 25, color: Colors.black),
              ),
              const SizedBox(height: 30),
              Image.asset('assets/as.png', width: 280),
              const SizedBox(height: 60),
              SizedBox(
                width: 300,
                height: 150,
                child: StreamBuilder<String>(
                    stream: controller.speechTextStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ysabeau(
                                fontSize: 32, color: Colors.black));
                      } else {
                        return const Text(
                          '',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        );
                      }
                    }),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Visibility(
                  visible: controller.showButtons.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.speak();
                        },
                        child: const Text('Repetir'),
                      ),
                      const SizedBox(width: 85),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => ProlecFive(
                                      usuario: controller.use,
                                      time: controller.tiempo,
                                      puntuacion: controller.puntos,
                                      puntH: controller.puntosH,
                                      puntO: controller.puntosO,
                                    )),
                          );
                        },
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ProlecFive extends GetView<ProlecRController> {
  User usuario;
  String time;
  int puntuacion;
  int puntH;
  int puntO;
  ProlecFive({
    Key? key,
    required this.usuario,
    required this.time,
    required this.puntuacion,
    required this.puntH,
    required this.puntO,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProlecRController());
    controller.datos(usuario, time, puntuacion, puntH, puntO);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: SeuModel().seuModel.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            SeuModel().seuModel[index].palabras!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(fontSize: 30),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20)),
                          MaterialButton(
                            onPressed: () {
                              Get.offAllNamed('/prolecRA');
                            },
                            child: const Text("Cambiar "),
                          ),
                          SizedBox(
                            width: 500,
                            height: 500,
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              children: SeuModel()
                                  .seuModel[index]
                                  .answer
                                  .entries
                                  .map((palabras) {
                                return GestureDetector(
                                    onTap: () {
                                      controller.results(palabras.value);
                                      controller.nextQuestions();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          palabras.key,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ));
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
