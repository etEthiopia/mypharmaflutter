import 'package:bloc/bloc.dart';

import 'package:mypharma/services/services.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _AuthService;

  AuthBloc(AuthService AuthService)
      : assert(AuthService != null),
        _AuthService = AuthService;

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
      // await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
      final currentUser = await _AuthService.getCurrentUser();

      if (currentUser != null) {
        yield AuthAuthenticated(user: currentUser);
      } else {
        yield AuthNotAuthenticated();
      }
    } catch (e) {
      yield AuthFailure(message: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    yield AuthAuthenticated(user: event.user);
  }

  Stream<AuthState> _mapUserRegisteredToState(UserRegistered event) async* {
    yield Registered();
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _AuthService.signOut();
    yield AuthNotAuthenticated();
  }
}
