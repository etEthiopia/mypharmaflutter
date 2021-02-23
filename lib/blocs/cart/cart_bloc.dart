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
    } else if (event is CartAddBatch) {
      yield* _mapCartistAddBatchToState(event);
    } else if (event is CartCount) {
      yield* _mapCartCountToState(event);
    } else if (event is CartItemDelete) {
      yield* _mapCartDeleteToState(event);
    } else if (event is CartItemUpdate) {
      yield* _mapCartUpdateToState(event);
    } else if (event is CartCheckout) {
      yield* _mapCartCheckoutToState(event);
    } else if (event is CartOrder) {
      yield* _mapCartOrderToState(event);
    }
  }

  Stream<CartState> _mapCartReceivedToState(CartEvent event) async* {
    yield CartLoading();
    try {
      final result = await _apiService.fetchCart();
      print("CART: " + result.toString());

      if (result != null) {
        if (result.length > 0) {
          yield CartLoaded(cartItems: result);
        } else {
          yield CartNothingReceived();
        }
      } else {
        yield CartNothingReceived();
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
      final List<Cart> current = state.props[0];
      final updatedCarts = current
          .where((cartItem) => cartItem.id != event.cartItem.id)
          .toList();

      Cart.count -= 1;
      Cart.allTotal -= event.cartItem.price;
      yield CartUpdated(cartItems: updatedCarts);
      final result = await _apiService.deleteCartItem(event.cartItem.postId);

      if (result) {
      } else {
        Cart.count += 1;
        Cart.allTotal += event.cartItem.price;
        CartFailure(error: "Process Unsuccessful");
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
      yield CartUpdated(cartItems: newupdated);

      final result = await _apiService.updateCartItem(
          event.cartItem.postId, event.increase);
      if (result) {
      } else {
        CartFailure(error: "Process Unsuccessful");
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
          try {
            Cart.count = await _apiService.countCartItems();
          } catch (e) {
            print(e.message);
          }

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

  Stream<CartState> _mapCartistAddBatchToState(CartAddBatch event) async* {
    List<bool> result = [];
    try {
      for (int pd in event.postids) {
        print("cart batch id: " + pd.toString());
        bool k = await _apiService.addToCart(
          postid: pd,
        );
        result.add(k);
      }
      print("Cart Count before batch add ${Cart.count}");
      if (result != null) {
        if (result.length > 0) {
          try {
            Cart.count = await _apiService.countCartItems();
            print("Cart Count after batch add ${Cart.count}");
          } catch (e) {
            print(e.message);
          }

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
        Cart.count = result;
        print(" CART COUNT ${Cart.count}");
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

  Stream<CartState> _mapCartCheckoutToState(CartCheckout event) async* {
    yield CartLoading();
    try {
      final result = await _apiService.toCheckOut();

      if (result != null) {
        yield CartOnCheckout(address: result);
      } else {
        yield CartFailure(error: 'An unknown error occurred');
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

  Stream<CartState> _mapCartOrderToState(CartOrder event) async* {
    yield CartLoading();
    try {
      final result = await _apiService.order(
          addressChange: event.addressChange,
          address: event.address,
          note: event.note,
          landmark: event.landmark,
          city: event.city,
          phone: event.phone,
          payment: event.payment);

      if (result != null) {
        if (result == true) {
          yield CartDoneCheckout();
        } else {
          yield CartFailure(error: 'An unknown error occurred');
        }
      } else {
        yield CartFailure(error: 'An unknown error occurred');
      }
    } catch (e) {
      yield CartFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
