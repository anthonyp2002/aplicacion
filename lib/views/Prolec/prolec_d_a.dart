// ignore_for_file: unnecessary_null_comparison, override_on_non_overriding_member, must_be_immutable, use_key_in_widget_constructors
import 'package:aplicacion/controllers/initController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/Prolec_Controller/prolecd_a_controller.dart';
import '../../models/user.dart';

class ProlecDAPage extends GetView<InitController> {
  @override
  Widget build(BuildContext context) {
    controller.enunciado = "Realize lo que diga las siguientes acciones";
    controller.speak();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(12, 192, 223, 1.0),
              Color.fromRGBO(255, 222, 89, 0)
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
                                builder: (context) => ProlecFour(
                                    usuario: controller.use,
                                    time: controller.tiempo,
                                    puntos: controller.puntos,
                                    puntosH: controller.puntosH)),
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

class ProlecFour extends GetView<ProlecDAController> {
  User usuario;
  String time;
  int puntos;
  int puntosH;
  ProlecFour(
      {Key? key,
      required this.usuario,
      required this.time,
      required this.puntos,
      required this.puntosH})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProlecDAController());
    controller.datos(usuario, time, puntos, puntosH);
    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/prolec_for.png'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return SizedBox(
                              child: Center(
                                child: Column(
                                  children: [
                                    _one(context, setState),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20)),
                                  ],
                                ),
                              ),
                            );
                          } else if (index == 1) {
                            return Center(
                              child: Column(
                                  children: [_pictures(context, setState)]),
                            );
                          } else if (index == 2) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [imgpicures(context, setState)],
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _one(BuildContext context, setState) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            height: 200,
            child: Text(
              textAlign: TextAlign.center,
              "Da tres toques sobre el cuadrado dibujado",
              style: GoogleFonts.barlow(fontSize: 25),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0)),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  controller.tapCounter++;
                  print(controller.tapCounter);
                  if (controller.tapCounter == 3) {
                    controller.tapCounter = 0;
                    controller.nextQuestions();
                    controller.puntuacion++;
                  }
                });
              },
              child: Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pictures(BuildContext context, setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            double newX = controller.xPosition.value + details.delta.dx;
            double newY = controller.yPosition.value + details.delta.dy;
            controller.updatePosition(newX, newY);
          },
          child: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              height: 450,
              child: LayoutBuilder(builder: (context, constraints) {
                controller.containerWidth = constraints.maxWidth;
                controller.containerHeight = constraints.maxHeight;
                return Obx(() => Stack(
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20)),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Ponle el sombrero al payasso",
                            style: GoogleFonts.barlow(fontSize: 25),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20)),
                        Align(
                          child: Image.asset(
                            'assets/payasso_som.png',
                            width: 250,
                            height: 350,
                          ),
                        ),
                        Positioned(
                          left: controller.xPosition.value,
                          top: controller.yPosition.value,
                          child: Image.asset(
                            'assets/som_payasso.png',
                            width: 100,
                            height: 200,
                          ),
                        ),
                      ],
                    ));
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget imgpicures(BuildContext context, setState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 500,
            height: 500,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 70,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Da tres toques sobre el cuadrado dibujado",
                    style: GoogleFonts.barlow(fontSize: 25),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.dog.tailTouched =
                                  !controller.dog.tailTouched;
                              controller.checkCompletion();
                            });
                          },
                          child: Image.asset(
                            'assets/p0_col.png',
                            width: 110,
                            height: 110,
                            color:
                                controller.dog.tailTouched ? Colors.grey : null,
                            colorBlendMode: controller.dog.tailTouched
                                ? BlendMode.saturation
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 177,
                        left: 60,
                        child: Image.asset(
                          'assets/p0_iz.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Positioned(
                        top: 177,
                        left: 140,
                        child: Image.asset(
                          'assets/p0_iz.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Positioned(
                        top: 35,
                        left: 20,
                        child: Image.asset(
                          'assets/p0_cu.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Positioned(
                        top: 135,
                        left: 195,
                        child: Image.asset(
                          'assets/p0_len.png',
                          width: 65,
                          height: 65,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 137,
                        child: Image.asset(
                          'assets/p1_ca.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Positioned(
                        top: 35,
                        left: 104,
                        child: Image.asset(
                          'assets/p2_ore.png',
                          width: 115,
                          height: 115,
                        ),
                      ),
                      Positioned(
                        top: 46,
                        left: 190,
                        child: Image.asset(
                          'assets/p3_ce.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Positioned(
                        top: 66,
                        left: 200,
                        child: Image.asset(
                          'assets/p4_ojo.png',
                          width: 62,
                          height: 62,
                        ),
                      ),
                      Positioned(
                        top: 103,
                        left: 221,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.dog.noseTouched =
                                  !controller.dog.noseTouched;
                              controller.checkCompletion();
                            });
                          },
                          child: Image.asset(
                            'assets/p5_na.png',
                            width: 30,
                            height: 30,
                            color:
                                controller.dog.noseTouched ? Colors.grey : null,
                            colorBlendMode: controller.dog.noseTouched
                                ? BlendMode.saturation
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 175,
                        left: 100,
                        child: Image.asset(
                          'assets/p6_de.png',
                          width: 75,
                          height: 75,
                        ),
                      ),
                      Positioned(
                        top: 175,
                        left: 20,
                        child: Image.asset(
                          'assets/p6_de.png',
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
