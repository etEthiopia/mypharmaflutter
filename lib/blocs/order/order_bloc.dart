import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/services/services.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final APIService _apiService;
  OrderBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

  @override
  OrderState get initialState => OrderInital();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderReceivedFetched) {
      yield* _mapNewsFetchedToState(event);
    }
  }

  Stream<OrderState> _mapNewsFetchedToState(OrderReceivedFetched event) async* {
    yield OrderLoading();
    try {
      final result = await _apiService.fetchReceivedOrders();
      if (result != null) {
        if (result.length > 0) {
          yield OrderReceivedLoaded(receivedList: result);
        } else {
          yield OrderNotLoaded();
        }
      } else {
        yield OrderNotLoaded();
      }
    } catch (e) {
      yield OrderFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
