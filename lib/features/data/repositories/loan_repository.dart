import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/features/domain/models/loanModel.dart';

class LoanRepository {
  final String baseUrl = "http://localhost:8080/api/emprestimos";

  static const String matricula = "0001242"; // Exemplo de matrícula do usuário

  Future<List<LoanModel>> fetchEmprestimosByMatricula() async {
    final response = await http.get(Uri.parse('$baseUrl/list/$matricula'));

    // Verifica se a resposta foi bem-sucedida
    if (response.statusCode == 200) {
      // Tenta decodificar a resposta corretamente
      try {
        // Garantir que o conteúdo é decodificado como UTF-8, para o caso do "ó" apenas o json nao resolveu
        final utf8DecodedResponse = utf8.decode(response.bodyBytes);

        // Agora, decodifica o JSON
        final List<dynamic> data = json.decode(utf8DecodedResponse); // Aqui a resposta é uma lista

        // Mapeamos cada item da lista para um LoanModel
        return data.map((emprestimoJson) => LoanModel.fromJson(emprestimoJson)).toList();
      } catch (e) {
        print('Erro ao decodificar a resposta JSON: $e');
        throw Exception('Erro ao processar os dados recebidos');
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      throw Exception('Falha ao carregar empréstimos');
    }
  }


Future<bool> renovarEmprestimo(int emprestimoID) async {
  try {
  final String url = "http://localhost:8080/api/emprestimos";
    final response = await http.put(
      Uri.parse('$url/$emprestimoID/renovar'),
    );

    if (response.statusCode == 200) {
      print('Empréstimo renovado com sucesso!');
      return true;
    } else {
      print('Falha ao renovar o empréstimo. Status: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erro ao renovar o empréstimo: $e');
    return false;
  }
}

}