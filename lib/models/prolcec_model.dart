/// Clase `OptionsText` que representa un texto con opciones que nos ayuda para nuestros cuentos.
///
/// Cada instancia de `OptionsText` tiene cinco propiedades: un identificador (`id`), un título (`titulo`),
/// un texto (`text`), una lista de preguntas (`questions`) y una lista de respuestas (`answer`).
class OptionsText {
  int? id;
  String? titulo;
  String? text;
  List<String> questions;
  List<String> answer;

  /// Crea una nueva instancia de `OptionsText`.
  ///
  /// Todos los parámetros son opcionales y pueden ser `null`.
  OptionsText(this.id, this.titulo, this.text, this.questions, this.answer);
}
