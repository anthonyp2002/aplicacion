// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:aplicacion/models/userStudent.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sidebarx/sidebarx.dart';

class TeacherPage extends GetView<TeacherController> {
  List<Widget> buildWidgetList(context, setState) {
    return [
      Home(controller, context),
      Student(context, setState, controller.singinFormKey, controller),
      Reportes(context, setState, controller),
    ];
  }

  const TeacherPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/plantilla.png'),
                  fit: BoxFit.cover)),
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
                              style: GoogleFonts.ysabeau(fontSize: 20)),
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
                                  label: '  Alumnos',
                                  onTap: () {
                                    controller.onTabChange(1);
                                  },
                                ),
                                SidebarXItem(
                                  icon: LineIcons.checkCircle,
                                  label: 'Buscar',
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
                : SingleChildScrollView(
                    child: Center(
                      child: Obx(() => buildWidgetList(context, setState)
                          .elementAt(controller.selectedIndex)),
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
                        )
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
                          tabs: const [
                            GButton(
                              icon: LineIcons.home,
                              text: 'Home',
                            ),
                            GButton(
                              icon: LineIcons.glasses,
                              text: 'Alumnos',
                            ),
                            GButton(
                              icon: LineIcons.search,
                              text: 'Buscar',
                            ),
                          ],
                          selectedIndex: controller.selectedIndex,
                          onTabChange: controller.onTabChange,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}

Widget Home(controller, context) {
  final isDesktop = MediaQuery.of(context).size.width > 900;
  final asd = MediaQuery.of(context).size.width > 1300;
  final double radio = MediaQuery.of(context).size.width / 7;
  return FutureBuilder(
      future: controller.getTeacher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (isDesktop) {
            print(MediaQuery.of(context).size.width);
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50)),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: radio - 60,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25)),
                    Container(
                      height: MediaQuery.of(context).size.height - 500,
                      width: MediaQuery.of(context).size.width - 750,
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
                                widthFactor: 0.5,
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5)),
                                    Row(
                                      children: [
                                        const LineIcon(
                                            LineIcons.user), // Este es el ícono
                                        Text(" Nombre:",
                                            style: GoogleFonts.ysabeau(
                                                fontSize: 30)),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10)),
                                        ...controller.teacers.map((teacher) =>
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                teacher.fullname,
                                                style: GoogleFonts.ysabeau(
                                                    fontSize: asd ? 25 : 20),
                                              ),
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7)),
                                    Row(
                                      children: [
                                        const LineIcon(LineIcons
                                            .envelope), // Este es el ícono
                                        Text(" Gmail:",
                                            style: GoogleFonts.ysabeau(
                                                fontSize: 30)),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10)),
                                        ...controller.teacers.map((teacher) =>
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(teacher.gmail,
                                                  style: GoogleFonts.ysabeau(
                                                      fontSize: asd ? 25 : 20)),
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7)),
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
                                        ...controller.teacers.map((teacher) =>
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(teacher.age,
                                                  style: GoogleFonts.ysabeau(
                                                      fontSize: asd ? 25 : 20)),
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7)),
                                    Row(
                                      children: [
                                        const LineIcon(LineIcons
                                            .calendarCheckAlt), // Este es el ícono
                                        Text(" Edad:",
                                            style: GoogleFonts.ysabeau(
                                                fontSize: 30)),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10)),
                                        ...controller.teacers.map((teacher) =>
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(teacher.edad,
                                                  style: GoogleFonts.ysabeau(
                                                      fontSize: asd ? 25 : 20)),
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
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
                    backgroundColor: Colors.blue,
                    radius: 75,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  const Text("Datos Personales",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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
                                  Spacer(),
                                  Icon(LineIcons.userEdit),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3)),
                              ...controller.teacers.map((teacher) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      teacher.fullname,
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
                                      LineIcons.envelope), // Este es el ícono
                                  Text(" Gmail:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                  Spacer(),
                                  Icon(LineIcons.userEdit),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3)),
                              ...controller.teacers.map((teacher) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      teacher.gmail,
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
                                  Spacer(),
                                  Icon(LineIcons.userEdit),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5)),
                              ...controller.teacers.map((teacher) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      teacher.age,
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
                              ...controller.teacers.map((teacher) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      teacher.edad,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )),
                            ],
                          ),
                        ),
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
            );
          }
        }
      });
}

