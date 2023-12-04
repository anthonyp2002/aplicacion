/// Clase `OrtModel` que representa un modelo de ortografía para una serie de palabras.
///
/// Cada instancia de `OrtModel` tiene dos propiedades: un identificador (`id`) y un mapa de respuestas (`answer`).
class OrtModel {
  /// El identificador del modelo. Puede ser `null`.
  int? id;

  /// El mapa de respuestas. Las claves son cadenas de texto y los valores son booleanos.
  Map<String, bool> answer;

  /// Crea una nueva instancia de `OrtModel`.
  ///
  /// Ambos parámetros son opcionales y pueden ser `null`.
  OrtModel(this.id, this.answer);
}
