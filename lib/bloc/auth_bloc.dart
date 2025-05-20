import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  AuthBloc(this.sharedPreferences) : super(AuthInitialState()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Get stored credentials from SharedPreferences
      final storedEmail = sharedPreferences.getString('email');
      final storedPassword = sharedPreferences.getString('password');
      final storedName = sharedPreferences.getString('name');

      // Check if credentials match what's stored
      if (storedEmail == event.email && storedPassword == event.password) {
        // Set login status
        await sharedPreferences.setBool('isLoggedIn', true);

        emit(AuthenticatedState(
          email: event.email,
          name: storedName ?? 'User',
        ));
      } else {
        // Also allow test account for development purposes
        if (event.email == 'test@example.com' && event.password == 'password123') {
          await sharedPreferences.setBool('isLoggedIn', true);
          await sharedPreferences.setString('email', event.email);
          await sharedPreferences.setString('name', 'Test User');

          emit(AuthenticatedState(
            email: event.email,
            name: 'Test User',
          ));
        } else {
          emit(AuthErrorState(message: 'Invalid credentials'));
        }
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Login failed: $e'));
    }
  }

  void _onSignupEvent(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Store user credentials in SharedPreferences
      await sharedPreferences.setBool('isLoggedIn', true);
      await sharedPreferences.setString('email', event.email);
      await sharedPreferences.setString('password', event.password); // Store password
      await sharedPreferences.setString('name', event.name);

      emit(AuthenticatedState(
        email: event.email,
        name: event.name,
      ));
    } catch (e) {
      emit(AuthErrorState(message: 'Signup failed: $e'));
    }
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await sharedPreferences.setBool('isLoggedIn', false);
      // Note: We're not removing credentials to allow login after logout

      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: 'Logout failed: $e'));
    }
  }

  void _onCheckAuthStatusEvent(CheckAuthStatusEvent event, Emitter<AuthState> emit) {
    final isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final email = sharedPreferences.getString('email') ?? '';
      final name = sharedPreferences.getString('name') ?? '';

      emit(AuthenticatedState(
        email: email,
        name: name,
      ));
    } else {
      emit(UnauthenticatedState());
    }
  }
}