import 'dart:async';

import 'package:app_flutter_formsvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  //final _emailController = StreamController<String>.broadcast();
  //final _passwordController = StreamController<String>.broadcast();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Get values Stream
  Stream<String> get emailStream => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);

  //Validate Button Login
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream, (a, p) => true);

  //Insert values Stream
  Function (String) get changeEmail => _emailController.sink.add;
  Function (String) get changePassword => _passwordController.sink.add;

  //Get last values Stream
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

}