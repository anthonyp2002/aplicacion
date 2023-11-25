import 'package:aplicacion/views/Prolec/prolec_a.dart';
import 'package:aplicacion/views/Prolec/prolec_b.dart';
import 'package:aplicacion/views/Prolec/prolec_c.dart';
import 'package:aplicacion/views/ProlecR/prolec_r.dart';
import 'package:aplicacion/views/ProlecR/prolec_r_a.dart';
import 'package:aplicacion/views/ProlecR/prolec_r_b.dart';
import 'package:aplicacion/views/ProlecR/prolec_r_c.dart';
import 'package:aplicacion/views/Use/teacher.dart';
import 'package:aplicacion/views/registerstudent.dart';
import 'package:get/get.dart';
import '../views/Prolec/prolec_d_b.dart';
import 'package:camera/camera.dart';
import '../views/Prolec/prolec_d_a.dart';
import '../views/login.dart';
import '../views/registerteacher.dart';

appRoutes({required List<CameraDescription> cameras}) => [
      GetPage(
        name: '/home',
        page: () => HomeLogin(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/registerTeacher',
        page: () => const LoginPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/registerStudent',
        page: () => const LoginStudentPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolec',
        page: () => ProlecPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecB',
        page: () => ProlecbPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecC',
        page: () => ProlecCPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecD_A',
        page: () => ProlecDAPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecD_B',
        page: () => ProlecDBPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecR',
        page: () => ProlecRPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecRA',
        page: () => ProlecRAPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecRB',
        page: () => ProlecRBPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/prolecRC',
        page: () => ProlecRCPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/teacherPage',
        page: () => TeacherPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ];
