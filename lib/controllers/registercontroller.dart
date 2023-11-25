// ignore: unusort
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

  void login() {
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
      addStudent(a.fullname, a.age, a.anioLec, a.password);
      Get.offAllNamed('/prolec');
      Get.find<InitController>().datos(a, "", 0, 0, 0, 0, 0, 0, 0);
    } else {
      Get.snackbar('Error', 'Verifique los campos');
    }
  }

  void loginTe() {
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
      addTea(a.fullname, a.gmail, a.phone, a.age, a.password);
      Get.offAllNamed('/teacherPage');
    } else {
      Get.snackbar('Error', 'Verifique los campos');
    }
  }
}