Widget Student(context, setState, singinFormKey, controller) {
  final isDesktop = MediaQuery.of(context).size.width > 900;
  final con = MediaQuery.of(context).size.width > 1600;

  return SingleChildScrollView(
    child: Center(
      child: SizedBox(
        width: isDesktop ? double.infinity : 800,
        child: Column(
          children: [
            const Text("Alumnos",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            isDesktop
                ? ElevatedButton(
                    onPressed: () {
                      saveStudent(context, setState, controller);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: Text('Nuevo Alunmo',
                        style: GoogleFonts.ysabeau(fontSize: 20)),
                  )
                : const Padding(padding: EdgeInsets.symmetric(vertical: 0)),
            isDesktop
                ? Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    height: 800,
                    child: Obx(() {
                      List<UserStudent> students =
                          controller.students as List<UserStudent>;
                      return GridView.count(
                        crossAxisCount: con
                            ? 4
                            : MediaQuery.of(context).size.width > 1270
                                ? 3
                                : 2,
                        childAspectRatio: 1.35,
                        children: List.generate(students.length, (index) {
                          return GestureDetector(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue.shade200,
                                        radius: 70,
                                      ),
                                    ),
                                    Text(
                                      "Nombre: ${students[index].fullname}",
                                      style: GoogleFonts.ysabeau(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  1750
                                              ? 22
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1270
                                                  ? 17
                                                  : 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Año Lectivo: ${students[index].anioLec}",
                                      style: GoogleFonts.ysabeau(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  1750
                                              ? 22
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1270
                                                  ? 17
                                                  : 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Nacimiento: ${students[index].birthdate}",
                                      style: GoogleFonts.ysabeau(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  1750
                                              ? 22
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1270
                                                  ? 17
                                                  : 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Edad: ${students[index].age}",
                                      style: GoogleFonts.ysabeau(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  1750
                                              ? 22
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1270
                                                  ? 17
                                                  : 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => editStuden(
                                context, setState, controller, students[index]),
                          );
                        }),
                      );
                    }),
                  )
                : Obx(() {
                    List<UserStudent> students =
                        controller.students as List<UserStudent>;
                    return SizedBox(
                      height: isDesktop ? 600 : 470.0,
                      child: ListView.builder(
                        itemCount: students.length,
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
                                        students[position].fullname,
                                        style: GoogleFonts.ysabeau(
                                            fontSize: 22,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            students[position].anioLec,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      onTap: () => infStudent(context, setState,
                                          controller, students[position])),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
            isDesktop
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 0))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          controller.getStudent();
                          showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            )),
                            isScrollControlled: true,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Form(
                                    key: controller.singinFormKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Center(
                                          child: Text(
                                            "Registro De Alumno",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              prefixIcon: const Icon(
                                                LineIcons.child,
                                                color: Color.fromARGB(
                                                    255, 64, 66, 68),
                                              ),
                                              hintText: "Ingrese el nombre",
                                              hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 35, 33, 33)),
                                              filled: true,
                                              fillColor: Colors.blue[50]),
                                          controller:
                                              controller.fullNameControler,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              prefixIcon: const Icon(
                                                LineIcons.calendarAlt,
                                                color: Color.fromARGB(
                                                    255, 64, 66, 68),
                                              ),
                                              hintText: "Fecha De Nacimiento",
                                              hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 35, 33, 33)),
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                    Icons.calendar_month),
                                                onPressed: () {
                                                  _seleccionarFecha(
                                                      context, controller);
                                                },
                                              ),
                                              filled: true,
                                              fillColor: Colors.blue[50]),
                                          validator: controller.validator,
                                          controller: controller.ageController,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              prefixIcon: const Icon(
                                                LineIcons.school,
                                                color: Color.fromARGB(
                                                    255, 64, 66, 68),
                                              ),
                                              hintText: "Año Lectivo",
                                              hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 35, 33, 33)),
                                              filled: true,
                                              fillColor: Colors.blue[50]),
                                          validator: controller.validator,
                                          controller:
                                              controller.anioLecController,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5)),
                                        TextFormField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.5)),
                                              prefixIcon: const Icon(
                                                LineIcons.lock,
                                                color: Color.fromARGB(
                                                    255, 64, 66, 68),
                                              ),
                                              hintText: "Contraseña",
                                              hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 35, 33, 33)),
                                              filled: true,
                                              fillColor: Colors.blue[50]),
                                          validator:
                                              controller.passwordValidator,
                                          controller:
                                              controller.passwordController,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    Colors.transparent,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  controller.fullNameControler
                                                      .clear();
                                                  controller.ageController
                                                      .clear();
                                                  controller.anioLecController
                                                      .clear();
                                                  controller.passwordController
                                                      .clear();
                                                  controller.getStudent();
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cerrar",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary)),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              onPressed: () {
                                                controller.addStud();
                                                controller.fullNameControler
                                                    .clear();
                                                controller.ageController
                                                    .clear();
                                                controller.anioLecController
                                                    .clear();
                                                controller.passwordController
                                                    .clear();
                                                controller.getStudent();
                                              },
                                              child: Text("Agregar",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        tooltip: "Increment",
                        child: const Icon(LineIcons.userPlus),
                      ),
                      const SizedBox(
                          width:
                              16), // Espacio entre el DataTable y el FloatingActionButton
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _seleccionarFecha(BuildContext context, controller) async {
  final DateTime? fechaNueva = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (fechaNueva != null) {
    controller.ageController.text = fechaNueva.toIso8601String().substring(
        0, 10); // Actualiza el texto del controlador con la fecha seleccionada
  }
  DateTime fecha = DateTime.parse(controller.ageController.text);
  controller.calculateAge(fecha);
}

