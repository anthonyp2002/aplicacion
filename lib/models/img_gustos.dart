/// Clase `OptionsModel` que representa un modelo de opciones para  identificar nuestras imagenes.
///
/// Cada instancia de `OptionsModel` tiene tres propiedades: un identificador (`id`), una pregunta (`questions`)
/// y un mapa de respuestas (`answer`).
class ImgGustos {
  int? id;
  String? questions;
  Map<String, Map<String, bool>>? imag;

  /// Crea una nueva instancia de `OptionsModel`.
  ImgGustos(this.id, this.questions, this.imag);
}
