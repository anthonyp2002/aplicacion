// ignore_for_file: must_be_immutable, use_key_in_widget_constructors
import 'package:aplicacion/controllers/Gustos_Controller/gustos_controller.dart';
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/img_gustos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GustPage extends GetView<InitController> {
  @override
  Widget build(BuildContext context) {
    controller.enunciado = "Elija segun sus gustos";
    controller.speak();
    controller.recuperarGusOne();
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
              Image.asset('assets/as.png', width: 280),
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                height: 160,
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
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    GustosOne(imgGustos: controller.imggustos)),
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

class GustosOne extends GetView<GustosController> {
  List<ImgGustos> imgGustos = [];
  GustosOne({Key? key, required this.imgGustos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);

    Get.put(GustosController());
    controller.imggustos = imgGustos;
    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img_gust.png'), fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: isDesktop
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.imggustos.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: isDesktop ? 500 : 315,
                            height: 80,
                            child: Text(
                              controller.imggustos[index].questions!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ysabeau(
                                  fontSize: 25, color: Colors.black),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          SizedBox(
                            width: isDesktop ? 900 : 400,
                            height: isDesktop ? 750 : 400,
                            child: GridView.count(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              crossAxisCount: isDesktop ? 3 : 1,
                              children: controller
                                  .imggustos[index].imag!.entries
                                  .map((image) {
                                return CheckboxListTile(
                                  title: Image.asset(
                                      image.value.entries.first.key),
                                  value: image.value.entries.first.value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      Map<String, bool> updatedMap =
                                          Map.from(image.value);
                                      updatedMap[image.value.entries.first
                                          .key] = newValue ?? false;
                                      // Actualizar la lista imggustos en el controlador
                                      controller.imggustos[index]
                                          .imag![image.key] = updatedMap;
                                      controller.tipe = controller
                                          .imggustos[index].questions!;
                                      print(
                                          "Seleccionaste ${image.value.entries.first.key}");
                                      controller.gustos(
                                          image.value.entries.first.key);
                                      print(controller.selectedImages);
                                    });
                                  },
                                  subtitle: Text(image.key,
                                      style: GoogleFonts.ysabeau(
                                          fontSize: 25, color: Colors.black)),
                                  activeColor: Colors.purple,
                                  checkColor: Colors.black,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  tristate: true,
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
            ),
            floatingActionButton: RawMaterialButton(
              onPressed: () {
                controller.nextQuestions();
              },
              constraints: const BoxConstraints(
                minHeight: 40,
                minWidth: 150,
              ),
              fillColor: const Color.fromARGB(255, 58, 133, 238),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      );
    });
  }
}
