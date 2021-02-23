import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/auth/auth_bloc.dart';
import 'package:mypharma/blocs/auth/auth_event.dart';

import 'package:mypharma/services/services.dart';
//import 'package:bloc_pattern_full/blocs/auth/auth_bloc.dart';
//import 'package:bloc_pattern_full/blocs/auth/Auth_event.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../exceptions/exceptions.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _AuthBloc;
  final APIService _APIService;

  LoginBloc(AuthBloc AuthBloc, APIService APIService)
      : assert(AuthBloc != null),
        assert(APIService != null),
        _AuthBloc = AuthBloc,
        _APIService = APIService;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event) async* {
    yield LoginLoading();
    try {
      final user =
          await _APIService.signIn(event.email, event.password, event.remember);
      if (user != null) {
        // push new Auth event
        _AuthBloc.add(UserLoggedIn(user: user));
        yield LoginSuccess();
        //yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on AuthException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.toString() ?? 'An unknown error occured');
    }
  }
}
