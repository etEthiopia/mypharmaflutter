import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/models/models.dart';
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
      yield* _mapOrderReceivedToState(event);
    } else if (event is OrderSentFetched) {
      yield* _mapOrderSentToState(event);
    }
  }

  Stream<OrderState> _mapOrderReceivedToState(
      OrderReceivedFetched event) async* {
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

  Stream<OrderState> _mapOrderSentToState(OrderSentFetched event) async* {
    List<Order> old = [];
    int current = 0;
    if (state.props.length == 3) {
      old = state.props[2];
      current = state.props[1];
    }
    yield OrderLoading();
    try {
      final result = await _apiService.fetchSentOrders(page: event.page);
      if (result != null) {
        if (result.length == 3) {
          yield OrderSentLoaded(
              last: result[0], current: result[1], sentList: result[2]);
        } else if (result.length == 2) {
          print("2");
          yield OrderAllLoaded();
        } else {
          yield OrderNotLoaded();
        }
      } else {
        yield OrderNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        print("nothing");
        yield OrderNothingSent();
      } else {
        yield OrderFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }
}
