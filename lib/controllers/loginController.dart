// ignore_for_file: file_names, camel_case_types
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

  void login() {
    user.clear();
    password.clear();
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
