Future<bool> checkUser(String user, String password) {
  if (user == 'foo@foo.com' && password == '123') {
    return Future.value(true);
  }
  return Future.value(false);
}
