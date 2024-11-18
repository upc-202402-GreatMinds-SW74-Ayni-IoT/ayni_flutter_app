import 'dart:convert';


import 'package:ayni_flutter_app/home_screens/models/sensor.dart';
import 'package:http/http.dart' as http;


class SensorService {

  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/sensors";

  Future<Sensor?> getSensorById(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Sensor.fromJson(data);
      } else {
        print("Error: Código de estado ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al obtener el sensor: $e");
      return null;
    }
  }
}