Future infStudent(BuildContext context, setState, controller, studens) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(child: Text('Estudiante')),
        content: SizedBox(
          width: 250,
          height: 380,
          child: Column(
            children: <Widget>[
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              const Text("Datos Personales",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FractionallySizedBox(
                      widthFactor:
                          1, // El Divider ocupará el 50% del ancho de la pantalla
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
                          const Row(
                            children: [
                              LineIcon(LineIcons.user), // Este es el ícono
                              Text(" Nombre:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              studens.fullname,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
                          const Row(
                            children: [
                              LineIcon(LineIcons.envelope), // Este es el ícono
                              Text(" Año Lectivo:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              studens.anioLec,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              studens.birthdate,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3)),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              studens.age,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Editar'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                controller.getStudent();
              });
              editStuden(context, setState, controller, studens);
            },
          ),
        ],
      );
    },
  );
}

Future saveStudent(BuildContext context, setState, controller) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Registrar Alumno')),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.child,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Ingrese el nombre",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  controller: controller.fullNameControler,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.calendarAlt,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Fecha De Nacimiento",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () {
                          _seleccionarFecha(context, controller);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  validator: controller.validator,
                  controller: controller.ageController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.school,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Año Lectivo",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  validator: controller.validator,
                  controller: controller.anioLecController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.lock,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Contraseña",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  validator: controller.passwordValidator,
                  controller: controller.passwordController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.fullNameControler.clear();
                          controller.ageController.clear();
                          controller.anioLecController.clear();
                          controller.passwordController.clear();
                          controller.getStudent();
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Cerrar",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        controller.addStud();
                        controller.fullNameControler.clear();
                        controller.ageController.clear();
                        controller.anioLecController.clear();
                        controller.passwordController.clear();
                        controller.getStudent();
                      },
                      child: Text("Agregar",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future editStuden(BuildContext context, setState, controller, studens) {
  final fullnameController = TextEditingController(text: studens.fullname);
  final ageController = TextEditingController(text: studens.birthdate);
  final anioLecController = TextEditingController(text: studens.anioLec);
  final idController = TextEditingController(text: studens.idStudent);
  final idTeacher = TextEditingController(text: studens.idTeacher);
  final pasword = TextEditingController(text: studens.password);
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Estudiante')),
          content: SizedBox(
            width: 300,
            height: 250,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: fullnameController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.child,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Nombre",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      filled: true,
                      fillColor: Colors.blue[50]),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                TextFormField(
                  keyboardType: TextInputType.number,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.calendarAlt,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Fecha De Nacimiento",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () {
                          _seleccionarFecha(context, controller);
                          ageController.text = controller.ageController.text;
                        },
                      ),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  validator: controller.validator,
                  controller: ageController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5)),
                      prefixIcon: const Icon(
                        LineIcons.school,
                        color: Color.fromARGB(255, 64, 66, 68),
                      ),
                      hintText: "Año Lectivo",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 35, 33, 33)),
                      filled: true,
                      fillColor: Colors.blue[50]),
                  validator: controller.validator,
                  controller: anioLecController,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  controller.getStudent();
                });
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                UserStudent users = UserStudent(
                    idStudent: idController.text,
                    fullname: fullnameController.text,
                    birthdate: ageController.text,
                    age: controller.age.toString(),
                    anioLec: anioLecController.text,
                    password: pasword.text,
                    idTeacher: idTeacher.text);
                updateStudent(users);
                Navigator.of(context).pop();
                await controller.getStudent();
                setState(() {
                  controller.getStudent();
                });
                controller.update();
              },
            ),
          ],
        );
      });
}

