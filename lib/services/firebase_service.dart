// ignore_for_file: non_constant_identifier_names, unused_element

import "package:aplicacion/models/orto.dart";
import "package:aplicacion/models/prolcec_model.dart";
import "package:aplicacion/models/prolecb_model.dart";
import "package:aplicacion/models/seudo.dart";
import "package:aplicacion/models/userStudent.dart";
import "package:aplicacion/models/userTeacher.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:get/get.dart";

/// Crea una instancia de FirebaseFirestore.
FirebaseFirestore db = FirebaseFirestore.instance;

// Inicializa dos cadenas vacías.
String docuId = "";
String docuIdTeacer = "";

/// Obtiene una lista de palabras de Firestore.
///
/// Esta función consulta la colección "PalabrasVoz" en Firestore y devuelve una lista de palabras.
Future<List<String>> getPal() async {
  // Obtiene una referencia a la colección "PalabrasVoz".
  CollectionReference collectionReferenceWord =
      db.collection("Data").doc("Words").collection("PalabrasVoz");

  // Realiza la consulta a Firestore.
  QuerySnapshot queryWord = await collectionReferenceWord.get();

  // Mapea los documentos devueltos por la consulta a una lista de palabras.
  List<String> words = queryWord.docs
      .map((documento) => (documento['word'] as List<dynamic>)
          .map((dynamicWord) => dynamicWord.toString())
          .toList())
      .expand((wordList) => wordList)
      .toList();

  // Devuelve la lista de palabras.
  return words;
}

/// Obtiene una lista de estudiantes de Firestore.
///
/// Esta función consulta la colección 'CuentaStudent' en Firestore y devuelve una lista de estudiantes (`UserStudent`).
Future<RxList<UserStudent>> getStudenT() async {
  // Crea una lista observable de estudiantes.
  RxList<UserStudent> students = <UserStudent>[].obs;

  // Realiza la consulta a Firestore.
  await db
      .collection('CuentaStudent')
      .where('idTeacher', isEqualTo: docuIdTeacer)
      .get()
      .then((QuerySnapshot querySnapshot) {
    // Para cada documento devuelto por la consulta, crea una nueva instancia de `UserStudent` y la añade a la lista de estudiantes.
    for (var doc in querySnapshot.docs) {
      students.add(UserStudent.fromDocument(doc));
      print(doc);
    }
  });

  // Devuelve la lista de estudiantes.
  return students;
}

/// Obtiene una lista de profesor de Firestore.
///
/// Esta función consulta la colección 'CuentaTeacher' en Firestore y devuelve una lista que contiene un solo profesor (`UserTeacher`),
/// o una lista vacía si no se encuentra ningún profesor con el ID especificado.
Future<RxList<UserTeacher>> getTeache() async {
  // Crea una lista observable de profesores.
  RxList<UserTeacher> teacher = <UserTeacher>[].obs;

  // Obtiene un documento de la colección 'CuentaTeacher' con el ID especificado.
  DocumentSnapshot doc =
      await db.collection('CuentaTeacher').doc(docuIdTeacer).get();

  // Si el documento existe, crea una nueva instancia de `UserTeacher` y la añade a la lista de profesores.
  if (doc.exists) {
    teacher.add(UserTeacher.fromDocument(doc));
    return teacher;
  } else {
    // Si el documento no existe, imprime un mensaje de error y devuelve la lista vacía.
    print('No se encontró un profesor con el ID: $docuIdTeacer');
    return teacher;
  }
}

/// Añade un nuevo estudiante a Firestore.
///
/// Esta función crea un nuevo documento en la colección 'CuentaStudent' en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `name`: El nombre del estudiante.
/// - `birthdate`: La fecha de nacimiento del estudiante.
/// - `schoolYear`: El año escolar del estudiante.
/// - `password`: La contraseña del estudiante.
Future<void> addStudent(
    String name, String birthdate, String schoolYear, String password) async {
  // Obtiene una referencia a la colección 'CuentaStudent'.
  CollectionReference cuentaCollection = db.collection("CuentaStudent");

  // Crea un nuevo documento en la colección con los datos proporcionados.
  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "birthdate": birthdate,
    "schoolYear": schoolYear,
    "password": password,
    "idTeacher": docuIdTeacer
  });

  // Guarda el ID del documento creado.
  docuId = documentReference.id;

  // Imprime el ID del documento creado.
  print("ID del documento creado: $docuId");
}

/// Añade un nuevo profesor a Firestore.
///
/// Esta función crea un nuevo documento en la colección 'CuentaTeacher' en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `name`: El nombre del profesor.
/// - `gmail`: El correo electrónico del profesor.
/// - `birthdate`: La fecha de nacimiento del profesor.
/// - `phone`: El teléfono del profesor.
/// - `password`: La contraseña del profesor.
Future<void> addTea(String name, String gmail, String phone, String birthdate,
    String password) async {
  // Obtiene una referencia a la colección 'CuentaTeacher'.
  CollectionReference cuentaCollection = db.collection("CuentaTeacher");

  // Crea un nuevo documento en la colección con los datos proporcionados.
  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "gmail": gmail,
    "birthdate": birthdate,
    "phone": phone,
    "password": password
  });

  // Guarda el ID del documento creado.
  docuIdTeacer = documentReference.id;

  // Imprime el ID del documento creado.
  print("ID del documento creado: $docuIdTeacer");
}

