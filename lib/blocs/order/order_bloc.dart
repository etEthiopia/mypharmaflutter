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
  //OrderStatusChangeOrdered

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderReceivedFetched) {
      yield* _mapOrderReceivedToState(event);
    } else if (event is OrderSentFetched) {
      yield* _mapOrderSentToState(event);
    } else if (event is OrderShowReceived) {
      yield* _mapOrderShowRecToState(event);
    } else if (event is OrderStatusChangeOrdered) {
      yield* _mapOrderChangeStatusToState(event);
    } else if (event is DashboardFetched) {
      yield* _mapDashboardChangeToState(event);
    }
  }

  Stream<OrderState> _mapOrderReceivedToState(
      OrderReceivedFetched event) async* {
    List<Order> old = [];
    int current = 0;
    if (state.props.length == 3) {
      old = state.props[2];
      current = state.props[1];
    }
    print("RECEIVED PAGE: ${event.page}");
    yield OrderLoading();
    try {
      final result = await _apiService.fetchReceivedOrders(page: event.page);
      if (result != null) {
        if (result.length == 3) {
          yield OrderReceivedLoaded(
              last: result[0], current: result[1], receivedList: result[2]);
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
          yield OrderAllLoaded();
        } else {
          yield OrderNotLoaded();
        }
      } else {
        yield OrderNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield OrderNothingSent();
      } else {
        yield OrderFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<OrderState> _mapOrderShowRecToState(OrderShowReceived event) async* {
    yield OrderLoading();
    try {
      final result = await _apiService.fetchShowReceivedOrder(
          postid: event.postid, id: event.id);
      print("Result " + result.toString());
      if (result != null) {
        yield OrderRShow(receivedOrder: result);
      } else {
        yield OrderNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        print("nothing");
        yield OrderNothingReceived();
      } else {
        yield OrderFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<OrderState> _mapOrderChangeStatusToState(
      OrderStatusChangeOrdered event) async* {
    //yield OrderLoading();
    try {
      final result = await _apiService.updateOrderStatus(
          status: event.status, id: event.id);
      print("Result " + result.toString());
      if (result != null) {
        if (result != true) {
          yield OrderStatusNotChanged();
        }
      } else {
        yield OrderStatusNotChanged();
      }
    } catch (e) {
      yield OrderFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<OrderState> _mapDashboardChangeToState(DashboardFetched event) async* {
    yield OrderLoading();
    try {
      final result = await _apiService.showDashboard();
      if (result != null) {
        yield DashboardLoaded();
      } else {
        yield OrderFailure(error: 'Dashboard is Empty');
      }
    } catch (e) {
      yield OrderFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
