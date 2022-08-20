# bloc_login

- login_bloc.dart
```dart
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
```
- login_event.dart
```dart
abstract class LoginEvent {}

class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({required this.username});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {}
```
- login_state.dart
```dart
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
```
- login_status.dart
```dart
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
```
- auth_repository.dart
```dart
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
```
- login_view.dart
```dart
import 'package:bloc_login/auth/auth_repository.dart';
import 'package:bloc_login/auth/login/login_status.dart';
import 'package:bloc_login/auth/login/login_bloc.dart';
import 'package:bloc_login/auth/login/login_event.dart';
import 'package:bloc_login/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              authRepo: context.read<AuthRepository>(),
            ),
          )
        ],
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is LoginOnFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _passwordField(),
                _loginButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username is too short',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is LoginOnLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: const Text('Login'),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
```
- main.dart
```dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:bloc_login/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository())
        ],
        child: LoginView(),
      ),
    );
  }
}
```


---

```
Copyright 2022 M. Fadli Zein
```