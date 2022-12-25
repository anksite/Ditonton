import 'package:http/http.dart' as http;

import 'custom_client.dart';

class Pinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await CustomClient.createLEClient();
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
