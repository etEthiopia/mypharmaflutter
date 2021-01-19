import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/models/models.dart';
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
    } else if (event is ProductSearched) {
      yield* _mapSearchToState(event);
    } else if (event is ProductGetReady) {
      yield* _mapSearchReadyToState(event);
    } else if (event is MedsInfoFetched) {
      yield* _mapMedsFetchedToState(event);
    } else if (event is MedInfoDetailFetched) {
      yield* _mapShowMedToState(event);
    } else if (event is VendorFetched) {
      yield* _mapShowVendorToState(event);
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
      if (result != null) {
        yield ProductLoaded(product: result);
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapSearchToState(ProductSearched event) async* {
    yield ProductSearchLoading();
    try {
      var result;
      if (event.text == null) {
        //print("Cat: " + event.id.toString());
        result = await _apiService.searchProductsByCat(event.id);
      } else {
        result = await _apiService.searchProducts(event.text);
      }
      if (result != null) {
        if (result.length > 0) {
          yield ProductSearchLoaded(productsList: result);
        } else {
          yield ProductSearchEmpty();
        }
      } else {
        yield ProductSearchEmpty();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapSearchReadyToState(ProductGetReady event) async* {
    yield ProductLoading();
    if (Category.categories.length == 0) {
      try {
        final result = await _apiService.fetchCategories();
        if (result != null) {
          Category.categories = result;
          Category.generateCategoryDropdowns();
        }
        yield ProductSearchReady();
      } catch (e) {
        yield ProductSearchReady();
        // yield ProductFailure(
        //     error: e.message.toString() ?? 'An unknown error occurred');
      }
    } else {
      yield ProductSearchReady();
    }
  }

  Stream<ProductState> _mapMedsFetchedToState(MedsInfoFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.fetchMedsInfo();
      if (result != null) {
        yield MedsInfoLoaded(medsList: result);
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapShowMedToState(MedInfoDetailFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.showMedInfo(id: event.id);
      if (result != null) {
        yield MedLoaded(product: result);
      } else {
        yield ProductNotLoaded();
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }

  Stream<ProductState> _mapShowVendorToState(VendorFetched event) async* {
    yield ProductLoading();
    try {
      final result = await _apiService.showVendor(id: event.id);

      if (result != null) {
        print("VENDOR RESULT: $result");
        yield VendorLoaded(vendor: result);
      } else {
        yield ProductFailure(error: 'Could not get Vendo Info');
      }
    } catch (e) {
      yield ProductFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
