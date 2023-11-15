// ignore_for_file: non_constant_identifier_names, unused_element
import "package:aplicacion/models/prolecb_model.dart";
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

Future<List<String>> getPal() async {
  CollectionReference collectionReferenceWord = db.collection("Words");
  QuerySnapshot queryWord = await collectionReferenceWord.get();

  List<String> words = queryWord.docs
      .map((documento) => (documento['word'] as List<dynamic>)
          .map((dynamicWord) => dynamicWord.toString())
          .toList())
      .expand((wordList) => wordList)
      .toList();

  return words;
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

Future<void> addIamges(
    int id, String questions, Map<String, bool> answer) async {
  await db.collection("Images").add({
    "id": id,
    "questions": questions,
    "Answer": answer,
  });
}

Future<List<OptionsModel>> getImg() async {
  List<OptionsModel> img = [];
  CollectionReference collectionReferenceImg = db.collection("Images");
  QuerySnapshot queryImg = await collectionReferenceImg.get();

  for (var document in queryImg.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    int id = data['id'];
    String questions = data['questions'];
    Map<String, bool> answer = Map<String, bool>.from(data['Answer']);

    img.add(OptionsModel(id, questions, answer));
  }
  return img;
}
