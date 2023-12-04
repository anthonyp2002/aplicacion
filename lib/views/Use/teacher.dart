// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:aplicacion/models/userStudent.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class TeacherPage extends GetView<TeacherController> {
  List<Widget> buildWidgetList(context, setState) {
    return [
      Home(controller),
      Student(context, setState, controller.singinFormKey, controller),
      const Text(
        'Search',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      ),
    ];
  }

  TeacherPage({super.key});
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
        body: SingleChildScrollView(
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
      );
    });
  }
}

Widget Home(controller) {
  return FutureBuilder(
    future: controller.getTeacher(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
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
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        ...controller.teacers.map((teacher) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                teacher.fullname,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            )),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        const Row(
                          children: [
                            LineIcon(LineIcons.envelope), // Este es el ícono
                            Text(" Gmail:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(LineIcons.userEdit)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        ...controller.teacers.map((teacher) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                teacher.gmail,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            )),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        const Row(
                          children: [
                            LineIcon(
                                LineIcons.calendarCheckAlt), // Este es el ícono
                            Text(" Fecha de Nacimiento:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5)),
                        ...controller.teacers.map((teacher) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                teacher.age,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    },
  );
}

Widget Student(context, setState, singinFormKey, controller) {
  return Center(
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        const Text("Alumnos",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 400,
            height: 450,
            child: Obx(() {
              controller.getStudent();
              if (controller.students.isNotEmpty) {
                controller.getStudent();
                List<UserStudent> students =
                    controller.students as List<UserStudent>;
                List<DataRow> dataRows =
                    students.map<DataRow>((UserStudent student) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(student.fullname)),
                      DataCell(Text(student.birthdate)),
                      DataCell(Text(student.anioLec)),
                      DataCell(IconButton(
                        icon: const Icon(LineIcons.userEdit),
                        onPressed: () {
                          final fullnameController =
                              TextEditingController(text: student.fullname);
                          final ageController =
                              TextEditingController(text: student.birthdate);
                          final anioLecController =
                              TextEditingController(text: student.anioLec);
                          final idController =
                              TextEditingController(text: student.idStudent);
                          final idTeacher =
                              TextEditingController(text: student.idTeacher);
                          final pasword =
                              TextEditingController(text: student.password);
                          showDialog(
                            context: context,
                            barrierDismissible: false, // Evita cerrar e
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Editar estudiante'),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller: fullnameController,
                                        decoration: const InputDecoration(
                                            labelText: 'Nombre completo'),
                                      ),
                                      TextField(
                                        controller: ageController,
                                        decoration: const InputDecoration(
                                            labelText: 'Edad'),
                                      ),
                                      TextField(
                                        controller: anioLecController,
                                        decoration: const InputDecoration(
                                            labelText: 'Año lectivo'),
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
                                    onPressed: () {
                                      UserStudent users = UserStudent(
                                          idStudent: idController.text,
                                          fullname: fullnameController.text,
                                          birthdate: ageController.text,
                                          anioLec: anioLecController.text,
                                          password: pasword.text,
                                          idTeacher: idTeacher.text);
                                      updateStudent(users);
                                      setState(() {
                                        controller.getStudent();
                                      });
                                      controller.update();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )),
                    ],
                  );
                }).toList();
                return DataTable2(
                  checkboxAlignment: Alignment.bottomCenter,
                  columns: const [
                    DataColumn2(
                      label: Center(child: Text('Nombre')),
                    ),
                    DataColumn2(
                      label: Center(child: Text('Edad')),
                    ),
                    DataColumn2(
                      label: Center(child: Text('Test')),
                    ),
                    DataColumn2(
                      label: Center(child: Text('Editar')),
                    )
                  ],
                  rows: dataRows,
                );
              } else {
                return const Center(child: Text("No tiene alumnos asignados"));
              }
            }),
          ),
        ),
        Row(
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
                      heightFactor:
                          0.8, // Ajusta este valor según tus necesidades
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
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                              TextFormField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
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
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5)),
                              TextFormField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
                                    prefixIcon: const Icon(
                                      LineIcons.calendarAlt,
                                      color: Color.fromARGB(255, 64, 66, 68),
                                    ),
                                    hintText: "Edad",
                                    hintStyle: const TextStyle(
                                        color: Color.fromARGB(255, 35, 33, 33)),
                                    filled: true,
                                    fillColor: Colors.blue[50]),
                                validator: controller.validator,
                                controller: controller.ageController,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5)),
                              TextFormField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
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
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5)),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
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
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      setState(() {
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
                                          Theme.of(context).colorScheme.primary,
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
  );
}
