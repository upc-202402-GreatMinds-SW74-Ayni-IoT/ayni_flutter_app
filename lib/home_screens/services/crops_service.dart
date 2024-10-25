import 'dart:convert';
import 'dart:io';

import 'package:ayni_flutter_app/home_screens/models/crops.dart';
import 'package:http/http.dart' as http;

class CropsService {
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/crops";

  Future<List> getAll(int page) async {
    http.Response response = await http.get(Uri.parse("$baseUrl?page=$page"));

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      List maps = responseMap["results"];
      return maps.map((map) => Crops.fromJson(map)).toList();
    }
    return [];
  }

  Future<bool> createCrop(Map<String, dynamic> data) async {
    http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(data),
    );

    return response.statusCode == HttpStatus.created;
  }
}
