import 'package:aplicacion/bindings/bindings.dart';
import 'package:aplicacion/routes/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  //Iniciamos las camaras
  final List<CameraDescription> cameras;
  const MyApp({required this.cameras, super.key});

  @override
  Widget build(BuildContext context) {
    print("Las camaras que tengo son: $cameras");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get Route Managment',
      initialRoute: '/home',
      getPages: appRoutes(cameras: cameras),
      initialBinding: LoginBinding(),
    );
  }
}
