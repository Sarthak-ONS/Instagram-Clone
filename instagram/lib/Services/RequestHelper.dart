import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getResponse(String url) async {
        String radarAPIKey = "prj_live_pk_529117bff084f8acd0544b6cbe3a5f8e50e8265b";
    try {
      http.Response response = await http.get(Uri.parse(url) , headers: {
        'Authorization': radarAPIKey
      });
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e.toString());
      return 'failed';
    }
  }
}
