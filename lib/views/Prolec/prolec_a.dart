// ignore_for_file: must_be_immutable, use_key_in_widget_constructors
import 'package:aplicacion/controllers/initController.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/Prolec_Controller/prolec_controller.dart';
import '../../models/user.dart';

class ProlecPage extends GetView<InitController> {
  @override
  Widget build(BuildContext context) {
    Get.put(InitController());
    controller.enunciado =
        "Lea en voz alta las palabras que aparezcan en la pantalla";
    controller.speak();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(85, 0, 255, 0.808),
              Color.fromRGBO(176, 221, 255, 0.808)
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
                                fontSize: 30, color: Colors.black));
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
                      RawMaterialButton(
                        onPressed: () {
                          controller.speak();
                        },
                        constraints: const BoxConstraints(
                          minHeight: 40, // Altura mínima
                          minWidth: 100, // Ancho mínimo
                        ),
                        fillColor: const Color.fromARGB(206, 209, 242, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Text(
                          'Repetir',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 50),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProlecOne(usuario: controller.use)),
                          );
                        },
                        constraints: const BoxConstraints(
                          minHeight: 40, // Altura mínima
                          minWidth: 100, // Ancho mínimo
                        ),
                        fillColor: const Color.fromARGB(206, 209, 242, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
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
    Get.put(InitController());
    Get.put(ProlecController());
    controller.startRecognition();
    controller.iniciarCronometro();
    controller.obtenerTiempoFormateado();
    controller.datos(usuario);
    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/prolec_one.png'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Obx(
              () => AvatarGlow(
                endRadius: 75.0,
                animate: true,
                duration: const Duration(milliseconds: 2000),
                glowColor:
                    controller.isLisent.value ? Colors.blue : Colors.blue,
                repeat: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                showTwoGlows: true,
                child: GestureDetector(
                  onTapDown: (details) {
                    controller.startRecognition();
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        controller.isLisent.value ? Colors.blue : Colors.blue,
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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 80)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Color.fromARGB(255, 35, 97, 232),
                        size: 45,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5)),
                      Obx(() => Text(
                            controller.obtenerTiempoFormateado(),
                            style: GoogleFonts.barlow(fontSize: 45),
                          )),
                    ],
                  ),
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
                                color: const Color.fromARGB(255, 68, 137, 255),
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
                      Get.put(InitController());
                      Get.offAllNamed('/prolecB');
                      Get.find<InitController>()
                          .datos(controller.use, "00:41", 0, 0, 0, 0, 0, 0, 0);
                    },
                    child: const Text("Cambiar "),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
