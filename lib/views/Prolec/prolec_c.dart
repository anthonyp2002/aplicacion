// ignore_for_file: avoid_print, must_be_immutable, use_key_in_widget_constructors
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/prolcec_model.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../controllers/Prolec_Controller/prolecc_controller.dart';
import '../../models/user.dart';

class ProlecCPage extends GetView<InitController> {
  @override
  Widget build(BuildContext context) {
    controller.enunciado =
        "Lea las historias y responda las siguientes preguntas";
    controller.speak();
    controller.recuperarDatosText();

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
                                      optionsTex: controller.optionsText,
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
  List<OptionsText> optionsTex = [];
  ProlecThree(
      {Key? key,
      required this.usuario,
      required this.time,
      required this.puntuacion,
      required this.optionsTex})
      : super(key: key);
  late PageController pageController;
  String speed = " ";
  var isLisent = false.obs;
  SpeechToText speechToText = SpeechToText();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    controller.datos(usuario, time, puntuacion);
    controller.optionsText = optionsTex;
    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/prolec_tree.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
                    Container(
                      height: isDesktop
                          ? MediaQuery.of(context).size.height - 350
                          : MediaQuery.of(context).size.height - 100,
                      width: isDesktop ? 700 : double.infinity,
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        itemCount: controller.optionsText.length,
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
                                        controller.optionsText[index].titulo!,
                                        style: GoogleFonts.barlow(fontSize: 20),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20)),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white),
                                          width: double.infinity,
                                          height: isDesktop ? 50 : 100,
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Text(
                                              controller
                                                  .optionsText[index].text!,
                                              style: GoogleFonts.barlow(
                                                  fontSize: 20),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10)),
                                      RawMaterialButton(
                                        onPressed: () {
                                          List<String> preguntas = controller
                                              .optionsText[index].questions;
                                          List<String> answers = controller
                                              .optionsText[index].answer;
                                          mostrarPreguntas(
                                              context, preguntas, answers);
                                          controller.changeVariableValue();
                                          mostrarPreguntas(
                                              context, preguntas, answers);
                                          controller.changeVariableValue();
                                          controller.tit = controller
                                              .optionsText[index].titulo
                                              .toString();
                                        },
                                        constraints: const BoxConstraints(
                                          minHeight: 40,
                                          minWidth: 150,
                                        ),
                                        fillColor: const Color.fromARGB(
                                            255, 58, 133, 238),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
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
                                          Get.find<InitController>().datos(
                                              controller.use,
                                              controller.tiempo,
                                              controller.puntos,
                                              6,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0);
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
    print("Estoy en index $index  con las $preguntas");
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
                    controller.puntuacion(
                        preguntas[index - 1], speed, answers[index - 1]);
                    speed = "";
                    controller.changeVariableValue();
                  } else {
                    false;
                    print(speed);
                    print(answers[index - 1]);
                    controller.puntuacion(
                        preguntas[index - 1], speed, answers[index - 1]);
                    speed = "";
                    Navigator.of(context).pop();
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
