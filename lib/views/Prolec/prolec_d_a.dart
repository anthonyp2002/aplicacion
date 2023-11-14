// ignore_for_file: unnecessary_null_comparison, override_on_non_overriding_member, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/Prolec_Controller/prolecd_a_controller.dart';
import '../../models/user.dart';

class ProlecDAPage extends GetView<ProlecDAController> {
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
                                builder: (context) => ProlecFour(
                                    usuario: controller.use,
                                    time: controller.tiempo,
                                    puntos: controller.puntos,
                                    puntosH: controller.puntosH)),
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
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text("Prolec"),
        ),
        body: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
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
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text(
                      "Instrucciones del ejercicio",
                      style: GoogleFonts.barlow(fontSize: 20),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    itemCount: 4,
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
                          child:
                              Column(children: [_pictures(context, setState)]),
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
      );
    });
  }

  Widget _one(BuildContext context, setState) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Da tres toques sobre el cuadrado dibujado",
            style: GoogleFonts.barlow(fontSize: 25),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0)),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  controller.tapCounter++;
                  if (controller.tapCounter == 3) {
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
            height: 450,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Señale la nariz y la cola del perro",
                    style: GoogleFonts.barlow(fontSize: 25),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Positioned(
                  top: 125,
                  left: 60,
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
                      color: controller.dog.tailTouched ? Colors.grey : null,
                      colorBlendMode: controller.dog.tailTouched
                          ? BlendMode.saturation
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  top: 292,
                  left: 150,
                  child: Image.asset(
                    'assets/p0_iz.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                Positioned(
                  top: 292,
                  left: 230,
                  child: Image.asset(
                    'assets/p0_iz.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 85,
                  child: Image.asset(
                    'assets/p0_cu.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Positioned(
                  top: 245,
                  left: 270,
                  child: Image.asset(
                    'assets/p0_len.png',
                    width: 65,
                    height: 65,
                  ),
                ),
                Positioned(
                  top: 125,
                  left: 223,
                  child: Image.asset(
                    'assets/p1_ca.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 190,
                  child: Image.asset(
                    'assets/p2_ore.png',
                    width: 115,
                    height: 115,
                  ),
                ),
                Positioned(
                  top: 127,
                  left: 274,
                  child: Image.asset(
                    'assets/p3_ce.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                Positioned(
                  top: 171,
                  left: 287,
                  child: Image.asset(
                    'assets/p4_ojo.png',
                    width: 62,
                    height: 62,
                  ),
                ),
                Positioned(
                  top: 208,
                  left: 308,
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
                      color: controller.dog.noseTouched ? Colors.grey : null,
                      colorBlendMode: controller.dog.noseTouched
                          ? BlendMode.saturation
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  top: 290,
                  left: 190,
                  child: Image.asset(
                    'assets/p6_de.png',
                    width: 75,
                    height: 75,
                  ),
                ),
                Positioned(
                  top: 290,
                  left: 100,
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
    );
  }
}
