import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/news/bloc.dart';
import 'package:mypharma/services/news_service.dart';
import 'package:mypharma/services/services.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final AuthService _newsService;
  NewsBloc(AuthService newsService)
      : assert(NewsService != null),
        _newsService = newsService;

  @override
  NewsState get initialState => NewsInital();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsFetched) {
      yield* _mapNewsFetchedToState(event);
    }
  }

  Stream<NewsState> _mapNewsFetchedToState(NewsFetched event) async* {
    print(event);
    yield NewsLoading();
    try {
      final result = await _newsService.fetchNews(page: event.page);
      if (result != null) {
        if (result.length == 3) {
          yield NewsUpdated();
          print(result);
          yield NewsLoaded(result[0], result[1], result[2]);
        } else {
          yield NewsNotLoaded();
        }
      } else {
        yield NewsNotLoaded();
      }
    } catch (e) {
      print(e.toString());
      yield NewsFailure(error: e.toString() ?? 'An unknown error occurred');
    }
  }
}
