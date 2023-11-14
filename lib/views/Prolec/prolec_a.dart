// ignore_for_file: must_be_immutable

import 'package:aplicacion/controllers/Prolec_Controller/prolecb_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/Prolec_Controller/prolec_controller.dart';
import '../../models/user.dart';

class ProlecPage extends GetView<ProlecController> {
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
                                builder: (context) =>
                                    ProlecOne(usuario: controller.use)),
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

class ProlecOne extends GetView<ProlecController> {
  User usuario;
  ProlecOne({Key? key, required this.usuario}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProlecController());
    controller.startRecognition();
    controller.iniciarCronometro();
    controller.obtenerTiempoFormateado();
    controller.datos(usuario);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => AvatarGlow(
            endRadius: 75.0,
            animate: true,
            duration: const Duration(milliseconds: 2000),
            glowColor: controller.isLisent.value ? Colors.red : Colors.blue,
            repeat: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            showTwoGlows: true,
            child: GestureDetector(
              onTapDown: (details) {
                controller.startRecognition();
              },
              child: CircleAvatar(
                backgroundColor:
                    controller.isLisent.value ? Colors.red : Colors.blue,
                radius: 30,
                child: Icon(
                    controller.isLisent.value ? Icons.mic : Icons.mic_none,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
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
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text(
                    "Instrucciones del ejercicio",
                    style: GoogleFonts.barlow(fontSize: 20),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Obx(() => Text(
                    controller.obtenerTiempoFormateado(),
                    style: GoogleFonts.barlow(fontSize: 20),
                  )),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                width: 550,
                height: 200,
                child: Obx(
                  () => Center(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      children: List.generate(
                          controller.palabrasVisibles.length, (index) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              controller.palabrasVisibles[index],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Get.find<ProlecbController>().datos(controller.use, "00:40");
                  Get.offAllNamed('/prolecB');
                },
                child: const Text("Cambiar "),
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                margin: const EdgeInsets.only(bottom: 100),
                child: Text(controller.words),
              ),
            ],
          ),
        ),
      );
    });
  }
}
