class ProductException implements Exception {
  final String message;

  ProductException({this.message = 'Unknown error occurred. '});
}
