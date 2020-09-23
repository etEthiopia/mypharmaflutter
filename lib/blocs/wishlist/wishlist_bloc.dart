import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final APIService _apiService;
  WishlistBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

  @override
  WishlistState get initialState => WishlistInital();

  @override
  Stream<WishlistState> mapEventToState(WishlistEvent event) async* {
    if (event is WishlistFetched) {
      yield* _mapWishlistReceivedToState(event);
    } else if (event is WishlistAdd) {
      yield* _mapWishistAddToState(event);
    } else if (event is WishlistCount) {
      yield* _mapWishCountToState(event);
    } else if (event is WishlistDelete) {
      yield* _mapWishDeleteToState(event);
    }
  }

  Stream<WishlistState> _mapWishlistReceivedToState(
      WishlistEvent event) async* {
    yield WishlistLoading();
    try {
      final result = await _apiService.fetchWishlist();

      if (result != null) {
        if (result.length > 0) {
          yield WishlistLoaded(wishlist: result);
        } else {
          yield WishlistNotLoaded();
        }
      } else {
        yield WishlistNotLoaded();
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield WishlistNothingReceived();
      } else {
        yield WishlistFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<WishlistState> _mapWishDeleteToState(WishlistDelete event) async* {
    try {
      if (state is WishlistLoaded) {
        //yield WishlistLoading();
        final result = await _apiService.deleteWish(event.id);
        if (result) {
          final List<Wishlist> current = state.props[0];
          final updatedWishes =
              current.where((wish) => wish.id != event.id).toList();
          yield WishlistLoaded(wishlist: updatedWishes);
        }
      }
    } catch (e) {
      if (e.message.toString() == 'empty') {
        yield WishlistNothingReceived();
      } else {
        yield WishlistFailure(
            error: e.message.toString() ?? 'An unknown error occurred');
      }
    }
  }

  Stream<WishlistState> _mapWishistAddToState(WishlistAdd event) async* {
    try {
      final result = await _apiService.addtoWishList(
          name: event.newwish.name,
          postid: event.newwish.postId,
          slug: event.newwish.slug,
          vendorId: event.newwish.vendorId,
          quantity: event.newwish.quantity);
      if (result != null) {
        if (result == true) {
          int count = 0;
          if (state is WishlistLoaded) {
            final List<Wishlist> current = state.props[0];
            count = current.length + 1;
          } else if (state is WishlistCounted) {
            int prcount = state.props[0];
            count = prcount + 1;
          }
          yield WishlistAdded(count: count);
          yield WishlistCounted(count: count);
        } else {
          yield WishlistNotAdded();
        }
      } else {
        yield WishlistNotAdded();
      }
    } catch (e) {
      yield WishlistFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<WishlistState> _mapWishCountToState(WishlistCount event) async* {
    if (event.count != 0) {
      yield WishlistCounted(count: event.count);
    } else {
      yield WishlistLoading();
      try {
        final result = await _apiService.countWishList();
        if (result != null) {
          yield WishlistCounted(count: result);
        } else {
          yield WishlistNotLoaded();
        }
      } catch (e) {
        if (e.message.toString() == 'empty') {
          print("nothing");
          yield WishlistNothingReceived();
        } else {
          yield WishlistFailure(
              error: e.message.toString() ?? 'An unknown error occurred');
        }
      }
    }
  }
}
