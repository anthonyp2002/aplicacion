// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:aplicacion/controllers/UseController/studentcontroller.dart';
import 'package:aplicacion/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sidebarx/sidebarx.dart';

class StudentPage extends GetView<StudentController> {
  List<Widget> buildWidgetList(context, setState) {
    return [
      Home(controller, context),
      IA(setState, controller, context),
      Questionnaire(controller, context),
    ];
  }

  const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Obx(() {
          return Container(
            decoration: BoxDecoration(
              image: controller.selectedIndex == 1
                  ? null // No background image for 'IA' page
                  : const DecorationImage(
                      image: AssetImage('assets/plantilla.png'),
                      fit: BoxFit.cover,
                    ),
              color: controller.selectedIndex == 1 ? Colors.blue.shade50 : null,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: isDesktop
                  ? null
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(60.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: AppBar(
                          title: Center(
                            child: Text('Mi AppBar',
                                style: GoogleFonts.ysabeau(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          backgroundColor: const Color(0xFF17203A),
                        ),
                      ),
                    ),
              body: isDesktop
                  ? Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              SidebarX(
                                controller: SidebarXController(
                                    selectedIndex: 0, extended: true),
                                theme: const SidebarXTheme(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30))),
                                  iconTheme: IconThemeData(
                                    color: Colors.black,
                                  ),
                                  selectedTextStyle:
                                      TextStyle(color: Colors.black),
                                ),
                                extendedTheme: const SidebarXTheme(
                                  width: 150,
                                ),
                                headerBuilder: (context, extended) {
                                  return const SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10)),
                                        Icon(
                                          LineIcons.userCircle,
                                          size: 50,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                items: [
                                  SidebarXItem(
                                    icon: LineIcons.home,
                                    label: '  Home',
                                    onTap: () {
                                      controller.onTabChange(0);
                                    },
                                  ),
                                  SidebarXItem(
                                    icon: LineIcons.bookOpen,
                                    label: '  IA',
                                    onTap: () {
                                      controller.onTabChange(1);
                                      controller.animationController.reset();
                                      if (controller.pageControllers.isEmpty) {
                                        controller.pageControllers
                                            .add(PageController());
                                      }
                                      if (controller.isPressed) {
                                        controller.isPressed =
                                            !controller.isPressed;
                                      }
                                    },
                                  ),
                                  SidebarXItem(
                                    icon: LineIcons.checkCircle,
                                    label: '  Cuestionarios',
                                    onTap: () {
                                      controller.onTabChange(2);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ...
                        ),
                        Expanded(
                          child: Center(
                            child: Obx(() => buildWidgetList(context, setState)
                                .elementAt(controller.selectedIndex)),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: 600,
                        ),
                        child: Center(
                          child: Obx(() => buildWidgetList(context, setState)
                              .elementAt(controller.selectedIndex)),
                        ),
                      ),
                    ),
              bottomNavigationBar: isDesktop
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withOpacity(.1),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 8),
                          child: GNav(
                            rippleColor: Colors.grey[300]!,
                            hoverColor: Colors.grey[100]!,
                            gap: 8,
                            activeColor: Colors.black,
                            iconSize: 24,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            duration: const Duration(milliseconds: 400),
                            tabBackgroundColor: Colors.grey[100]!,
                            color: Colors.black,
                            tabs: [
                              const GButton(
                                icon: LineIcons.home,
                                text: 'Home',
                              ),
                              GButton(
                                icon: LineIcons.bookOpen,
                                text: 'IA',
                                onPressed: () {
                                  controller.animationController.reset();
                                  if (controller.pageControllers.isEmpty) {
                                    controller.pageControllers
                                        .add(PageController());
                                  }
                                  if (controller.isPressed) {
                                    controller.isPressed =
                                        !controller.isPressed;
                                  }
                                },
                              ),
                              const GButton(
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
            ),
          );
        }),
      );
    });
  }
}

