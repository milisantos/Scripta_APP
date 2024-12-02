//import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/features/domain/models/userModel.dart';

class UserRepository {
  final String baseUrl = 'http://localhost:8080';

  // metodo de verificação do usuario
  Future<String> authenticate(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/usuarios/login'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: user.toJson(),
      );

      if (response.statusCode == 200) {
        return "Login bem-sucedido!";
      } else if (response.statusCode == 401) {
        return "Credenciais inválidas!";
      } else {
        return "Erro desconhecido: ${response.body}";
      }
    } catch (e) {
      return "Erro ao conectar com o servidor";
    }
  }
}
