class CartException implements Exception {
  final String message;

  CartException({this.message = 'Unknown error occurred. '});
}