/// Añade nuevas puntuaciones a Firestore.
///
/// Esta función crea un nuevo documento en la subcolección 'Puntuaciones' del estudiante actual en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `nameUse`: El nombre del estudiante.
/// - `time`: El tiempo de la prueba.
/// - `pnt`: La puntuación de la prueba de imágenes.
/// - `pntH`: La puntuación de la prueba de historia.
/// - `pntO`: La puntuación de la prueba de órdenes.
/// - `pntI`: La puntuación de la prueba de palabras sí.
/// - `pntA`: La puntuación de la prueba de antónimos.
/// - `pntOr`: La puntuación de la prueba de ortografía.
/// - `pntS`: La puntuación de la prueba de sinónimos.
Future<void> addPunctuations(String nameUse, String time, int pnt, int pntH,
    int pntO, int pntI, int pntA, int pntOr, int pntS) async {
  // Crea un nuevo documento en la subcolección 'Puntuaciones' del estudiante actual con los datos proporcionados.
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

/// Añade un nuevo informe de Imagenes de nuestro cuestionario a Firestore.
///
/// Esta función crea un nuevo documento en la subcolección 'ImagesProlec' del estudiante actual en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `Img`: Un mapa que contiene los datos de la imagen. Las claves son cadenas de texto y los valores son cadenas de texto.
/// - `tipe`: El tipo de la imagen.
Future<void> addInformeImg(Map<String, String> Img, String tipe) async {
  // Imprime el ID del documento del estudiante actual.
  print(docuId);

  // Crea un nuevo documento en la subcolección 'ImagesProlec' del estudiante actual con los datos proporcionados.
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

/// Añade un nuevo informe de historia a Firestore.
///
/// Esta función crea un nuevo documento en la subcolección especificada del estudiante actual en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `res`: Una lista de mapas que contienen los datos de la historia. Cada mapa tiene una cadena de texto como clave y otro mapa como valor. El mapa interno tiene una cadena de texto como clave y otra cadena de texto como valor.
/// - `titulo`: El título de la historia.
/// - `tipe`: El tipo de la historia.
Future<void> addInformeSt(List<Map<String, Map<String, String>>> res,
    String titulo, String tipe) async {
  // Imprime el ID del documento del estudiante actual.
  print(docuId);

  // Crea un nuevo documento en la subcolección especificada del estudiante actual con los datos proporcionados.
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

/// Añade un nuevo informe de palabras a Firestore.
///
/// Esta función crea un nuevo documento en la subcolección especificada del estudiante actual en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `palabras`: Una lista de palabras que se agregarán al informe.
/// - `name`: El nombre de la colección donde se agregará el informe.
/// - `tipe`: El tipo de palabras que se están agregando.
Future<void> addInforme(List<String> palabras, String name, String tipe) async {
  // Imprime el ID del documento del estudiante actual.
  print(docuId);

  // Crea un nuevo documento en la subcolección especificada del estudiante actual con los datos proporcionados.
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

/// Obtiene una lista de imágenes de Firestore.
///
/// Esta función recupera una lista de imágenes de la subcolección 'ImagenesProlec' en Firestore y las devuelve como una
/// lista de objetos `OptionsModel`.
///
/// @return Un `Future<List<OptionsModel>>` que completa con la lista de objetos `OptionsModel` cuando la operación
/// de recuperación de la base de datos se ha realizado.
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

/// Obtiene una lista de historias de Firestore.
///
/// Esta función recupera una lista de historias de la subcolección 'Stories' en Firestore y las devuelve como una lista de objetos `OptionsText`.
///
/// @return Un `Future<List<OptionsText>>` que completa con la lista de objetos `OptionsText` cuando la operación de recuperación de la base de datos se ha realizado.
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

/// Obtiene una lista de ortografías de Firestore.
///
/// Esta función recupera una lista de ortografías de la subcolección 'Ortografia' en Firestore y las devuelve como una lista de objetos `OrtModel`.
///
/// @return Un `Future<List<OrtModel>>` que completa con la lista de objetos `OrtModel` cuando la operación de recuperación de la base de datos se ha realizado.
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

/// Obtiene una lista de palabras de Firestore.
///
/// Esta función recupera una lista de palabras de la subcolección especificada en Firestore y las devuelve como una lista de objetos `SeudoModel`.
///
/// Parámetros:
/// - `palabras`: El nombre de la subcolección de donde se recuperarán las palabras.
///
/// @return Un `Future<List<SeudoModel>>` que completa con la lista de objetos `SeudoModel` cuando la operación de recuperación de la base de datos se ha realizado.
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

/// Actualiza los datos de un estudiante en Firestore.
///
/// Esta función actualiza los datos del estudiante especificado en la colección 'CuentaStudent' en Firestore con los datos proporcionados.
///
/// Parámetros:
/// - `user`: Un objeto `UserStudent` que contiene los datos del estudiante que se actualizarán.
///
/// @return Un `Future<void>` que completa cuando la operación de actualización de la base de datos se ha realizado.
Future<void> updateStudent(UserStudent user) async {
  await db.collection("CuentaStudent").doc(user.idStudent).set({
    "name": user.fullname,
    "birthdate": user.birthdate,
    "schoolYear": user.anioLec,
    "password": user.password,
    "idTeacher": user.idTeacher
  });
}
