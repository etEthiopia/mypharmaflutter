class NewsException implements Exception {
  final String message;

  NewsException({this.message = 'Unknown error occurred. '});
}
