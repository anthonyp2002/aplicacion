// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:aplicacion/controllers/UseController/studentcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class StudentPage extends GetView<StudentController> {
  List<Widget> buildWidgetList(context, setState) {
    return [
      Home(controller),
      IA(setState, controller, context),
      Questionnaire(controller),
    ];
  }

  const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Align(
            alignment: Alignment.center,
            child: AppBar(
              title: const Text('Mi AppBar'),
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Obx(() => buildWidgetList(context, setState)
                .elementAt(controller.selectedIndex)),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.bookOpen,
                    text: 'IA',
                  ),
                  GButton(
                    icon: LineIcons.checkCircle,
                    text: 'Cuestionarios',
                  ),
                ],
                selectedIndex: controller.selectedIndex,
                onTabChange: controller.onTabChange,
              ),
            ),
          ),
        ),
      );
    });
  }
}

Widget Home(controller) {
  return FutureBuilder(
      future: controller.getStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 75,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              const Text("Datos Personales",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FractionallySizedBox(
                      widthFactor:
                          0.7, // El Divider ocupará el 50% del ancho de la pantalla
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          const Row(
                            children: [
                              LineIcon(LineIcons.user), // Este es el ícono
                              Text(" Nombre:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
                          ...controller.students.map((student) => Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  student.fullname,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          const Row(
                            children: [
                              LineIcon(
                                  LineIcons.graduationCap), // Este es el ícono
                              Text(" Año Lectivo:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
                          ...controller.students.map((student) => Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  student.anioLec,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          const Row(
                            children: [
                              LineIcon(LineIcons
                                  .calendarCheckAlt), // Este es el ícono
                              Text(" Fecha de Nacimiento:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          ...controller.students.map((student) => Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  student.birthdate,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          const Row(
                            children: [
                              LineIcon(LineIcons
                                  .calendarCheckAlt), // Este es el ícono
                              Text(" Edad:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          ...controller.students.map((student) => Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  student.age,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              )),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed("/home");
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      });
}

Widget IA(setState, controller, context) {
  return Stack(
    children: [
      Positioned(
          width: 288,
          height: MediaQuery.of(context).size.height,
          child: Navigation(setState, controller)),
      Transform.translate(
        offset: Offset(288, 0),
        child: Transform.scale(
          scale: 1,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                children: [
                  Stack(
                    children: [
                      SafeArea(
                          child: Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 3),
                                blurRadius: 8,
                              )
                            ]),
                        child: IconButton(
                          icon: LineIcon(LineIcons.bars),
                          onPressed: () {
                            print("Presione para acceder al menu");
                          },
                        ),
                      ))
                    ],
                  ),
                  Text(
                    "Generardor de Cuentos",
                    style: GoogleFonts.ysabeau(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            100.0), // Radio en la esquina superior izquierda
                        topRight: Radius.circular(
                            100.0), // Radio en la esquina superior derecha
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(""),
                        const Spacer(),
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  print('Agregar');
                                },
                                backgroundColor: Colors.lightBlueAccent,
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0), // Margen a ambos lados
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enableInteractiveSelection: true,
                                  autofocus: false,
                                  onChanged: (text) {
                                    controller.isTyping.value = text.isNotEmpty;
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.blue,
                                    labelText: "Mensaje...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusColor: Colors.white,
                                  ),
                                  style: GoogleFonts.ysabeau(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5)),
                              Container(
                                width: 56.0, // Ancho del contenedor
                                height: 56.0, // Altura del contenedor
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .blue, // Color de fondo del contenedor redondo
                                ),
                                child: IconButton(
                                  icon: controller.isTyping.value
                                      ? const Icon(Icons.send,
                                          color: Colors
                                              .white) // Color del icono cuando se está escribiendo
                                      : const Icon(Icons.mic,
                                          color: Colors
                                              .white), // Color del icono cuando no se está escribiendo
                                  onPressed: () {
                                    if (controller.isTyping.value == false) {
                                      print("Presionado Micro");
                                    } else {
                                      print("Presionado Send");
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget Navigation(setState, controller) {
  return Row(
    children: [
      Container(
        width: 288,
        height: double.infinity,
        alignment: AlignmentDirectional.bottomStart,
        color: const Color(0xFF17203A),
        child: SafeArea(
            child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  CupertinoIcons.book,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Cuentos",
                style: GoogleFonts.ysabeau(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "Registro",
                style: GoogleFonts.ysabeau(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Divider(
              color: Colors.white24,
              height: 1,
            ),
            ListTile(
              leading: SizedBox(
                height: 34,
                width: 34,
                child: Tooltip(
                  message: 'Agregar',
                  child: AnimatedIconButton(
                      onPressed: () {
                        setState(() {
                          controller.isPressed = controller.isPressed!;
                        });
                        // Aquí puedes manejar la lógica para agregar un reporte
                        // por ejemplo, abrir un cuadro de diálogo o navegar a otra pantalla.
                      },
                      duration: Duration(milliseconds: 200),
                      size: 32,
                      icons: const <AnimatedIconItem>[
                        AnimatedIconItem(
                          icon: LineIcon(
                            LineIcons.plus,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        AnimatedIconItem(
                          icon: LineIcon(
                            LineIcons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ]),
                ),
              ),
              title: Text(
                "Nuevo Cuento",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                print("New Cuento");
              },
            )
          ],
        )),
      ),
    ],
  );
}

Widget Questionnaire(controller) {
  return Center(
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        RawMaterialButton(
          onPressed: () {
            controller.cuestionario();
          },
          constraints: const BoxConstraints(
            minHeight: 45, // Altura mínima
            minWidth: 150, // Ancho mínimo
          ),
          fillColor: Colors.blue.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            'Resolver Cuestionario',
            textAlign: TextAlign.center,
            style: GoogleFonts.ysabeau(fontSize: 15),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        const FractionallySizedBox(
          widthFactor:
              0.8, // El Divider ocupará el 50% del ancho de la pantalla
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
        Text("# Cuestionarios Realizados",
            textAlign: TextAlign.center,
            style: GoogleFonts.ysabeau(fontSize: 20)),
        const FractionallySizedBox(
          widthFactor:
              0.8, // El Divider ocupará el 50% del ancho de la pantalla
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
        Obx(() {
          controller.getCuestionario();
          List cuestions = controller.cuestionarios as List;
          return SizedBox(
            height: 470.0,
            child: ListView.builder(
              itemCount: cuestions.length,
              padding: const EdgeInsets.only(top: 3.0),
              itemBuilder: (context, position) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 35,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            cuestions[position]["id"],
                            style: GoogleFonts.ysabeau(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                cuestions[position]["Fecha"].toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    ),
  );
}