Widget Home(controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 600;
  final double radio = MediaQuery.of(context).size.width / 9;
  return FutureBuilder(
      future: controller.getStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (isDesktop) {
            return SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Center(
                child: Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50)),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: radio,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50)),
                    Container(
                        height: radio * 2,
                        width: radio * 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20)),
                            Text("Datos Personales",
                                style: GoogleFonts.ysabeau(fontSize: 35)),
                            Column(
                              children: [
                                const FractionallySizedBox(
                                  widthFactor:
                                      0.5, // El Divider ocupará el 50% del ancho de la pantalla
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                      Row(
                                        children: [
                                          const LineIcon(LineIcons
                                              .user), // Este es el ícono
                                          Text(" Nombre:",
                                              style: GoogleFonts.ysabeau(
                                                  fontSize: 30)),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                          ...controller.students
                                              .map((student) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      student.fullname,
                                                      style:
                                                          GoogleFonts.ysabeau(
                                                              fontSize: 25),
                                                    ),
                                                  )),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7)),
                                      Row(
                                        children: [
                                          const LineIcon(LineIcons
                                              .graduationCap), // Este es el ícono
                                          Text(" Año Lectivo:",
                                              style: GoogleFonts.ysabeau(
                                                  fontSize: 30)),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                          ...controller.students
                                              .map((student) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(student.anioLec,
                                                        style:
                                                            GoogleFonts.ysabeau(
                                                                fontSize: 25)),
                                                  )),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7)),
                                      Row(
                                        children: [
                                          const LineIcon(LineIcons
                                              .calendarCheckAlt), // Este es el ícono
                                          Text(" Fecha de Nacimiento:",
                                              style: GoogleFonts.ysabeau(
                                                  fontSize: 30)),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                          ...controller.students
                                              .map((student) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        student.birthdate,
                                                        style:
                                                            GoogleFonts.ysabeau(
                                                                fontSize: 25)),
                                                  )),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7)),
                                      Row(
                                        children: [
                                          const LineIcon(LineIcons
                                              .calendarCheckAlt), // Este es el ícono
                                          Text(" Edad:",
                                              style: GoogleFonts.ysabeau(
                                                  fontSize: 35)),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                          ...controller.students
                                              .map((student) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(student.age,
                                                        style:
                                                            GoogleFonts.ysabeau(
                                                                fontSize: 30)),
                                                  )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed("/home");
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                    ),
                                  ),
                                  child: Text('Cerrar Sesión',
                                      style: GoogleFonts.ysabeau(fontSize: 18)),
                                ),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 75,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  Text("Datos Personales",
                      style: GoogleFonts.ysabeau(fontSize: 25)),
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
                              Row(
                                children: [
                                  const LineIcon(
                                      LineIcons.user), // Este es el ícono
                                  Text(" Nombre:",
                                      style: GoogleFonts.ysabeau(fontSize: 20)),
                                ],
                              ),
                              ...controller.students.map((student) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      student.fullname,
                                      style: GoogleFonts.ysabeau(fontSize: 20),
                                    ),
                                  )),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7)),
                              Row(
                                children: [
                                  const LineIcon(LineIcons
                                      .graduationCap), // Este es el ícono
                                  Text(" Año Lectivo:",
                                      style: GoogleFonts.ysabeau(fontSize: 20)),
                                ],
                              ),
                              ...controller.students.map((student) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(student.anioLec,
                                        style:
                                            GoogleFonts.ysabeau(fontSize: 20)),
                                  )),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7)),
                              Row(
                                children: [
                                  const LineIcon(LineIcons
                                      .calendarCheckAlt), // Este es el ícono
                                  Text(" Fecha de Nacimiento:",
                                      style: GoogleFonts.ysabeau(fontSize: 20)),
                                ],
                              ),
                              ...controller.students.map((student) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(student.birthdate,
                                        style:
                                            GoogleFonts.ysabeau(fontSize: 20)),
                                  )),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7)),
                              Row(
                                children: [
                                  const LineIcon(LineIcons
                                      .calendarCheckAlt), // Este es el ícono
                                  Text(" Edad:",
                                      style: GoogleFonts.ysabeau(fontSize: 20)),
                                ],
                              ),
                              ...controller.students.map((student) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(student.age,
                                        style:
                                            GoogleFonts.ysabeau(fontSize: 20)),
                                  )),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed("/home");
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                          child: Text('Cerrar Sesión',
                              style: GoogleFonts.ysabeau(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
      });
}

Widget IA(setState, controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 600;

  return Stack(
    children: [
      AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          width: 250,
          left: isDesktop
              ? 0
              : controller.isPressed
                  ? 0
                  : -250,
          height: MediaQuery.of(context).size.height,
          child: Navigation(setState, controller)),
      Transform.translate(
        offset: Offset(
            isDesktop
                ? 250
                : controller.isPressed
                    ? 250
                    : 0,
            0),
        child: Transform.scale(
          scale: controller.isPressed ? 1 : 1,
          child: SizedBox(
            width: isDesktop
                ? MediaQuery.of(context).size.width - 400
                : double.infinity,
            child: IA_text(setState, controller, context),
          ),
        ),
      ),
      SafeArea(child: button(setState, controller, context)),
    ],
  );
}

