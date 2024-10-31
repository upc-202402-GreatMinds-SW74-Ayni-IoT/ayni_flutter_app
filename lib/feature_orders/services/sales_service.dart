import 'dart:convert';
import 'dart:io';
import 'package:ayni_flutter_app/feature_orders/models/sales.dart';
import 'package:ayni_flutter_app/feature_orders/models/sales_response.dart';
import 'package:http/http.dart' as http;

/// Servicio para gestionar operaciones relacionadas con ventas a través de la API.
class SalesService {
  /// URL base de la API para las ventas.
  final String baseUrl = "https://ayni-v1.sfo1.zeabur.app/api/v1/sales";

  /// Obtiene una lista de todas las ventas desde la API.
  ///
  /// Retorna una lista de objetos [Sales] si la solicitud es exitosa; de lo contrario, retorna una lista vacía.
  Future<List<Sales>> getAll() async {
    // Realiza una petición GET a la API para obtener todas las ventas
    http.Response response = await http.get(Uri.parse(baseUrl));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      // Convierte cada elemento en un objeto Sales y retorna la lista
      return jsonResponse.map((map) => Sales.fromJson(map)).toList();
    }
    // Retorna una lista vacía si la solicitud falla
    return [];
  }

  /// Obtiene una venta específica utilizando el [saleId] y el [orderId].
  ///
  /// Retorna un objeto [Sales] que coincida con el ID de venta y el ID de pedido, si se encuentra.
  Future<Sales> getSaleByOrderId(String saleId, String orderId) async {
    // Realiza una petición GET a la API con el ID de venta y de pedido
    http.Response response = await http.get(Uri.parse('$baseUrl?saleId=$saleId&orderId=$orderId'));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      // Convierte el JSON en un objeto Sales y lo retorna
      return jsonResponse.map((map) => Sales.fromJson(map)).toList();
    }
    return {} as Sales;
  }

  /// Obtiene una venta específica por su [saleId].
  ///
  /// Retorna un objeto [Sales] que coincida con el ID proporcionado.
  Future<Sales> getSaleById(String saleId) async {
    // Realiza una petición GET a la API con el ID de venta
    http.Response response = await http.get(Uri.parse('$baseUrl/$saleId'));

    // Verifica si la respuesta fue exitosa
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      // Convierte el JSON en un objeto Sales y lo retorna
      return Sales.fromJson(jsonResponse);
    }
    return {} as Sales;
  }

  /// Crea una nueva venta en la API.
  ///
  /// Toma un objeto [sale] de tipo [Sales] y lo envía en el cuerpo de la solicitud.
  /// Retorna un objeto [SalesResponse] si la creación es exitosa.
  Future<SalesResponse> post(Sales sale) async {
    // Realiza una petición POST a la API con el objeto sale como JSON en el cuerpo
    http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sale),
    );

    // Verifica si la venta fue creada con éxito
    if (response.statusCode == HttpStatus.created) {
      final jsonResponse = json.decode(response.body);
      return SalesResponse.fromJson(jsonResponse);
    }
    return {} as SalesResponse;
  }
}
