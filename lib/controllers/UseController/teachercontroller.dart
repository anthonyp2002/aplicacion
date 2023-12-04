import 'package:aplicacion/models/user.dart';
import 'package:aplicacion/models/userStudent.dart';
import 'package:aplicacion/models/userTeacher.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherController extends GetxController {
  final GlobalKey<FormState> singinFormKey =
      GlobalKey<FormState>(debugLabel: '__singinFormKey__');
  final _selectedIndex = 0.obs;
  RxList<UserStudent> students = <UserStudent>[].obs;
  RxList<UserTeacher> teacers = <UserTeacher>[].obs;
  final passwordController = TextEditingController();
  final gmailController = TextEditingController();
  final fullNameControler = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final anioLecController = TextEditingController();
  final confirmController = TextEditingController();

  int get selectedIndex => _selectedIndex.value;
  var student;
  void onTabChange(int index) {
    print('Changing to tab index $index');
    _selectedIndex.value = index;
  }

  @override
  onInit() async {
    super.onInit();
    getStudent();
  }

  addStud() {
    final a = User(
        fullNameControler.text,
        ageController.text,
        anioLecController.text,
        gmailController.text,
        passwordController.text,
        phoneController.text);
    addStudent(a.fullname, a.age, a.anioLec, a.password);
  }

  getStudent() async {
    students = await getStudenT();
    for (student in students) {}
    refresh();
    update();
  }

  getTeacher() async {
    teacers = await getTeache();
    for (var teacer in teacers) {
      print(teacer.fullname);
    }
    refresh();
    update();
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
}
