import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final APIService _apiService;
  CartBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

  @override
  CartState get initialState => CartInital();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is CartFetched) {
      yield* _mapCartReceivedToState(event);
    } else if (event is CartAdd) {
      yield* _mapCartistAddToState(event);
    } else if (event is CartCount) {
      yield* _mapCartCountToState(event);
    } else if (event is CartItemDelete) {
      yield* _mapCartDeleteToState(event);
    } else if (event is CartItemUpdate) {
      yield* _mapCartUpdateToState(event);
    }
  }

  Stream<CartState> _mapCartReceivedToState(CartEvent event) async* {
    yield CartLoading();
    try {
      final result = await _apiService.fetchCart();

      if (result != null) {
        if (result.length > 0) {
          yield CartLoaded(cartItems: result);
        } else {
          yield CartNotLoaded();
        }
      } else {
        yield CartNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield CartNothingReceived();
      } else {
        yield CartFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<CartState> _mapCartDeleteToState(CartItemDelete event) async* {
    try {
      if (state is CartLoaded) {
        final List<Cart> current = state.props[0];
        final updatedCarts = current
            .where((cartItem) => cartItem.id != event.cartItem.id)
            .toList();
        Cart.count -= 1;
        Cart.allTotal -= event.cartItem.price;
        yield CartLoaded(cartItems: updatedCarts);
        final result = await _apiService.deleteCartItem(event.cartItem.postId);

        if (result) {
        } else {
          Cart.count += 1;
          Cart.allTotal += event.cartItem.price;
          CartFailure(error: "Process Unsuccessful");
        }
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield CartNothingReceived();
      } else {
        yield CartFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<CartState> _mapCartUpdateToState(CartItemUpdate event) async* {
    try {
      if (state is CartLoaded) {
        final List<Cart> current = state.props[0];
        print(current);
        List<Cart> updated = current;
        for (Cart item in updated) {
          if (item.id == event.cartItem.id) {
            if (event.increase) {
              item.quantity += 1;
              item.price += event.cartItem.price / event.cartItem.quantity;
            } else {
              item.quantity -= 1;
              item.price -= event.cartItem.price / event.cartItem.quantity;
            }
          }
        }

        if (event.increase) {
          Cart.allTotal += event.cartItem.price / event.cartItem.quantity;
        } else {
          Cart.allTotal -= event.cartItem.price / event.cartItem.quantity;
        }
        print(current);
        final newupdated = updated;
        yield CartLoaded(cartItems: newupdated);

        final result = await _apiService.updateCartItem(
            event.cartItem.postId, event.increase);
        if (result) {
        } else {
          CartFailure(error: "Process Unsuccessful");
        }
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield CartNothingReceived();
      } else {
        yield CartFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<CartState> _mapCartistAddToState(CartAdd event) async* {
    try {
      final result = await _apiService.addToCart(
        postid: event.postid,
      );
      if (result != null) {
        if (result == true) {
          Cart.count += 1;

          yield CartAdded();
        } else {
          yield CartNotAdded();
        }
      } else {
        yield CartNotAdded();
      }
    } catch (e) {
      yield CartFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<CartState> _mapCartCountToState(CartCount event) async* {
    yield CartLoading();
    try {
      final result = await _apiService.countCartItems();
      if (result != null) {
        yield CartCounted();
      } else {
        yield CartNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield CartNothingReceived();
      } else {
        yield CartFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }
}
