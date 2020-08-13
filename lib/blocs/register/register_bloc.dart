import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/auth/auth_bloc.dart';
import 'package:mypharma/blocs/auth/auth_event.dart';
import 'package:mypharma/blocs/register/register_event.dart';
import 'package:mypharma/blocs/register/register_state.dart';

import 'package:mypharma/services/services.dart';
//import 'package:bloc_pattern_full/blocs/auth/auth_bloc.dart';
//import 'package:bloc_pattern_full/blocs/auth/Auth_event.dart';

import '../../exceptions/exceptions.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthBloc _AuthBloc;
  final AuthService _AuthService;

  RegisterBloc(AuthBloc AuthBloc, AuthService AuthService)
      : assert(AuthBloc != null),
        assert(AuthService != null),
        _AuthBloc = AuthBloc,
        _AuthService = AuthService;

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
      print("ABOUT to fire method");
      final code = await _AuthService.signUp(
        name: event.name,
      );
      if (code == 201) {
        // push new Auth event
        _AuthBloc.add(UserRegistered());
        yield RegisterSuccess();
        yield RegisterInitial();
      } else {
        yield RegisterFailure(error: 'Something very weird just happened');
      }
    } on AuthException catch (e) {
      yield RegisterFailure(error: e.message);
    } catch (err) {
      yield RegisterFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
