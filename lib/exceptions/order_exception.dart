class OrderException implements Exception {
  final String message;

  OrderException({this.message = 'Unknown error occurred. '});
}
