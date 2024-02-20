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
  RxList<UserStudent> estudiante = <UserStudent>[].obs;
  RxList<UserTeacher> teacers = <UserTeacher>[].obs;
  final passwordController = TextEditingController();
  final gmailController = TextEditingController();
  final fullNameControler = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final anioLecController = TextEditingController();
  final confirmController = TextEditingController();
  RxInt age = 0.obs;
  RxInt number_cuestions = 0.obs;
  bool num = false;
  RxList cuestionarios = [].obs;

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
    print(age.toString());
    addStudent(a.fullname, a.age, age.toString(), a.anioLec, a.password);
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

  getStuden(String name) async {
    estudiante = await getStuByName(name);
    number_cuestions = await Cuestionarios(estudiante);
    for (var estudiante in estudiante) {
      cuestionarios = await getCuestionariosID(estudiante.idStudent);
    }
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
