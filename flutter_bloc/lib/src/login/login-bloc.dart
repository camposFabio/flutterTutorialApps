import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'login-validators.dart';

class LoginBloc extends BlocBase with Validator implements Object {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recebe dados do fluxo
  Stream<String> get emailStream => _emailController.stream.transform(performEmailValidation); //Retorna o fluxo que transformamos
  Stream<String> get passwordStream => _passwordController.stream.transform(performPasswordValidation); //Retorna o fluxo que transformamos

  // Combinando os fluxos de email e senha
  Stream<bool> get submitValid =>
    Observable.combineLatest2(emailStream, passwordStream, (e,p) => true);

  // Add dados ao fluxo
  Function(String) get updateEmail => _emailController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;


  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

}