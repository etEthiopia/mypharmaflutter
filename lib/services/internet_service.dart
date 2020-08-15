import 'dart:io';

abstract class InternetServiceSkel {
  Future<bool> checkConnection();
}

class InternetService extends InternetServiceSkel {
  @override
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
