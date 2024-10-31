import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ayni_flutter_app/feature_profile/models/profile.dart';

class UserService {
  final String baseUrl = 'https://ayni-v1.sfo1.zeabur.app/api/v1';

  Future<Profile> getUserProfile() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      if (users.isNotEmpty) {
        return Profile.fromJson(users[1]); // Asumiendo que el usuario logeado es el primer elemento de la lista
      } else {
        throw Exception("No user data found");
      }
    } else {
      throw Exception("Failed to load user profile");
    }
  }
}