import 'dart:convert'; // Necessário para decodificar JSON
import 'package:http/http.dart' as http; // Biblioteca para realizar requisições HTTP
import 'package:flutter_app/features/domain/models/bookmodel.dart'; 

class BookRepository {
  final String baseUrl = "https://www.googleapis.com/books/v1/volumes"; 

  // Método para buscar a lista de livros na API
  Future<List<BookModel>> fetchBooks(String query) async {
    // Construção da URL com o termo de busca e limite de resultados
    final response = await http.get(Uri.parse('$baseUrl?q=$query&maxResults=40'));

    if (response.statusCode == 200) {
      // Decodifica o JSON retornado pela API
      final data = jsonDecode(response.body);

      // Acessa a lista de livros com a propriedade 'items' ou retorna lista vazia caso não exista
      final List books = data['items'] ?? [];

      // Transforma cada item da lista JSON em um objeto BookModel
      // Aplica um filtro para incluir apenas livros no idioma português 
      return books
          .map((item) => BookModel.fromJson(item)) 
          .where((book) => book.language == 'pt') 
          .toList();
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }

  // Método para buscar informações de um livro específico
  Future<BookModel> getBookById(String bookId) async {
    // Requisição para obter detalhes de um livro pelo ID
    final response = await http.get(Uri.parse('$baseUrl/$bookId'));

    if (response.statusCode == 200) {
      // Decodifica o JSON retornado pela API e converte em BookModel
      final data = jsonDecode(response.body);
      return BookModel.fromJson(data);
    } else {
      // Lança exceção em caso de falha
      throw Exception('Falha ao carregar o livro');
    }
  }

  // Método para recomendar livros (retorna até 5 itens)
  Future<List<BookModel>> recommendation(String query) async {
    // Requisição com limite de resultados definido em 5
    final response = await http.get(Uri.parse('$baseUrl?q=$query&maxResults=5'));

    if (response.statusCode == 200) {
      // Decodifica o JSON e acessa a lista de itens ou retorna uma lista vazia
      final data = jsonDecode(response.body);
      final List books = data['items'] ?? [];

      // Mapeia os itens para BookModel e retorna a lista
      return books.map((item) => BookModel.fromJson(item)).toList();
    } else {
      // Lança exceção caso a requisição falhe
      throw Exception('Falha ao carregar livros');
    }
  }

  // Método para exibir a capa de um livro pelo ID
  Future<void> printBookThumbnail(String bookId) async {
    try {
      // Busca os detalhes do livro usando o método `getBookById`
      final book = await getBookById(bookId);

      // Exibe a URL da capa ou uma mensagem padrão caso esteja ausente
      print(book.thumbnail ?? 'Capa indisponível');
    } catch (e) {
      // Trata erros na requisição e exibe uma mensagem no console
      print('Erro: $e');
    }
  }
}
