// ignore_for_file: avoid_print, must_be_immutable

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';
import '../../../api/data_imgc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import '../../controllers/Prolec_Controller/prolecc_controller.dart';
import '../../models/user.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecd_a_controller.dart';

bool _isPressed = false;

class ProlecCPage extends GetView<ProlecCController> {
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
                                builder: (context) => ProlecThree(
                                      usuario: controller.use,
                                      time: controller.tiempo,
                                      puntuacion: controller.puntos,
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

class ProlecThree extends GetView<ProlecCController> {
  User usuario;
  String time;
  int puntuacion;
  ProlecThree(
      {Key? key,
      required this.usuario,
      required this.time,
      required this.puntuacion})
      : super(key: key);
  List<dynamic> resultsOption = [];
  List<dynamic> result = [];
  late FlutterTts flutterTts;
  late PageController pageController;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String speed = " ";
  var isLisent = false.obs;

  //TtsState ttsState = TtsState.stopped;
  SpeechToText speechToText = SpeechToText();

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  bool get isPressed => _isPressed;

  @override
  Widget build(BuildContext context) {
    Get.put(ProlecCController());
    controller.datos(usuario, time, puntuacion);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
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
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Text(
                      "Instrucciones del ejercicio",
                      style: GoogleFonts.barlow(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      100, // Establecer una altura explícita
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    itemCount: ImgC().optionsText.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 500,
                              height: 600,
                              child: Column(
                                children: [
                                  Text(
                                    ImgC().optionsText[index].titulo!,
                                    style: GoogleFonts.barlow(fontSize: 20),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  Expanded(
                                    child: SizedBox(
                                      width: 500,
                                      height: 400,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          ImgC().optionsText[index].text!,
                                          style:
                                              GoogleFonts.barlow(fontSize: 18),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Mostrar las preguntas una por una
                                      List<String> preguntas =
                                          ImgC().optionsText[index].questions;
                                      List<String> answers =
                                          ImgC().optionsText[index].answer;
                                      mostrarPreguntas(
                                          context, preguntas, answers);
                                      controller.changeVariableValue();
                                    },
                                    child: const Text('Ver preguntas'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Get.offAllNamed('/prolecD_A');
                                      Get.find<ProlecDAController>().datos(
                                          controller.use,
                                          controller.tiempo,
                                          controller.puntos,
                                          6);
                                    },
                                    child: const Text("Cambiar "),
                                  )
                                ],
                              ),
                            ),
                          )),
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

  void mostrarPreguntas(
    BuildContext context,
    List<String> preguntas,
    List<String> answers,
  ) {
    int index = 0;
    List<String> respuestas = [];
    bool bloqueado = true;
    void mostrarSiguientePregunta() {
      showDialog(
        context: context,
        barrierDismissible: !bloqueado,
        builder: (BuildContext context) {
          String respuesta = '';
          return AlertDialog(
            title: Text('Pregunta ${index + 1}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Text(preguntas[index]),
                        const SizedBox(height: 16),
                        Text(speed),
                        Obx(
                          () => AvatarGlow(
                            endRadius: 75.0,
                            animate: true,
                            duration: const Duration(milliseconds: 2000),
                            glowColor:
                                isLisent.value ? Colors.blue : Colors.blue,
                            repeat: true,
                            repeatPauseDuration:
                                const Duration(milliseconds: 100),
                            showTwoGlows: true,
                            child: GestureDetector(
                              onTapDown: (details) {
                                setState(() {
                                  start(setState);
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: controller.isLisent.value
                                    ? Colors.red
                                    : Colors.red,
                                radius: 30,
                                child: Icon(
                                    controller.isLisent.value
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  index++;
                  respuestas.add(respuesta);
                  if (index < preguntas.length) {
                    mostrarSiguientePregunta();
                    print(speed);
                    print(answers[index - 1]);
                    controller.puntuacion(speed, answers[index - 1]);
                    speed = "";
                    controller.changeVariableValue();
                  } else {
                    false;
                    print(speed);
                    print(answers[index - 1]);
                    controller.puntuacion(speed, answers[index - 1]);
                    speed = "";
                    controller.nextQuestions();
                  }
                },
                child: const Text('Siguiente'),
              ),
            ],
          );
        },
      );
    }

    mostrarSiguientePregunta();
    speed = "";
  }

  Future<void> start(setState) async {
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          setState(() {
            speed = result.recognizedWords;
          });
        },
        localeId: 'es_Es',
      );
    }
  }
}
