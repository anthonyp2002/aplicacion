import 'package:aplicacion/controllers/Gustos_Controller/gustos_controller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecracontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrbcontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrccontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrcontroller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolec_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecb_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecc_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecd_a_controller.dart';
import 'package:aplicacion/controllers/UseController/studentcontroller.dart';
import 'package:aplicacion/controllers/UseController/teachercontroller.dart';
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/controllers/registercontroller.dart';
import 'package:get/get.dart';
import '../controllers/Prolec_Controller/prolecd_b_controller.dart';
import '../controllers/loginController.dart';

/// Clase `LoginBinding` que implementa `Bindings` de GetX en nuestro proyecto.
///
/// Esta clase se utiliza para inyectar las dependencias de los controladores en la aplicación utilizando GetX.
class LoginBinding implements Bindings {
  /// Sobreescribe el método `dependencies` de `Bindings`.
  ///
  /// Este método se utiliza para inyectar las dependencias de los controladores en la aplicación.
  @override
  void dependencies() {
    Get.put(InitController());
    Get.lazyPut(() => loginController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => ProlecController());
    Get.lazyPut(() => ProlecbController());
    Get.lazyPut(() => ProlecCController());
    Get.lazyPut(() => ProlecDAController());
    Get.lazyPut(() => ProlecRController());
    Get.lazyPut(() => ProlecRAController());
    Get.lazyPut(() => ProlecRBController());
    Get.lazyPut(() => ProlecDBController());
    Get.lazyPut(() => ProlecRCController());
    Get.lazyPut(() => TeacherController());
    Get.lazyPut(() => GustosController());
    Get.lazyPut(() => StudentController());
  }
}