Widget Reportes(context, setState, controller) {
  final isDesktop = MediaQuery.of(context).size.width > 600;
  final double radio = MediaQuery.of(context).size.width / 9;
  final TextEditingController nameStudent = TextEditingController();
  return Center(
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        const Text("Reporte",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.5)),
                prefixIcon: const Icon(
                  LineIcons.child,
                  color: Color.fromARGB(255, 64, 66, 68),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                ),
                hintText: "Ingrese el nombre del Alumno",
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 35, 33, 33)),
                filled: true,
                fillColor: Colors.blue[50]),
            controller: nameStudent,
          ),
        ),
        TextButton(
          child: const Text('Buscar'),
          onPressed: () async {
            await controller.getStuden(nameStudent.text);
            setState(() {
              controller.getStuden(nameStudent.text);
            });
          },
        ),
        Obx(() {
          List<UserStudent> estudiante =
              controller.estudiante as List<UserStudent>;
          return SizedBox(
              height: 470.0,
              child: ListView.builder(
                  itemCount: estudiante.length,
                  padding: const EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            estudiante[position].fullname,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Align(
                            alignment: Alignment.center,
                            child: controller.number_cuestions == 0
                                ? const Text("Ningun Cuestionario Resulto",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300))
                                : Obx(() {
                                    List cuestions =
                                        controller.cuestionarios as List;
                                    return SizedBox(
                                      width: isDesktop
                                          ? radio * 5
                                          : double.infinity,
                                      height: 470.0,
                                      child: ListView.builder(
                                        itemCount: cuestions.length,
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        itemBuilder: (context, position) {
                                          return Card(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xFF17203A),
                                                    radius: 35,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    title: Text(
                                                      cuestions[position]["id"],
                                                      style:
                                                          GoogleFonts.ysabeau(
                                                              fontSize: 22,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(
                                                          cuestions[position]
                                                                  ["Fecha"]
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                  })),
                      ],
                    );
                  }));
        }),
        const FractionallySizedBox(
          widthFactor: 0.8,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Reporte:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    ),
  );
}
