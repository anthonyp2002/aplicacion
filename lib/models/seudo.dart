/// Clase `SeudoModel` que representa un modelo seudo para un serio de palabras como "Seudopalabras"-"Sinonimos"-"Antonimos".
///
/// Cada instancia de `SeudoModel` tiene tres propiedades: un identificador (`id`), una palabra (`palabras`)
/// y un mapa de respuestas (`answer`).
class SeudoModel {
  int? id;
  String? palabras;
  Map<String, bool> answer;

  /// Crea una nueva instancia de `SeudoModel`.
  SeudoModel(this.id, this.palabras, this.answer);
}
