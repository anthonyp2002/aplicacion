// ignore_for_file: non_constant_identifier_names, unused_element

import "package:aplicacion/models/orto.dart";
import "package:aplicacion/models/prolcec_model.dart";
import "package:aplicacion/models/prolecb_model.dart";
import "package:aplicacion/models/seudo.dart";
import "package:aplicacion/models/userStudent.dart";
import "package:aplicacion/models/userTeacher.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:get/get.dart";

FirebaseFirestore db = FirebaseFirestore.instance;
String docuId = "";
String docuIdTeacer = "";

Future<List<String>> getPal() async {
  CollectionReference collectionReferenceWord =
      db.collection("Data").doc("Words").collection("PalabrasVoz");
  QuerySnapshot queryWord = await collectionReferenceWord.get();

  List<String> words = queryWord.docs
      .map((documento) => (documento['word'] as List<dynamic>)
          .map((dynamicWord) => dynamicWord.toString())
          .toList())
      .expand((wordList) => wordList)
      .toList();
  return words;
}

Future<RxList<UserStudent>> getStudenT() async {
  RxList<UserStudent> students = <UserStudent>[].obs;
  await db
      .collection('CuentaStudent')
      .where('idTeacher', isEqualTo: docuIdTeacer)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      students.add(UserStudent.fromDocument(doc));
      print(doc);
    }
  });
  return students;
}

Future<RxList<UserTeacher>> getTeacher() async {
  RxList<UserTeacher> teacer = <UserTeacher>[].obs;
  await db
      .collection('CuentaTeacher')
      .where('idTeacher', isEqualTo: docuIdTeacer)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      teacer.add(UserTeacher.fromDocument(doc));
    }
  });
  return teacer;
}

Future<RxList<UserTeacher>> getTeache() async {
  RxList<UserTeacher> teacer = <UserTeacher>[].obs;

  DocumentSnapshot doc =
      await db.collection('CuentaTeacher').doc(docuIdTeacer).get();
  if (doc.exists) {
    teacer.add(UserTeacher.fromDocument(doc));
    return teacer;
  } else {
    print('No se encontró un profesor con el ID: $docuIdTeacer');
    return teacer;
  }
}

Future<void> addStudent(
    String name, String birthdate, String schoolYear, String password) async {
  CollectionReference cuentaCollection = db.collection("CuentaStudent");

  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "birthdate": birthdate,
    "schoolYear": schoolYear,
    "password": password,
    "idTeacher": docuIdTeacer
  });
  docuId = documentReference.id;

  print("ID del documento creado: $docuId");
}

Future<void> addTea(String name, String gmail, String phone, String birthdate,
    String password) async {
  CollectionReference cuentaCollection = db.collection("CuentaTeacher");

  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "gmail": gmail,
    "birthdate": birthdate,
    "phone": phone,
    "password": password
  });
  docuIdTeacer = documentReference.id;
  getTeache();
  print("ID del documento creado: $docuIdTeacer");
}

Future<void> addPunctuations(String nameUse, String time, int pnt, int pntH,
    int pntO, int pntI, int pntA, int pntOr, int pntS) async {
  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Puntuaciones")
      .add({
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

Future<void> addInformeImg(Map<String, String> Img, String tipe) async {
  print(docuId);
  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Informe")
      .doc("Images")
      .collection("ImagesProlec")
      .add({
    tipe: Img,
  });
}

Future<void> addInformeSt(List<Map<String, Map<String, String>>> res,
    String titulo, String tipe) async {
  print(docuId);
  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Informe")
      .doc("Historias")
      .collection(titulo)
      .add({
    tipe: res,
  });
}

Future<void> addInforme(List<String> palabras, String name, String tipe) async {
  print(docuId);
  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Informe")
      .doc("Words")
      .collection(name)
      .add({
    tipe: palabras,
  });
}

Future<List<OptionsModel>> getImg() async {
  List<OptionsModel> img = [];
  CollectionReference collectionReferenceImg =
      db.collection("Data").doc("Images").collection("ImagenesProlec");
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

Future<List<OptionsText>> getStories() async {
  List<OptionsText> text = [];
  CollectionReference collectionReferenceImg =
      db.collection("Data").doc("Text").collection("Stories");
  QuerySnapshot queryImg = await collectionReferenceImg.get();

  for (var document in queryImg.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    int id = data['id'];
    String titulo = data['titulo'];
    String texto = data['texto'];
    List<String> questions = List<String>.from(data['preguntas']);
    List<String> respuestas = List<String>.from(data['respuesta']);

    text.add(OptionsText(id, titulo, texto, questions, respuestas));
  }
  return text;
}

Future<List<OrtModel>> getOrtografia() async {
  List<OrtModel> ortografia = [];
  CollectionReference collectionReferenceImg =
      db.collection("Data").doc("Words").collection("Ortografia");
  QuerySnapshot queryImg = await collectionReferenceImg.get();

  for (var document in queryImg.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    int id = data['id'];
    Map<String, bool> answer = Map<String, bool>.from(data['answer']);

    ortografia.add(OrtModel(id, answer));
  }
  return ortografia;
}

Future<List<SeudoModel>> getPalabras(String palabras) async {
  List<SeudoModel> pal = [];
  CollectionReference collectionReferenceImg =
      db.collection("Data").doc("Words").collection(palabras);
  QuerySnapshot queryImg = await collectionReferenceImg.get();

  for (var document in queryImg.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    int id = data['id'];
    String words = data['words'];
    Map<String, bool> answer = Map<String, bool>.from(data['answer']);

    pal.add(SeudoModel(id, words, answer));
  }
  return pal;
}

Future<void> updateStudent(UserStudent user) async {
  await db.collection("CuentaStudent").doc(user.idStudent).set({
    "name": user.fullname,
    "birthdate": user.birthdate,
    "schoolYear": user.anioLec,
    "password": user.password,
    "idTeacher": user.idTeacher
  });
}
