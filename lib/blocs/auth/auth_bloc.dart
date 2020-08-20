import 'package:bloc/bloc.dart';

import 'package:mypharma/services/services.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(AuthService authService)
      : assert(AuthService != null),
        _authService = authService;

  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserRegistered) {
      yield* _mapUserRegisteredToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthLoading(); // to display splash screen
    try {
      await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
      final currentUser = await _authService.getCurrentUser();

      if (currentUser != null) {
        yield AuthAuthenticated(user: currentUser);
      } else {
        yield AuthNotAuthenticated();
      }
    } catch (e) {
      yield AuthFailure(error: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    print("user: ${event.user.name}");
    yield AuthAuthenticated(user: event.user);
  }

  Stream<AuthState> _mapUserRegisteredToState(UserRegistered event) async* {
    print("user: ${event.user.name}");
    yield AuthAuthenticated(user: event.user);
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _authService.signOut();
    yield AuthNotAuthenticated();
  }
}
