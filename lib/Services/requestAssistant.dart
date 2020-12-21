import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response _response = await http.get(url);

    try {
      if (_response.statusCode == 200) {
        String jsonData = _response.body;
        var decodedData = jsonDecode(jsonData);
        return decodedData;
      } else
        return "Failed";
    } catch (e) {
      return "Failed";
    }
  }
}
