import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/services/services.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final APIService _apiService;
  ProductBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

  @override
  ProductState get initialState => ProductInital();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is MyProductFetched) {
      yield* _mapNewsProductToState(event);
    } else if (event is MyStockFetched) {
      yield* _mapStockToState(event);
    } else if (event is ProductDetailFetched) {
      yield* _mapShowProductToState(event);
    }
  }

  Stream<ProductState> _mapStockToState(MyStockFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.fetchMyStock();
      if (result != null) {
        if (result.length > 0) {
          yield MyStockLoaded(productsList: result);
        } else {
          yield ProductNotLoaded();
        }
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapNewsProductToState(MyProductFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.fetchMyProducts();
      if (result != null) {
        if (result.length > 0) {
          yield MyProductLoaded(productsList: result);
        } else {
          yield ProductNotLoaded();
        }
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapShowProductToState(
      ProductDetailFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.showProduct(id: event.id);
      print("RESULT: " + result.toString());
      if (result != null) {
        print("yield");
        yield ProductLoaded(product: result);
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
