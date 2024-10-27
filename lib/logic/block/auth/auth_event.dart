import 'package:hamad_corporation_task/data/model/user_model.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final UserModel user;
  RegisterEvent(this.user);
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent(this.username, this.password);
}
