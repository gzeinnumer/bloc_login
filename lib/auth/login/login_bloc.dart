import 'package:bloc_login/auth/auth_repository.dart';
import 'package:bloc_login/auth/login/login_status.dart';
import 'package:bloc_login/auth/login/login_event.dart';
import 'package:bloc_login/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: LoginOnLoading());

      try {
        // await akan menggung dulu
        // Detik 1 - 2
        await authRepo.login(); // Detik 3
        //Detik 4

        bool res = await authRepo.loginB();
        //res if true
        //action
        //res else false
        //action

        yield state.copyWith(formStatus: LoginOnSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: LoginOnFailed(e));
      }
    }
  }
}