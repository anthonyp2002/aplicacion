// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:aplicacion/controllers/Prolec_Controller/prolecc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../api/data_img.dart';
import '../../controllers/Prolec_Controller/prolecb_controller.dart';
import '../../models/user.dart';

class ProlecbPage extends GetView<ProlecbController> {
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
                                builder: (context) => ProlecTwo(
                                    usuario: controller.use,
                                    time: controller.tiempo)),
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

class ProlecTwo extends GetView<ProlecbController> {
  User usuario;
  String time;
  ProlecTwo({Key? key, required this.usuario, required this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProlecbController());
    controller.datos(usuario, time);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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
                      'Instrucciones del ejercicio',
                      style: GoogleFonts.barlow(fontSize: 20),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: PageView.builder(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Img().imgOption.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 315,
                              height: 60,
                              child: Text(
                                Img().imgOption[index].questions!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ysabeau(fontSize: 20),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            SizedBox(
                              width: 400,
                              height: 400,
                              child: GridView.count(
                                crossAxisCount: 2,
                                children: Img()
                                    .imgOption[index]
                                    .answer
                                    .entries
                                    .map((image) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.results(image.value);
                                      controller.nextQuestions();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Image.asset(
                                        image.key,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Get.find<ProlecCController>()
                        .datos(controller.use, controller.tiempo, 8);
                    Get.offAllNamed('/prolecC');
                  },
                  child: const Text("Cambiar "),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
