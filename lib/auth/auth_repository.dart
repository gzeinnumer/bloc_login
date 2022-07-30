class AuthRepository {
  Future<void> login() async {
    // print('attempting login');
    await Future.delayed(const Duration(seconds: 3));
    // print('logged in');
    throw Exception('failed log in');
  }

  Future<bool> loginB() async {
    // print('attempting login');
    await Future.delayed(const Duration(seconds: 3));
    // print('logged in');
    // throw Exception('failed log in');
    return true;
  }
}