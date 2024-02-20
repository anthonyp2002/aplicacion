// ignore_for_file: deprecated_member_use, avoid_print

import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/message.dart';
import 'package:aplicacion/models/user.dart';
import 'package:aplicacion/models/userStudent.dart';
import 'package:aplicacion/models/userTeacher.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class StudentController extends GetxController
    with SingleGetTickerProviderMixin
    implements GetxService {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  RxList<UserStudent> students = <UserStudent>[].obs;
  RxList<UserStudent> estudiante = <UserStudent>[].obs;
  RxList<UserTeacher> teacers = <UserTeacher>[].obs;
  RxList cuestionarios = [].obs;
  final RxBool isTyping = false.obs;
  User a = User("", "", "", "gmail", "password", "");
  bool isPressed = false;
  bool isPresedMenuClose = false;
  bool presedQuedate = false;
  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> scaleanimation;
  final message = TextEditingController();
  final messagePost = TextEditingController();
  bool isFromUser = true;
  List<PageController> pageControllers = [];
  int selectedPageIndex = 0;
  final connect = GetConnect();
  bool presQuedate = false;
  RxList<String> messages = <String>[].obs;
  RxList<String> chatMessages = <String>[].obs;
  RxList<String> chatResponse = <String>[].obs;
  RxList<Message> mensajes = <Message>[].obs;

  void onTabChange(int index) {
    print('Changing to tab index $index');

    _selectedIndex.value = index;
    print('Changing to tab index $selectedIndex');
  }

  @override
  onInit() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        update();
      });
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    scaleanimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.onInit();
  }

  @override
  void dispose() {
    animationController.dispose();
    for (var controller in pageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  getStudent() async {
    students = await getEstudiante();
    print(students.length);
    for (var student in students) {
      print(student.fullname);
      a = User(student.fullname, student.age, student.anioLec, "", "", "");
    }
    refresh();
    update();
  }

  getCuestionario() async {
    cuestionarios = await getCuestionarios();
    update();
  }

  Future<void> cuestionario() async {
    print(a.fullname);
    print(a.anioLec);
    Get.offAllNamed('/prolec');
    Get.find<InitController>().datos(a, "", 0, 0, 0, 0, 0, 0, 0);
  }

  void sendGetRequest() async {
    print("Get...");
    try {
      final response = await connect.get('http://190.15.141.188/fastapi');
      if (response.status.connectionError) {
        print("No se puede conectar al servidor");
        print(response.statusCode);
        return; // Salir del método si no se puede conectar al servidor
      }
      if (kDebugMode) {
        print(response.body);
      }
    } catch (e) {
      print("Error en la solicitud GET: $e");
    }
  }

  void sendPost() async {
    print("Post..");

    try {
      final response = await Dio().post(
        'http://190.15.141.188/fastapi/query',
        data: {"question": message.text},
      );
      print("Solicitud POST completada.");

      if (kDebugMode) {
        messagePost.text = response.data.toString();
      }
      String text = messagePost.text
          .replaceAll('{result:', '')
          .replaceAll('}', '')
          .trim();
      isFromUser = false;
      mensajes.add(Message(text: text, isFromUser: false));
      for (Message messags in mensajes) {
        print('Texto:  ${text}, Es del usuario: ${messags.isFromUser}');
      }
    } catch (e) {
      print("Error en la solicitud Post: $e");
    }
  }

  void addMessageToChat() {
    isFromUser = true;
    mensajes.add(Message(text: message.text, isFromUser: true));
    for (Message messags in mensajes) {
      print('Texto: ${messags.text}, Es del usuario: ${messags.isFromUser}');
      print(mensajes);
    }
    message.clear();
    print(mensajes.length);
  }
}
