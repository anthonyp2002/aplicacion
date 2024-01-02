// Importa el paquete cloud_firestore, que proporciona una API para interactuar con Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase `UserTeacher` que representa a un profesor.
///
/// Cada instancia de `UserTeacher` tiene cinco propiedades: nombre completo (`fullname`), correo electrónico (`gmail`), teléfono (`phone`), edad (`age`) y contraseña (`password`).
class UserTeacher {
  final String fullname;
  final String gmail;
  final String edad;
  final String phone;
  final String age;
  final String password;

  /// Crea una nueva instancia de `UserTeacher`.
  ///
  /// Todos los parámetros son requeridos y no pueden ser `null`.
  UserTeacher({
    required this.fullname,
    required this.gmail,
    required this.edad,
    required this.phone,
    required this.age,
    required this.password,
  });

  /// Crea una nueva instancia de `UserTeacher` a partir de un documento de Firestore.
  ///
  /// Este es un constructor de fábrica que toma un `DocumentSnapshot` (un documento de Firestore) y crea una nueva instancia de `UserTeacher` con los datos del documento.
  factory UserTeacher.fromDocument(DocumentSnapshot doc) {
    return UserTeacher(
      gmail: doc["gmail"],
      edad: doc['age'],
      phone: doc["phone"],
      fullname: doc['name'],
      age: doc["birthdate"],
      password: doc["password"],
    );
  }
}
