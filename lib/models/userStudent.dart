// Importa el paquete cloud_firestore, que proporciona una API para interactuar con Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase `UserStudent` que representa a un estudiante.
///
/// Cada instancia de `UserStudent` tiene seis propiedades: identificador del estudiante (`idStudent`), nombre completo (`fullname`), fecha de nacimiento (`birthdate`), año lectivo (`anioLec`), contraseña (`password`) e identificador del profesor (`idTeacher`).
class UserStudent {
  final String idStudent;
  final String fullname;
  final String birthdate;
  final String age;
  final String anioLec;
  final String password;
  final String idTeacher;

  /// Crea una nueva instancia de `UserStudent`.
  ///
  /// Todos los parámetros son requeridos y no pueden ser `null`.
  UserStudent(
      {required this.idStudent,
      required this.fullname,
      required this.birthdate,
      required this.age,
      required this.anioLec,
      required this.password,
      required this.idTeacher});

  /// Crea una nueva instancia de `UserStudent` a partir de un documento de Firestore.
  ///
  /// Este es un constructor de fábrica que toma un `DocumentSnapshot` (un documento de Firestore) y crea una nueva instancia de `UserStudent` con los datos del documento.
  factory UserStudent.fromDocument(DocumentSnapshot doc) {
    return UserStudent(
      idStudent: doc.id,
      fullname: doc['name'],
      birthdate: doc["birthdate"],
      age: doc["age"],
      anioLec: doc["schoolYear"],
      password: doc["password"],
      idTeacher: doc['idTeacher'],
    );
  }
}
