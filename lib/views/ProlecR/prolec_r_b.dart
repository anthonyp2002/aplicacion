// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../api/ortografia.dart';
import '../../controllers/ProlecR_Controller/prolecrbcontroller.dart';
import '../../models/user.dart';

class ProlecRBPage extends GetView<ProlecRBController> {
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
                                builder: (context) => ProlecSeven(
                                    usuario: controller.use,
                                    time: controller.tiempo,
                                    puntuacion: controller.puntos,
                                    puntH: controller.puntosH,
                                    puntO: controller.puntosO,
                                    puntIA: controller.puntosIA,
                                    puntIB: controller.puntosIB)),
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

class ProlecSeven extends GetView<ProlecRBController> {
  User usuario;
  String time;
  int puntuacion;
  int puntH;
  int puntO;
  int puntIA;
  int puntIB;
  ProlecSeven(
      {Key? key,
      required this.usuario,
      required this.time,
      required this.puntuacion,
      required this.puntH,
      required this.puntO,
      required this.puntIA,
      required this.puntIB})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProlecRBController());
    controller.datos(usuario, time, puntuacion, puntH, puntO, puntIA, puntIB);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text("Ortografía"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.speak();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Center(
                          child: Icon(
                            Icons.volume_up,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15)),
                    Text(
                      'Instrucciones',
                      style: GoogleFonts.barlow(fontSize: 20),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    Get.offAllNamed('/prolecRC');
                  },
                  child: const Text("Cambiar "),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: OrotModel().seuModel.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500,
                            height: 500,
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              children: OrotModel()
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
                                        color: Colors.orange.shade300,
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
