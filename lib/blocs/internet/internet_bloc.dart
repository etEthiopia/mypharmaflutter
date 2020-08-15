import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/internet/Internet_state.dart';
import 'package:mypharma/blocs/internet/internet_event.dart';
import 'package:mypharma/services/internet_service.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  @override
  InternetState get initialState => throw UnimplementedError();

  final InternetService _internetService;

  InternetBloc(InternetService internetService)
      : assert(InternetService != null),
        _internetService = internetService;

  @override
  Stream<InternetState> mapEventToState(InternetEvent event) async* {
    if (event is CheckInternet) {
      yield* _mapCheckInternetToState(event);
    }
  }

  Stream<InternetState> _mapCheckInternetToState(InternetEvent event) async* {
    yield InternetChecking();
    try {
      final isConnected = await _internetService.checkConnection();
      if (isConnected) {
        yield Connected();
      } else {
        yield NotConnected();
      }
    } catch (e) {
      yield InternetFailure(error: e.message ?? 'An unknown error occurred');
    }
  }
}
