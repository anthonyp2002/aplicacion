/// Clase `OptionsModel` que representa un modelo de opciones para  identificar nuestras imagenes.
///
/// Cada instancia de `OptionsModel` tiene tres propiedades: un identificador (`id`), una pregunta (`questions`)
/// y un mapa de respuestas (`answer`).
class OptionsModel {
  int? id;
  String? questions;
  Map<String, bool> answer;

  /// Crea una nueva instancia de `OptionsModel`.
  OptionsModel(this.id, this.questions, this.answer);
}
