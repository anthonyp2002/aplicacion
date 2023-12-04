/// Clase `User` que representa a un usuario.
///
/// Cada instancia de `User` tiene seis propiedades: nombre completo (`fullname`), correo electrónico (`gmail`),
/// teléfono (`phone`), edad (`age`), año lectivo (`anioLec`) y contraseña (`password`).
class User {
  final String fullname;
  final String gmail;
  final String phone;
  final String age;
  final String anioLec;
  final String password;

  /// Crea una nueva instancia de `User`.
  User(this.fullname, this.age, this.anioLec, this.gmail, this.password,
      this.phone);
}
