// ignore_for_file: non_constant_identifier_names, unused_element, avoid_print

import "package:aplicacion/models/img_gustos.dart";
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
String docuIdStudent = "";
int a = 0;

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
  print(docuId);
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

/// Obtiene una lista de profesor de Firestore.
///
/// Esta función consulta la colección 'CuentaTeacher' en Firestore y devuelve una lista que contiene un solo profesor (`UserTeacher`),
/// o una lista vacía si no se encuentra ningún profesor con el ID especificado.
Future<RxList<UserStudent>> getEstudiante() async {
  // Crea una lista observable de profesores.
  RxList<UserStudent> student = <UserStudent>[].obs;

  // Obtiene un documento de la colección 'CuentaTeacher' con el ID especificado.
  print(docuId);
  DocumentSnapshot doc = await db.collection('CuentaStudent').doc(docuId).get();

  // Si el documento existe, crea una nueva instancia de `UserTeacher` y la añade a la lista de profesores.
  if (doc.exists) {
    student.add(UserStudent.fromDocument(doc));
    return student;
  } else {
    // Si el documento no existe, imprime un mensaje de error y devuelve la lista vacía.
    print('No se encontró un profesor con el ID: $docuIdTeacer');
    return student;
  }
}

Future<void> addIamges(
    int id, String questions, Map<String, Map<String, bool>> images) async {
  print(images);
  try {
    await FirebaseFirestore.instance
        .collection("Data")
        .doc("Images")
        .collection("ImagenesGustos")
        .add({
      "id": id,
      "questions": questions,
      "UrlImages": images,
      // ... otros campos y valores que desees agregar
    });
  } catch (error) {
    print('Error al agregar datos: $error');
  }
}

/// Obtiene una lista de profesor de Firestore.
///
/// Esta función consulta la colección 'CuentaTeacher' en Firestore y devuelve una lista que contiene un solo profesor (`UserTeacher`),
/// o una lista vacía si no se encuentra ningún profesor con el ID especificado.
Future<RxList<UserStudent>> getStuByName(String name) async {
  // Crea una lista observable de estudiantes.
  RxList<UserStudent> students = <UserStudent>[].obs;
  print("Id del profesor es $docuIdTeacer");
  print("Estudiante a buscar $name");
  // Realiza la consulta a Firestore.
  await db
      .collection('CuentaStudent')
      .where('name', isEqualTo: name)
      .where('idTeacher', isEqualTo: docuIdTeacer)
      .get()
      .then((QuerySnapshot querySnapshot) {
    // Para cada documento devuelto por la consulta, crea una nueva instancia de `UserStudent` y la añade a la lista de estudiantes.
    for (var doc in querySnapshot.docs) {
      print("Entro");
      students.add(UserStudent.fromDocument(doc));
      print(doc);
    }
  });
  // Devuelve la lista de estudiantes.
  return students;
}

Future<RxInt> Cuestionarios(RxList<UserStudent> students) async {
  RxInt cantidadCuestionarios = 0.obs;
  for (var student in students) {
    print(student.idStudent);
    final querySnapshot = await db
        .collection("CuentaStudent")
        .doc(student.idStudent)
        .collection("Cuestionarios")
        .get();
    cantidadCuestionarios = querySnapshot.docs.length.obs;
    print("La cantidad de cuestionarios es $cantidadCuestionarios");
  }

  return cantidadCuestionarios;
}

