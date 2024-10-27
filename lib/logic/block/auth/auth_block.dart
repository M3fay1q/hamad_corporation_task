import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamad_corporation_task/logic/block/auth/auth_event.dart';
import 'package:hamad_corporation_task/logic/block/auth/auth_state.dart';
import '../../../data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      try {
        await authRepository.registerUser(event.user);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure("Registration Failed"));
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        final isLoggedIn =
            await authRepository.loginUser(event.username, event.password);
        if (isLoggedIn) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Invalid credentials"));
        }
      } catch (e) {
        emit(AuthFailure("Login Failed"));
      }
    });
  }
}
