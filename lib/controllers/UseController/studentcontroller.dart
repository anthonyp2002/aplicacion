import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/models/user.dart';
import 'package:aplicacion/models/userStudent.dart';
import 'package:aplicacion/models/userTeacher.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  RxList<UserStudent> students = <UserStudent>[].obs;
  RxList<UserStudent> estudiante = <UserStudent>[].obs;
  RxList<UserTeacher> teacers = <UserTeacher>[].obs;
  RxList cuestionarios = [].obs;
  final RxBool isTyping = false.obs;
  User a = User("", "", "", "gmail", "password", "");

  void onTabChange(int index) {
    print('Changing to tab index $index');
    _selectedIndex.value = index;
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
    // ignore: unused_local_variable
    // ignore: avoid_print
    print(a.fullname);
    // ignore: avoid_print
    print(a.anioLec);
    // Get.offAllNamed('/prolec');
    Get.offAllNamed('/prolec');
    Get.find<InitController>().datos(a, "", 0, 0, 0, 0, 0, 0, 0);
  }
}
