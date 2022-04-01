import 'dart:convert';
import 'package:http/http.dart' as http;

class MonumentModel {
  String price;

  MonumentModel({
    required this.price,
  });

  factory MonumentModel.fromMap(Map<String, dynamic> json) {
    return MonumentModel(
      price: json['price'],
    );
  }

}

List<MonumentModel> decodeMonument(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<MonumentModel>((json) => MonumentModel.fromMap(json))
      .toList();
}

Future<List<MonumentModel>> fetchMonument() async {
  final response = await http.get(
      'https://script.google.com/macros/s/AKfycbx9kO8lRb2UTMesbih4M4-EwlFxW7Zt58IMmHtFNGrG6bMF-eLlUCwvHuo9GdaAhPy-/exec');
  if (response.statusCode == 200) {
    return decodeMonument(response.body);
  } else {
    throw Exception('Unable to fetch data from the REST API');
  }
}