Widget button(setState, controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 600;
  return isDesktop
      ? Container()
      : Container(
          margin:
              EdgeInsets.fromLTRB(controller.isPressed ? 200 : 25, 14, 0, 0),
          height: 35,
          width: 35,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, boxShadow: []),
          child: AnimatedIconButton(
              onPressed: () {
                setState(() {
                  controller.isPressed = !controller.isPressed;
                  if (controller.isPressed) {
                    controller.animationController.stop();
                    controller.animationController.value = 1.0;
                    controller.animationController.forward();
                  } else {
                    controller.animationController.stop();
                    controller.animationController.value = 0.0;
                    controller.animationController.forward();
                  }
                });
              },
              duration: const Duration(milliseconds: 200),
              size: 32,
              icons: const <AnimatedIconItem>[
                AnimatedIconItem(
                  icon: LineIcon(
                    LineIcons.bars,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                AnimatedIconItem(
                  icon: LineIcon(
                    LineIcons.times,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ]),
        );
}

Widget IA_text(setState, controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 600;
  return Container(
    color: Colors.blue.shade50,
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Generador de Cuentos",
                style: GoogleFonts.ysabeau(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Expanded(
          child: FractionallySizedBox(
            heightFactor: 1,
            widthFactor: 1,
            child: Stack(
              children: controller.pageControllers
                  .asMap()
                  .entries
                  .map<Widget>((entry) => Visibility(
                        visible: controller.selectedPageIndex == entry.key,
                        child: PageView(
                          controller: entry.value,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text("Cuento"),
                                  Obx(
                                    () => SizedBox(
                                      height: isDesktop ? 400 : 400,
                                      child: ListView.builder(
                                        itemCount: controller.mensajes.length,
                                        itemBuilder: (context, index) {
                                          Message message =
                                              controller.mensajes[index];
                                          return message.isFromUser
                                              ? construirMensaje(
                                                  message.text,
                                                  AlignmentDirectional
                                                      .centerStart,
                                                  Colors.blue)
                                              : construirMensaje(
                                                  message.text,
                                                  AlignmentDirectional
                                                      .centerEnd,
                                                  Colors.green,
                                                );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3),
                                  ),
                                  Container(
                                    width: isDesktop ? 500 : double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: TextFormField(
                                              enableInteractiveSelection: true,
                                              autofocus: false,
                                              onChanged: (text) {
                                                controller.isTyping.value =
                                                    text.isNotEmpty;
                                              },
                                              onTap: () {
                                                controller.animationController
                                                    .reset();
                                                controller.presedQuedate =
                                                    !controller.presedQuedate;
                                                print(
                                                    "Esta en ${controller.presedQuedate}");
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Indicaciones de tu cuento..",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                              style: GoogleFonts.ysabeau(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              controller: controller.message,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                        ),
                                        Container(
                                          width: 54.0,
                                          height: 54.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: controller.isTyping.value
                                                ? const Icon(Icons.send,
                                                    color: Colors.grey)
                                                : const Icon(Icons.mic,
                                                    color: Colors.grey),
                                            onPressed: () {
                                              if (controller.isTyping.value ==
                                                  false) {
                                                print("Presionado Micro");
                                              } else {
                                                print("Presionado Send");

                                                controller.addMessageToChat();

                                                controller.sendPost();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget construirMensaje(
    String mensaje, AlignmentDirectional alineacion, Color color) {
  return Container(
    alignment: alineacion,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        mensaje,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    ),
  );
}

Widget Navigation(setState, controller) {
  return Row(
    children: [
      Container(
        width: 250,
        height: double.infinity,
        alignment: AlignmentDirectional.bottomStart,
        color: Colors.blue.shade50,
        child: SafeArea(
            child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  CupertinoIcons.book,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Cuentos",
                style: GoogleFonts.ysabeau(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Divider(
              color: Colors.black,
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
                          controller.isPresedMenuClose =
                              !controller.isPresedMenuClose;
                          controller.pageControllers.add(PageController());
                          controller.selectedPageIndex =
                              controller.pageControllers.length - 1;
                          controller.animationController.reset();
                          controller.isPressed = !controller.isPressed;
                        });
                      },
                      duration: const Duration(milliseconds: 200),
                      size: 32,
                      icons: const <AnimatedIconItem>[
                        AnimatedIconItem(
                          icon: LineIcon(
                            LineIcons.plus,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        AnimatedIconItem(
                          icon: LineIcon(
                            LineIcons.check,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ]),
                ),
              ),
              title: const Text(
                "Nuevo Cuento",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                print("New Cuento");
              },
            ),
            const Divider(
              color: Colors.black,
              height: 1,
            ),
            Container(
              width: 250,
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.pageControllers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        controller.selectedPageIndex = index;
                        controller.animationController.reset();
                        controller.isPressed = !controller.isPressed;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: controller.selectedPageIndex == index
                          ? Colors.blue
                          : Colors.transparent,
                      child: Center(
                        child: Text(
                          'Página ${index + 1}',
                          style: GoogleFonts.ysabeau(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )),
      ),
    ],
  );
}

Widget Questionnaire(controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 600;
  final double radio = MediaQuery.of(context).size.width / 9;
  controller.getCuestionario();

  return Container(
    color: Colors.transparent,
    child: Center(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          RawMaterialButton(
            onPressed: () {
              controller.cuestionario();
            },
            constraints: const BoxConstraints(
              minHeight: 50, // Altura mínima
              minWidth: 200, // Ancho mínimo
            ),
            fillColor: Color(0xFF17203A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              'Resolver Cuestionario',
              textAlign: TextAlign.center,
              style: GoogleFonts.ysabeau(fontSize: 20, color: Colors.white),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          const FractionallySizedBox(
            widthFactor:
                0.5, // El Divider ocupará el 50% del ancho de la pantalla
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
                0.5, // El Divider ocupará el 50% del ancho de la pantalla
            child: Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
          ),
          Obx(() {
            controller.getCuestionario();
            List cuestions = controller.cuestionarios as List;
            return Container(
              width: isDesktop ? radio * 5 : double.infinity,
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
                            backgroundColor: Color(0xFF17203A),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
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
    ),
  );
}
