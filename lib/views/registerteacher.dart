import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registercontroller.dart';

String pass = "";

class LoginPage extends GetView<RegisterController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return StatefulBuilder(builder: (context, setState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/fondo.png'), fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SafeArea(
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10)),
                              const Text(
                                'Crear Cuenta',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              _form(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaNueva = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (fechaNueva != null) {
      controller.ageController.text = fechaNueva.toIso8601String().substring(0,
          10); // Actualiza el texto del controlador con la fecha seleccionada
    }
    DateTime fecha = DateTime.parse(controller.ageController.text);
    controller.calculateAge(fecha);
  }

  //Formulario
  Widget _form(BuildContext context) {
    Get.put(RegisterController());
    bool obscu = true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Form(
        key: controller.singinFormKey,
        child: Column(children: [
          //Container: Input Name
          SizedBox(
            width: 270,
            child: TextFormField(
              enableInteractiveSelection: false,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Nombres",
                  labelText: "Nombres",
                  suffixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              validator: controller.username,
              controller: controller.fullNameControler,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          SizedBox(
            width: 270,
            child: TextFormField(
              enableInteractiveSelection: false,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Correo Electronico",
                  labelText: "Correo Electronico",
                  suffixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              validator: controller.email,
              controller: controller.gmailController,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          SizedBox(
            width: 270,
            child: TextFormField(
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Telefono",
                  labelText: "Telefono",
                  suffixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              validator: controller.validator,
              controller: controller.phoneController,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          SizedBox(
            width: 270,
            child: TextFormField(
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              autofocus: true,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: "Fecha De Nacimiento",
                  labelText: "Fecha De Nacimiento",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () {
                      _seleccionarFecha(context);
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              validator: controller.validator,
              controller: controller.ageController,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(
                  width: 270,
                  child: TextFormField(
                      enableInteractiveSelection: false,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "Contraseña",
                          labelText: "Contraseña",
                          suffixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      validator: controller.passwordValidator,
                      controller: controller.passwordController,
                      obscureText: obscu),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Confirmar Contraseña",
                      labelText: "Confirmar Contraseña",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscu = !obscu;
                            obscu = obscu;
                          });
                        },
                        child: Icon(
                            obscu ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    controller: controller.confirmController,
                    validator: controller.confirmPasswordValidator,
                    obscureText: obscu,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                RawMaterialButton(
                  onPressed: () {
                    //  Get.offAllNamed('/prolec');
                    controller.loginTe();
                  },
                  fillColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Registrarse',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Tienes una cuenta? ',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offAllNamed('/home');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ]),
      ),
    );
  }
}
