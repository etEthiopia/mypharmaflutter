class WishlistException implements Exception {
  final String message;

  WishlistException({this.message = 'Unknown error occurred. '});
}
