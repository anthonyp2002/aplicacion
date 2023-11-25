// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class TeacherPage extends GetView<TeacherController> {
  List<Widget> buildWidgetList(context, setState) {
    return [
      Home(),
      Student(context, setState, controller.singinFormKey),
      const Text(
        'Search',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      ),
      const Text(
        'Porfe',
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
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
                  GButton(
                    icon: LineIcons.user,
                    text: 'Configuracion',
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

Widget Home() {
  return const Center(
    child: Text("Home",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
  );
}

Widget Student(context, setState, singinFormKey) {
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
            child: DataTable2(
              checkboxAlignment: Alignment.bottomCenter,
              columns: const [
                DataColumn(
                  label: Center(child: Text('Nombre')),
                ),
                DataColumn(
                  label: Center(child: Text('Edad')),
                ),
                DataColumn(
                  label: Center(child: Text('Test')),
                ),
                DataColumn(
                  label: Center(child: Text('Editar')),
                )
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Center(
                      child: Text(
                        "Antony Pulla",
                        textAlign: TextAlign.center,
                      ),
                    )),
                    const DataCell(Center(
                      child: Text("12"),
                    )),
                    const DataCell(Center(
                      child: Text("No"),
                    )),
                    DataCell(
                      Center(
                        child: IconButton(
                          // Botón de edición
                          icon: const Icon(LineIcons.userEdit),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Center(
                      child: Text(
                        "Antony Jualiano",
                        textAlign: TextAlign.center,
                      ),
                    )),
                    const DataCell(Center(
                      child: Text("14"),
                    )),
                    const DataCell(Center(
                      child: Text("Si"),
                    )),
                    DataCell(
                      Center(
                        child: IconButton(
                          icon: const Icon(LineIcons.userEdit),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                )
                // Agrega más filas según sea necesario
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
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
                                    onPressed: () {},
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
