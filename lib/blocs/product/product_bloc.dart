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
      yield* _mapNewsFetchedToState(event);
    }
  }

  Stream<ProductState> _mapNewsFetchedToState(MyProductFetched event) async* {
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
}
