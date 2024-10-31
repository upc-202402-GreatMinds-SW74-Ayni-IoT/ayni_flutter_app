import 'dart:convert';
import 'dart:io';
import 'package:ayni_flutter_app/feature_orders/models/orders.dart';
import 'package:http/http.dart' as http;

/// Servicio para gestionar las operaciones de pedidos (orders) a través de la API.
class OrdersService {
  /// URL base de la API para los pedidos.
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/orders";

  /// Obtiene una lista de todos los pedidos de la API.
  ///
  /// Retorna una lista de objetos [Orders] si la solicitud es exitosa; de lo contrario, retorna una lista vacía.
  Future<List<Orders>> getAll() async {
    // Realiza una petición GET a la API para obtener todos los pedidos
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      // Decodifica el JSON de la respuesta en una lista de mapas y convierte cada uno en un objeto Orders
      final jsonResponse = json.decode(response.body);
      return jsonResponse.map((map) => Orders.fromJson(map)).toList();
    } else {
      // Retorna una lista vacía si la solicitud falla
      return [];
    }
  }

  /// Obtiene pedidos que coincidan con una descripción específica.
  ///
  /// Toma un [description] opcional como parámetro para la búsqueda.
  /// Retorna una lista de objetos [Orders] que coincidan con la descripción proporcionada.
  Future<List<Orders>> getByDescription(String? description) async {
    // Realiza una petición GET a la API con la descripción como parámetro
    final response = await http.get(
      Uri.parse('$baseUrl?description="$description"'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      // Convierte cada elemento en un objeto Orders y retorna la lista
      return jsonResponse.map((map) => Orders.fromJson(map)).toList();
    } else {
      // Retorna una lista vacía si la solicitud falla
      return [];
    }
  }

  /// Crea un nuevo pedido en la API.
  ///
  /// Toma un objeto [order] de tipo [Orders] y lo envía en el cuerpo de la solicitud.
  /// Retorna el objeto [Orders] creado si la solicitud es exitosa.
  Future<Orders?> post(Orders order) async {
    // Realiza una petición POST a la API con el pedido como JSON en el cuerpo
    http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order),
    );

    // Verifica si el pedido fue creado con éxito
    if (response.statusCode == HttpStatus.created) {
      final jsonResponse = json.decode(response.body);
      return Orders.fromJson(jsonResponse);
    }
    return null;
  }

  /// Elimina un pedido existente de la API usando su [id].
  ///
  /// Lanza una excepción si la eliminación falla.
  Future<void> delete(int? id) async {
    // Realiza una petición DELETE a la API con el ID del pedido
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Verifica si el pedido fue eliminado con éxito
    if (response.statusCode != HttpStatus.noContent) {
      throw Exception('Failed to delete');
    }
  }

  /// Finaliza un pedido específico en la API usando su [orderId].
  ///
  /// Retorna un mensaje de confirmación si la finalización es exitosa.
  Future<String> finalizeOrder(int? orderId) async {
    // Realiza una petición POST para finalizar el pedido
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/$orderId/finalizations'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Verifica si la finalización fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      return "Successfully Added";
    } else {
      return '';
    }
  }
}