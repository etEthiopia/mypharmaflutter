import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/auth/auth_bloc.dart';
import 'package:mypharma/blocs/auth/auth_event.dart';
import 'package:mypharma/blocs/login/login_state.dart';
import 'package:mypharma/blocs/register/register_event.dart';
import 'package:mypharma/blocs/register/register_state.dart';

import 'package:mypharma/services/services.dart';
//import 'package:bloc_pattern_full/blocs/auth/auth_bloc.dart';
//import 'package:bloc_pattern_full/blocs/auth/Auth_event.dart';

import '../../exceptions/exceptions.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthBloc _authBloc;
  final AuthService _authService;

  RegisterBloc(AuthBloc authBloc, AuthService authService)
      : assert(AuthBloc != null),
        assert(AuthService != null),
        _authBloc = authBloc,
        _authService = authService;

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterPressed) {
      yield* _mapRegisterPressedToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterPressedToState(
      RegisterPressed event) async* {
    yield RegisterLoading();
    try {
      final user = await _authService.signUp(
          name: event.name,
          email: event.email,
          profession: event.profession,
          password: event.password);

      if (user != null) {
        _authBloc.add(UserRegistered(user: user));
        yield RegisterSuccess();
        yield RegisterInitial();
      } else {
        yield RegisterFailure(error: 'Sth very weird just happened');
      }
    } on AuthException catch (e) {
      yield RegisterFailure(error: e.message);
    } catch (err) {
      yield RegisterFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
