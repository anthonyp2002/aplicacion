import 'package:get/get.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import '../models/user.dart';

class GuardarExcel extends GetxController {
  late User user;
  late String crono;
  late int puntImg;
  late int puntOra;
  late int puntText;
  late int puntSin;
  late int puntAnt;
  late int puntSeu;
  late int puntOrt;
  var newsheetnuevo = '';

  void datos(User a) {
    user = a;
    crono = "";
    puntImg = 0;
    puntOra = 0;
    puntText = 0;
    puntSin = 0;
    puntAnt = 0;
    puntSeu = 0;
    puntOrt = 0;
    saveData(user, crono, puntImg, puntText, puntOrt, puntSin, puntAnt, puntOrt,
        puntSeu);
  }

  void puntuacionSino(int puntuacion) {
    puntSin = puntuacion;
    puntText = 6;

    saveData(user, crono, puntImg, puntText, puntOrt, puntSin, puntAnt, puntOrt,
        puntSeu);
  }

  Future<void> saveData(
      User users,
      String cronometro,
      int puntImg,
      int puntTextos,
      int puntOrac,
      int sinonimo,
      int antonimo,
      int ortografia,
      int seudopalabra) async {
    String inputFile =
        "/storage/emulated/0/Android/data/com.example.app/files/Datos.xlsx";
    String outputFile =
        "/storage/emulated/0/Android/data/com.example.app/files/Datos.xlsx";

    var bytes = File(inputFile).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    if (excel.tables.containsKey('Datos')) {
      int count = 2;
      while (excel.tables.containsKey('Datos$count')) {
        count++;
      }
      var newSheetName = 'Datos$count';
      newsheetnuevo = 'Datos$count';
      var cellIndex = CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0);
      var value = 'Nuevos, Datos!';

      excel.updateCell(newSheetName, cellIndex, value);
      var newSheet = excel.tables[newSheetName]!;

      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = 'Nombre';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
          .value = 'Edad';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
          .value = 'Año Lectivo';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
          .value = 'Gmail';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
          .value = 'Telefono';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3))
          .value = 'Procesos Lexicos - Lectura de Procesos: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 6))
          .value = 'Procesos Sintaticos - Estructuras Gramaticas: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 9))
          .value = 'Procesos Semanticos - Comprension de Textos: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 12))
          .value = 'Procesos Semanticos - Comprension de Oraciones: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 15))
          .value = 'Seudopalabras: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 18))
          .value = 'Ortografia: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 21))
          .value = 'Sinonimo: ';
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 24))
          .value = 'Antonimo: ';

      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0 + 1))
          .value = users.fullname;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0 + 1))
          .value = users.age;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0 + 1))
          .value = users.anioLec;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0 + 1))
          .value = users.gmail;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0 + 1))
          .value = users.phone;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4))
          .value = cronometro;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 7))
          .value = puntImg;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 10))
          .value = puntTextos;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 13))
          .value = puntOrac;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 16))
          .value = seudopalabra;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 19))
          .value = ortografia;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 22))
          .value = sinonimo;
      newSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 25))
          .value = antonimo;
    } else {
      // El sheet "Datos" no existe, agregar los valores a ese sheet
      var sheet = excel['Datos'];

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = 'Nombre';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
          .value = 'Edad';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
          .value = 'Año Lectivo';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
          .value = 'Gmail';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
          .value = 'Telefono';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3))
          .value = 'Procesos Lexicos - Lectura de Procesos: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 6))
          .value = 'Procesos Sintaticos - Estructuras Gramaticas: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 9))
          .value = 'Procesos Semanticos - Comprension de Textos: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 12))
          .value = 'Procesos Semanticos - Comprension de Oraciones: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 15))
          .value = 'Seudopalabras: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 18))
          .value = 'Ortografia: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 21))
          .value = 'Sinonimo: ';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 24))
          .value = 'Antonimo: ';

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0 + 1))
          .value = users.fullname;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0 + 1))
          .value = users.age;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0 + 1))
          .value = users.anioLec;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0 + 1))
          .value = users.gmail;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0 + 1))
          .value = users.phone;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4))
          .value = cronometro;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 7))
          .value = puntImg;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 10))
          .value = puntTextos;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 13))
          .value = puntOrac;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 16))
          .value = seudopalabra;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 19))
          .value = ortografia;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 22))
          .value = sinonimo;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 25))
          .value = antonimo;
    }

    var modifiedBytes = excel.encode();
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(modifiedBytes!);
  }

  void main(List<String> args) {
    String inputFile =
        "/storage/emulated/0/Android/data/com.example.app/files/Datos.xlsx";
    String outputFile =
        "/storage/emulated/0/Android/data/com.example.app/files/Datos.xlsx";
    // Cargar el archivo Excel existente
    var bytes = File(inputFile).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    // Obtener el sheet en el que deseas modificar la celda
    var sheetName = newsheetnuevo;
    var sheet = excel[sheetName];

    // Obtener el nuevo dato ingresado (por ejemplo, desde el usuario)
    var nuevoDato = "Nuevo Valor";

    // Actualizar la celda correspondiente con el nuevo dato
    var celda = CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0);
    sheet.updateCell(celda, nuevoDato);

    // Guardar el archivo Excel modificado
    var modified = excel.encode();
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(modified!);
  }
}
