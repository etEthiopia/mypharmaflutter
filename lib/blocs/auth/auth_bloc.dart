import 'package:bloc/bloc.dart';

import 'package:mypharma/services/services.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final APIService _apiService;

  AuthBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

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
      //await Future.delayed(Duration(milliseconds: 5000)); // a simulated delay
      final currentUser = await _apiService.getCurrentUser();

      if (currentUser != null) {
        APIService.token = currentUser.token;
        APIService.id = currentUser.id;
        yield AuthAuthenticated(user: currentUser);
      } else {
        yield AuthNotAuthenticated();
      }
    } catch (e) {
      yield AuthFailure(error: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    APIService.token = event.user.token;
    APIService.id = event.user.id;
    yield AuthAuthenticated(user: event.user);
  }

  Stream<AuthState> _mapUserRegisteredToState(UserRegistered event) async* {
    yield AuthAuthenticated(user: event.user);
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _apiService.signOut();
    APIService.token = null;
    APIService.id = null;
    yield AuthNotAuthenticated();
  }
}
