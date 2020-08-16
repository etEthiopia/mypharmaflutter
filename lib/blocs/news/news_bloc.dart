import 'package:bloc/bloc.dart';
import 'package:mypharma/blocs/news/bloc.dart';
import 'package:mypharma/services/news_service.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService _newsService;
  NewsBloc(NewsService newsService)
      : assert(NewsService != null),
        _newsService = newsService;

  @override
  NewsState get initialState => NewsInital();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsFetched) {
      _mapNewsFetchedToState(event);
    }
  }

  Stream<NewsState> _mapNewsFetchedToState(NewsFetched event) async* {
    yield NewsLoading();
    try {
      final result = await _newsService.fetchNews(page: event.page);
      if (result != null) {
        if (result.length == 3) {
          yield NewsUpdated();
          yield NewsLoaded(result[0], result[1], result[2]);
        }
        yield NewsNotLoaded();
      }
      yield NewsNotLoaded();
    } catch (e) {
      yield NewsFailure(error: e.message ?? 'An unknown error occurred');
    }
  }
}
