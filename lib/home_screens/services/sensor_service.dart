import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ayni_flutter_app/home_screens/models/crops.dart';
import 'package:ayni_flutter_app/home_screens/models/sensor.dart';
import 'package:http/http.dart' as http;

/// Clase de servicio para la gestión de sensores a través de la API.
class SensorService {
  /// Base URL para la API de sensores.
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/sensors";

  /// Obtiene un sensor específico por su [id].
  ///
  /// Retorna un objeto [Crops] si el cultivo existe, o `null` si no se encuentra.
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
