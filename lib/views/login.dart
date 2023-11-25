// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member, sort_child_properties_last
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/loginController.dart';

// ignore: must_be_immutable
class HomeLogin extends GetView<loginController> {
  bool _obscureText = true;

  HomeLogin({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(loginController());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/color.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/nImg.png', width: 190),
                ],
              ),
              SizedBox(height: 2),
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                          key: controller.loginFormKey,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Iniciar Sesion',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10)),
                                  TextFormField(
                                    enableInteractiveSelection: false,
                                    autofocus: true,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                        hintText: "Usuario",
                                        labelText: "Usuario",
                                        suffixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                    validator: controller.validator,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10)),
                                  StatefulBuilder(builder: (context, setState) {
                                    return Column(
                                      children: [
                                        TextFormField(
                                          controller: controller.password,
                                          enableInteractiveSelection: false,
                                          autofocus: true,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            hintText: "Contraseña",
                                            labelText: "Contraseña",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            suffixIcon: GestureDetector(
                                              onTap: () => setState(() =>
                                                  _obscureText = !_obscureText),
                                              child: Icon(_obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                          ),
                                          validator: controller.validator,
                                          obscureText: _obscureText,
                                        ),
                                      ],
                                    );
                                  }),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10)),
                                  RawMaterialButton(
                                    onPressed: () {
                                      Get.offAllNamed('/teacherPage');
                                    },
                                    child: Text(
                                      'Ingresar',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    fillColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Tienes una cuenta? ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: 'Crear Cuenta',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller
                                                    .showAccountTypeDialog();
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
