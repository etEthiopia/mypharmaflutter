class DashboardException implements Exception {
  final String message;

  DashboardException({this.message = 'Unknown error occurred. '});
}
