import 'dart:convert';
import 'package:http/http.dart' as http;



Future<dynamic> getApi(url) async {
  http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    String jsonData = response.body;
    final parsingData = jsonDecode(jsonData);
    return parsingData;
  }
}

