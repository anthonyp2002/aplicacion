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
              Color.fromRGBO(158, 108, 0, 1),
              Color.fromRGBO(252, 251, 213, 1)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Instrucciones del Ejercicio",
                style: GoogleFonts.ysabeau(fontSize: 30, color: Colors.black),
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
                        fillColor: Colors.white,
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
                                builder: (context) => ProlecThree(
                                      usuario: controller.use,
                                      time: controller.tiempo,
                                      puntuacion: controller.puntos,
                                    )),
                          );
                        },
                        constraints: const BoxConstraints(
                          minHeight: 40, // Altura mínima
                          minWidth: 100, // Ancho mínimo
                        ),
                        fillColor: Colors.white,
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
          child: Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
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
                                child: Column(
                                  children: [
                                    Text(
                                      ImgC().optionsText[index].titulo!,
                                      style: GoogleFonts.barlow(fontSize: 20),
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20)),
                                    Expanded(
                                      child: SizedBox(
                                        width: 300,
                                        height: 100,
                                        child: SingleChildScrollView(
                                          child: Text(
                                            ImgC().optionsText[index].text!,
                                            style: GoogleFonts.barlow(
                                                fontSize: 20),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10)),
                                    RawMaterialButton(
                                      onPressed: () {
                                        List<String> preguntas =
                                            ImgC().optionsText[index].questions;
                                        List<String> answers =
                                            ImgC().optionsText[index].answer;
                                        mostrarPreguntas(
                                            context, preguntas, answers);
                                        controller.changeVariableValue();
                                        mostrarPreguntas(
                                            context, preguntas, answers);
                                        controller.changeVariableValue();
                                      },
                                      constraints: const BoxConstraints(
                                        minHeight: 40,
                                        minWidth: 150,
                                      ),
                                      fillColor:
                                          Color.fromARGB(255, 58, 133, 238),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: const Text(
                                        'Ver Preguntas',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
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
