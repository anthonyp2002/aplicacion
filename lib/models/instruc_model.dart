/// Clase `InsModel` que representa un modelo de instrucción.
///
/// Cada instancia de `InsModel` tiene dos propiedades: un identificador (`id`) y un texto (`text`).
class InsModel {
  /// El identificador de la instrucción. Puede ser `null`.
  int? id;

  /// El texto de la instrucción. Puede ser `null`.
  String? text;

  /// Crea una nueva instancia de `InsModel`.
  ///
  /// Ambos parámetros son opcionales y pueden ser `null`.
  InsModel(this.id, this.text);
}
