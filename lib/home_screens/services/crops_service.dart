import 'dart:convert';
import 'dart:io';

import 'package:ayni_flutter_app/home_screens/models/crops.dart';
import 'package:http/http.dart' as http;

/// Clase de servicio para la gestión de cultivos a través de la API.
class CropsService {
  /// Base URL para la API de cultivos.
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/crops";

  /// Obtiene una lista paginada de cultivos desde la API.
  ///
  /// Toma el número de página [page] como parámetro. Retorna una lista de 
  /// objetos [Crops]. Si la petición falla o no se encuentra información,
  /// retorna una lista vacía.
  Future<List<Crops>> getAll(int page) async {
    // Realiza la solicitud GET a la API con el número de página especificado.
    http.Response response = await http.get(Uri.parse("$baseUrl?page=$page"));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      // Decodifica el JSON de la respuesta
      final Map<String, dynamic> responseMap = json.decode(response.body);
      // Obtiene la lista de cultivos de la clave "results"
      List maps = responseMap["results"];
      // Convierte cada elemento de "results" en un objeto Crops
      return maps.map((map) => Crops.fromJson(map)).toList();
    }
    // Retorna una lista vacía si la petición falla
    return [];
  }

  /// Crea un nuevo cultivo en la API.
  ///
  /// Toma un [data] Map<String, dynamic> con la información del nuevo cultivo.
  /// Retorna `true` si el cultivo fue creado exitosamente (código 201), de lo
  /// contrario, retorna `false`.
  Future<bool> createCrop(Map<String, dynamic> data) async {
    // Realiza la solicitud POST con el cuerpo en formato JSON
    http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(data),
    );

    // Retorna true si la respuesta tiene el código de éxito 201 (creado)
    return response.statusCode == HttpStatus.created;
  }
}
