// ignore_for_file: file_names, camel_case_types
import 'package:aplicacion/controllers/UseController/studentcontroller.dart';
import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>(debugLabel: '__loginFormKey__');
  final user = TextEditingController();
  final password = TextEditingController();

  @override
  void onInit() {
    user.text = '';
    super.onInit();
  }

  @override
  void onClose() {
    user.dispose();
    password.dispose();
  }

  String? validator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Por favor este campo debe ser llenado';
    }
    return null;
  }

  Future<void> login(String name, String pass) async {
    String checkUser = await verificarCredenciales(name, pass);
    user.clear();
    password.clear();
    if (checkUser == "Student") {
      bool cuestio = await getGustos();
      print("Este usuario $cuestio el cues de Gustos");
      if (cuestio == false) {
        await Get.offAllNamed('/gustosPage');
      } else if (cuestio == true) {
        Get.lazyPut(() => StudentController());
        Get.offAllNamed('/studentPage');
      }
    } else if (checkUser == "Teacher") {
      Get.lazyPut(() => TeacherController());
      Get.offAllNamed('/teacherPage');
    }
  }

  void showAccountTypeDialog() {
    Get.defaultDialog(
      title: 'Seleccionar Tipo de Cuenta',
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed('/registerTeacher');
              Get.back(); // Cerrar el diálogo
            },
            child: const Text('Docente'),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed('/registerStudent');
              Get.back(); // Cerrar el diálogo
            },
            child: const Text('Estudiante'),
          ),
        ],
      ),
    );
  }
}
