/// Clase `Dog` que representa a un perro.
///
/// Cada instancia de `Dog` tiene tres propiedades booleanas que indican si se ha tocado la nariz, la cola o la señal del perro.
class Dog {
  /// Indica si se ha tocado la nariz del perro.
  bool noseTouched;

  /// Indica si se ha tocado la cola del perro.
  bool tailTouched;

  /// Indica si se ha tocado el cuerpo del perro.
  bool cueTouched;

  /// Crea una nueva instancia de `Dog`.
  ///
  /// Todos los parámetros son opcionales y por defecto son `false`.
  Dog(
      {this.noseTouched = false,
      this.tailTouched = false,
      this.cueTouched = false});
}
