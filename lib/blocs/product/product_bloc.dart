import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/news/bloc.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final APIService _apiService;
  NewsBloc(APIService apiService)
      : assert(APIService != null),
        _apiService = apiService;

  @override
  NewsState get initialState => NewsInital();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsFetched) {
      yield* _mapNewsFetchedToState(event);
    }
  }

  Stream<NewsState> _mapNewsFetchedToState(NewsFetched event) async* {
    print("state length: " + state.props.length.toString());
    List<News> old = [];
    int current = 0;
    if (state.props.length == 3) {
      old = state.props[2];
      current = state.props[1];
    }
    yield NewsLoading();
    try {
      final result = await _apiService.fetchNews(page: event.page);
      if (result != null) {
        if (result.length == 3) {
          print(result[0].toString() + " " + result[1].toString());
          yield NewsLoaded(
              last: result[0], current: result[1], newsList: result[2]);
          // if (result[0] == result[1]) {}
        } else if (result.length == 2) {
          yield NewsAllLoaded();
        } else {
          yield NewsNotLoaded();
        }
      } else {
        yield NewsNotLoaded();
      }
    } catch (e) {
      yield NewsFailure(
          error: e.message.toString() ?? 'An unknown error occurred');
    }
  }
}
