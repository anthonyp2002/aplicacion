import 'package:aplicacion/controllers/ProlecR_Controller/prolecracontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrbcontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrccontroller.dart';
import 'package:aplicacion/controllers/ProlecR_Controller/prolecrcontroller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolec_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecb_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecc_controller.dart';
import 'package:aplicacion/controllers/Prolec_Controller/prolecd_a_controller.dart';
import 'package:aplicacion/controllers/initController.dart';
import 'package:aplicacion/controllers/registercontroller.dart';
import 'package:get/get.dart';
import '../controllers/Prolec_Controller/prolecd_b_controller.dart';
import '../controllers/loginController.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitController());
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
    Get.lazyPut(() => ProlecRCController());
  }
}
