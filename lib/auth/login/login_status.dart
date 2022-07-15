abstract class LoginStatus {
  const LoginStatus();
}

class LoginInit extends LoginStatus {
  const LoginInit();
}

class LoginOnLoading extends LoginStatus {}

class LoginOnSuccess extends LoginStatus {}

class LoginOnFailed extends LoginStatus {
  final Exception exception;

  LoginOnFailed(this.exception);
}