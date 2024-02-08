// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/prolecb_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/Prolec_Controller/prolecb_controller.dart';
import '../../models/user.dart';

class ProlecbPage extends GetView<InitController> {
  @override
  Widget build(BuildContext context) {
    Get.put(InitController());
    controller.enunciado = "Presione la imagen que coincida con el enunciado";
    controller.speak();
    controller.recuperarDatosImg();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(157, 192, 255, 1),
              Color.fromRGBO(205, 255, 216, 1.0)
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
                      RawMaterialButton(
                        onPressed: () {
                          controller.speak();
                        },
                        constraints: const BoxConstraints(
                          minHeight: 40, // Altura mínima
                          minWidth: 100, // Ancho mínimo
                        ),
                        fillColor: const Color.fromARGB(255, 175, 235, 244),
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
                                builder: (context) => ProlecTwo(
                                      usuario: controller.use,
                                      time: controller.tiempo,
                                      imgOptn: controller.imgOption,
                                    )),
                          );
                        },
                        constraints: const BoxConstraints(
                          minHeight: 40, // Altura mínima
                          minWidth: 100, // Ancho mínimo
                        ),
                        fillColor: const Color.fromARGB(255, 175, 235, 244),
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

class ProlecTwo extends GetView<ProlecbController> {
  User usuario;
  String time;
  List<OptionsModel> imgOptn = [];
  ProlecTwo(
      {Key? key,
      required this.usuario,
      required this.time,
      required this.imgOptn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProlecbController());
    controller.datos(usuario, time);
    controller.imgOption = imgOptn;
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/prolec_two.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 35)),
                    SingleChildScrollView(
                      child: Container(
                        height: isDesktop
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height - 200,
                        child: PageView.builder(
                          controller: controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.imgOption.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: isDesktop ? 400 : 315,
                                  height: isDesktop ? 90 : 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: const Color(0xFF17203A),
                                  ),
                                  child: Text(
                                    controller.imgOption[index].questions!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ysabeau(
                                        fontSize: isDesktop ? 30 : 25,
                                        color: Colors.white),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                                SizedBox(
                                  width: isDesktop ? 600 : 400,
                                  height: isDesktop ? 600 : 400,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    children: controller
                                        .imgOption[index].answer.entries
                                        .map((image) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.results(
                                            image.value,
                                            controller
                                                .imgOption[index].questions!,
                                            image.key,
                                          );
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
                        Get.find<InitController>().datos(controller.use,
                            controller.tiempo, 8, 0, 0, 0, 0, 0, 0);
                        Get.offAllNamed('/prolecC');
                      },
                      child: const Text("Cambiar "),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
