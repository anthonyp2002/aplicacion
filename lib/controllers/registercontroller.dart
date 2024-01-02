// ignore: unusort
import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/services/firebase_service.dart';
//import 'package:aplicacion/controllers/guardarexcel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> singinFormKey =
      GlobalKey<FormState>(debugLabel: '__singinFormKey__');

  final passwordController = TextEditingController();
  final gmailController = TextEditingController();
  final fullNameControler = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final anioLecController = TextEditingController();
  final confirmController = TextEditingController();
  RxInt age = 0.obs;
  @override
  void onInit() {
    fullNameControler.text = '';
    super.onInit();
  }

  bool confirm() {
    if (passwordController.text == confirmController.text) {
      return true;
    } else {
      return false;
    }
  }

  String? validator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Llene este campo';
    }
    return null;
  }

  String? username(String? value) {
    if (value != null && value.isEmpty) {
      return 'Llene este campo';
    }
    return null;
  }

  String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Llene este campo';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Ingrese un email valido';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese una contraseña';
    }
    if (value.trim().length < 8) {
      return 'Maximo de 8 caracteres';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese una contraseña';
    }
    if (value != passwordController.text) {
      return 'No coinciden las contraseña';
    }
    return null;
  }

  Future<void> login() async {
    // ignore: unused_local_variable
    final a = User(
        fullNameControler.text,
        ageController.text,
        anioLecController.text,
        gmailController.text,
        passwordController.text,
        phoneController.text);
    if (singinFormKey.currentState!.validate()) {
      Get.snackbar('Login', 'Registrado Correctamente');
      // ignore: avoid_print
      print(a.fullname);
      // ignore: avoid_print
      print(a.anioLec);
      addStudent(a.fullname, a.age, age.toString(), a.anioLec, a.password);
      // Get.offAllNamed('/prolec');
      await Get.offAllNamed('/gustosPage');
      Get.find<InitController>().datos(a, "", 0, 0, 0, 0, 0, 0, 0);
    } else {
      Get.snackbar('Error', 'Verifique los campos');
    }
  }

  void loginTe() async {
    final a = User(
        fullNameControler.text,
        ageController.text,
        anioLecController.text,
        gmailController.text,
        passwordController.text,
        phoneController.text);
    Get.lazyPut(() => TeacherController());

    if (singinFormKey.currentState!.validate()) {
      await addTea(
          a.fullname, a.gmail, age.toString(), a.phone, a.age, a.password);
      Get.snackbar('Login', 'Registrado Correctamente');
      Get.offAllNamed('/teacherPage');
    } else {
      Get.snackbar('Error', 'Verifique los campos');
    }
  }

  int calculateAge(DateTime birthDate) {
    final DateTime currentDate = DateTime.now();
    age.value = currentDate.year - birthDate.year;

    // Ajustar la edad si aún no ha llegado el cumpleaños en el año actual
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      print(age);
      return (age.value - 1);
    } else {
      print(age);
      return age.value;
    }
  }
}
