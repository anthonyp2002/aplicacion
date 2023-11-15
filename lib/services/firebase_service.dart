import "dart:ffi";

import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPuntuacion() async {
  //Ejercicio Uno del cuestionario
  List exerciseOne = [];
  CollectionReference collectionReferenceExerciseOne =
      db.collection("ExerciseOne");
  QuerySnapshot queryExerciseOne = await collectionReferenceExerciseOne.get();

  queryExerciseOne.docs.forEach((documento) {
    exerciseOne.add(documento.data());
  });
  return exerciseOne;
}

Future<void> addStudent(
    String name, String age, String schoolYear, String password) async {
  await db.collection("UserStudent").add({
    "name": name,
    "age": age,
    "schoolYear": schoolYear,
    "password": password
  });
}

Future<void> addPunctuationOne(String time) async {
  await db.collection("ExerciseOne").add({"time": time});
}

Future<void> addPunctuationTwo(String pnt) async {
  await db.collection("ExerciseTwo").add({"scoreImg": pnt});
}

Future<void> addPunctuationThree(String pntH) async {
  await db.collection("ExerciseTwo").add({"scoreHistory": pntH});
}

Future<void> addPalabras(List palabras) async {
  await db.collection("Words").add({"word": palabras});
}

Future<void> addPunctuations(String nameUse, String time, int pnt, int pntH,
    int pntO, int pntI, int pntA, int pntOr, int pntS) async {
  await db.collection("Punctuations").add({
    "NameUserStudent": nameUse,
    "PunctuationTime": time,
    "PunctuationImg": pnt,
    "PunctuationHistory": pntH,
    "PunctuationOrdenes": pntO,
    "PunctuationPalabrasSi": pntI,
    "PunctuationAntonimos": pntA,
    "PunctuationOrtografia": pntOr,
    "PunctuationSinonimos": pntS
  });
}
