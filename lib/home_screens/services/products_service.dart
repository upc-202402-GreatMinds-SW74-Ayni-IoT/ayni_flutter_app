import 'dart:convert';
import 'dart:io';

import 'package:ayni_flutter_app/home_screens/models/products.dart';
import 'package:http/http.dart' as http;

/// Clase de servicio para la obtención de productos a través de la API.
class ProductsService {
  /// Base URL para la API de productos.
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/products";

  /// Obtiene todos los productos de la API.
  ///
  /// Retorna una lista de objetos de tipo [Products]. Si la estructura de la
  /// respuesta no coincide con lo esperado, lanza una excepción.
  Future<List<Products>> getAll() async {
    // Realiza la petición GET a la URL base
    final http.Response response = await http.get(Uri.parse(baseUrl));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      // Decodifica el JSON de la respuesta
      final jsonResponse = json.decode(response.body);

      // Si el JSON contiene una clave "results", lo trata como un Map
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey("results")) {
        final List<dynamic> maps = jsonResponse["results"];
        // Convierte cada elemento de "results" en un objeto Products
        return maps.map((map) => Products.fromJson(map)).toList();
      }
      // Si el JSON es una lista, convierte cada elemento en un objeto Products
      else if (jsonResponse is List<dynamic>) {
        return jsonResponse.map((map) => Products.fromJson(map)).toList();
      } else {
        // Estructura inesperada en el JSON
        throw Exception('Unexpected JSON structure');
      }
    } else {
      // Lanza una excepción si la petición falla
      throw Exception('Failed to load products');
    }
  }

  /// Obtiene productos por nombre mediante un parámetro de búsqueda.
  ///
  /// Toma un [name] como parámetro y retorna una lista de productos que
  /// coinciden con el nombre proporcionado. Si la estructura de la respuesta
  /// no coincide con lo esperado, lanza una excepción.
  Future<List<Products>> getByName(String name) async {
    // Realiza la petición GET con el nombre como parámetro
    final http.Response response = await http.get(Uri.parse('$baseUrl?name="$name"'));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      // Decodifica el JSON de la respuesta
      final jsonResponse = json.decode(response.body);

      // Si el JSON contiene una clave "results", lo trata como un Map
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey("results")) {
        final List<dynamic> maps = jsonResponse["results"];
        // Convierte cada elemento de "results" en un objeto Products
        return maps.map((map) => Products.fromJson(map)).toList();
      }
      // Si el JSON es una lista, convierte cada elemento en un objeto Products
      else if (jsonResponse is List<dynamic>) {
        return jsonResponse.map((map) => Products.fromJson(map)).toList();
      } else {
        // Estructura inesperada en el JSON
        throw Exception('ProductService Unexpected JSON structure');
      }
    } else {
      // Lanza una excepción si la petición falla
      throw Exception('Failed to load products');
    }
  }
}