Future<String> verificarCredenciales(String name, String password) async {
  print("MI nombre es $name");
  print("Mi contraseña es $password");
  try {
    // Consulta en la colección de profesores
    QuerySnapshot estudiantesSnapshot = await FirebaseFirestore.instance
        .collection('CuentaStudent')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    if (estudiantesSnapshot.docs.isNotEmpty) {
      String id = estudiantesSnapshot.docs[0].id;
      docuId = id;
      print("El id de mi documento es $docuId");
      return 'Student';
    }

    print("El id de mi documento es $docuId");

    QuerySnapshot profesoresSnapshot = await FirebaseFirestore.instance
        .collection('CuentaTeacher')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    print(docuIdTeacer);

    if (profesoresSnapshot.docs.isNotEmpty) {
      String idT = profesoresSnapshot.docs[0].id;
      docuIdTeacer = idT;
      print("El id de mi documento es $docuIdTeacer");
      return 'Teacher';
    }

    print("El id de mi documento es $docuIdTeacer");

    // Si no se encuentra en ninguna colección
    return 'usuario_no_encontrado';
  } catch (e) {
    print('Error al consultar Firestore: $e');
    return 'error';
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
Future<void> addStudent(String name, String birthdate, String age,
    String schoolYear, String password) async {
  // Obtiene una referencia a la colección 'CuentaStudent'.
  CollectionReference cuentaCollection = db.collection("CuentaStudent");

  // Crea un nuevo documento en la colección con los datos proporcionados.
  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "birthdate": birthdate,
    "age": age,
    "schoolYear": schoolYear + " Basica",
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
Future<void> addTea(String name, String gmail, String age, String phone,
    String birthdate, String password) async {
  // Obtiene una referencia a la colección 'CuentaTeacher'.
  CollectionReference cuentaCollection = db.collection("CuentaTeacher");

  // Crea un nuevo documento en la colección con los datos proporcionados.
  DocumentReference documentReference = await cuentaCollection.add({
    "name": name,
    "gmail": gmail,
    "birthdate": birthdate,
    "age": age,
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
Future<void> addCuestionario(String nameUse, String time, int pnt, int pntH,
    int pntO, int pntI, int pntA, int pntOr, int pntS) async {
  // Crea un nuevo documento en la subcolección 'Puntuaciones' del estudiante actual con los datos proporcionados.

  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Cuestionarios")
      .doc("Cuestions ${a}")
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
  try {
    final querySnapshot = await db
        .collection("CuentaStudent")
        .doc(docuId)
        .collection("Cuestionarios")
        .get();
    final cantidadCuestionarios = querySnapshot.docs.length;
    a = cantidadCuestionarios;
    a++;
    print("La cantidad de cuestionarios es $cantidadCuestionarios");
  } catch (e) {
    print('Ocurrió un error: $e');
  }
  // Crea un nuevo documento en la subcolección 'ImagesProlec' del estudiante actual con los datos proporcionados.
  await db
      .collection("CuentaStudent")
      .doc(docuId)
      .collection("Cuestionarios")
      .doc("Cuestions $a")
      .collection("Informe")
      .doc("ImagesProlec")
      .collection("Eleccion")
      .add({
    tipe: Img,
  });

  await addCFe();
}

Future<void> addCFe() async {
  print(docuId);
  DateTime now = DateTime.now();

  CollectionReference cuentaCollection =
      db.collection("CuentaStudent").doc(docuId).collection("Cuestionarios");
  DocumentReference documentReference = cuentaCollection.doc("Cuestions $a");

  await documentReference.set({
    "Fecha": now,
    // Otros campos si es necesario
  });
}

Future<void> addGusto(List gustos, String tipe) async {
  // Imprime el ID del documento del estudiante actual.
  print(docuId);

  CollectionReference cuentaCollection =
      db.collection("CuentaStudent").doc(docuId).collection("Gustos");

  // Crea un nuevo documento en la colección con los datos proporcionados.
  DocumentReference documentReference = await cuentaCollection.add({
    tipe: gustos,
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
      .collection("Cuestionarios")
      .doc("Cuestions $a")
      .collection("Informe")
      .doc("Historias")
      .collection(titulo)
      .add({tipe: res});
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
      .collection("Cuestionarios")
      .doc("Cuestions $a")
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

/// Obtiene una lista de historias de Firestore.
///
/// Esta función recupera una lista de historias de la subcolección 'Stories' en Firestore y las devuelve como una lista de objetos `OptionsText`.
///
/// @return Un `Future<List<OptionsText>>` que completa con la lista de objetos `OptionsText` cuando la operación de recuperación de la base de datos se ha realizado.
Future<RxList> getCuestionarios() async {
  RxList cuestionarios = [].obs;
  print(docuId);
  try {
    final querySnapshot = await db
        .collection("CuentaStudent")
        .doc(docuId)
        .collection("Cuestionarios")
        .get();

    int cantidadCuestionarios = querySnapshot.size;
    querySnapshot.docs.forEach((document) {
      String cuestionarioId = document.id;
      Timestamp timestamp = (document.data() as Map<String, dynamic>)[
          'Fecha']; // Ajusta la clave según la estructura de tus documentos
      DateTime fechaCuestionario = timestamp.toDate();
      // Guardar ID y fecha en la lista
      Map<String, dynamic> cuestionarioInfo = {
        "id": cuestionarioId,
        'Fecha': fechaCuestionario,
      };
      cuestionarios.add(cuestionarioInfo);
    });
    print("La cantidad de cuestionarios es $cantidadCuestionarios");
    print("Los cuestionarios son $cuestionarios");
    return cuestionarios;
  } catch (e) {
    print('Ocurrió un error: $e');
    return cuestionarios;
  }
}

Future<RxList> getCuestionariosID(String StudentId) async {
  RxList cuestionarios = [].obs;
  String cuestionarioId = "";
  try {
    final querySnapshot = await db
        .collection("CuentaStudent")
        .doc(StudentId)
        .collection("Cuestionarios")
        .get();

    int cantidadCuestionarios = querySnapshot.size;
    querySnapshot.docs.forEach((document) {
      cuestionarioId = document.id;
      Timestamp timestamp = (document.data() as Map<String, dynamic>)[
          'Fecha']; // Ajusta la clave según la estructura de tus documentos
      DateTime fechaCuestionario = timestamp.toDate();
      // Guardar ID y fecha en la lista
      Map<String, dynamic> cuestionarioInfo = {
        "id": cuestionarioId,
        'Fecha': fechaCuestionario,
      };
      cuestionarios.add(cuestionarioInfo);
    });
    print("La cantidad de cuestionarios es $cantidadCuestionarios");
    print("Los cuestionarios son $cuestionarios");

    //getCuesInfDe(StudentId, cuestionarioId);
    return cuestionarios;
  } catch (e) {
    print('Ocurrió un error: $e');
    return cuestionarios;
  }
}

Future<Map<String, dynamic>?> getCuesInfDe(StudentId, CuestID) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("CuentaStudent")
        .doc(StudentId)
        .collection("Cuestionarios")
        .doc(CuestID)
        .collection("Puntuaciones")
        .get();

    // Verificar si hay documentos en la colección
    if (querySnapshot.docs.isNotEmpty) {
      // Obtener el primer documento (puedes ajustar esto según tus necesidades)
      DocumentSnapshot doc = querySnapshot.docs[0];

      // Acceder a los datos del documento
      Map<String, dynamic> datos = doc.data() as Map<String, dynamic>;

      // Hacer algo con los datos...
      print("Datos del documento: $datos");

      // Retornar el Map con los datos
      return datos;
    } else {
      print("La colección está vacía");
      return null;
    }
  } catch (error) {
    print("Error al obtener datos: $error");
    return null;
  }
}

Future<bool> getGustos() async {
  try {
    final querySnapshot = await db
        .collection("CuentaStudent")
        .doc(docuId)
        .collection("Gustos")
        .get();

    // Verificar si hay documentos en la colección
    if (querySnapshot.docs.isNotEmpty) {
      // Hay documentos en la colección
      return true;
    } else {
      // No hay documentos en la colección
      return false;
    }
  } catch (e) {
    print('Ocurrió un error: $e');
    return false;
  }
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
    "age": user.age,
    "password": user.password,
    "idTeacher": user.idTeacher
  });
}

Future<List<ImgGustos>> getGustosOne() async {
  List<ImgGustos> gus = [];
  CollectionReference collectionReferenceImg =
      db.collection("Data").doc("Images").collection("ImagenesGustos");
  QuerySnapshot queryImg = await collectionReferenceImg.get();

  for (var document in queryImg.docs) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    int id = data['id'];
    String questions = data['questions'];

    // Check the actual type of data['UrlImages']
    if (data['UrlImages'] is Map<String, dynamic>) {
      Map<String, dynamic> imagData = data['UrlImages'];
      Map<String, Map<String, bool>> imag = imagData.map((key, value) {
        return MapEntry(key, Map<String, bool>.from(value));
      });
      gus.add(ImgGustos(id, questions, imag));
    } else {
      // Handle the case when data['UrlImages'] is not of the expected type
      // You might want to log an error or handle it in a way that makes sense for your application.
    }
  }
  return gus;
}
