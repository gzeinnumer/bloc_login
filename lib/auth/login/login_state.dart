import 'package:bloc_login/auth/login/login_status.dart';

class LoginState {
  final String username;
  bool get isValidUsername => username.length > 3;

  final String password;
  bool get isValidPassword => password.length > 6;

  final LoginStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const LoginInit(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    LoginStatus? formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}