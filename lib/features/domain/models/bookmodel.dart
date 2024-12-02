class BookModel {
  final String id; // Identificador único do livro
  final String title; // Título do livro
  final String author; // autor/autores
  final List<String> categories; // Lista de categorias ou gêneros do livro
  final String description; // Descrição ou sinopse 
  final String language; // Idioma em que o livro está disponível
  final String publisher; // Nome da editora
  final double averageRating; // Classificação
  final int pageCount; // Número de páginas 
  final String? thumbnail; // URL da imagem de capa

  // Construtor com todos os campos 
  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.categories,
    required this.description,
    required this.language,
    required this.publisher,
    required this.averageRating,
    required this.pageCount,
    required this.thumbnail,
  });

  // Fábrica para criar instâncias a partir de um JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      
      id: json['id'] ?? 'ID não disponível',

      title: json['volumeInfo']['title'] ?? 'Título não disponível',

      // Processa a lista de autores, unindo-os em uma string ou definindo um valor padrão
      author: json['volumeInfo']['authors'] != null
          ? json['volumeInfo']['authors'].join(', ') // Junta os autores com ", " como separador
          : 'Autor não disponível',

      // Extrai as categorias, limitando a lista a no máximo 4 itens
      categories: json['volumeInfo']['categories'] != null
          ? List<String>.from(json['volumeInfo']['categories']).take(4).toList()
          : [],

      description: json['volumeInfo']['description'] ?? 'Descrição não disponível',

      language: json['volumeInfo']['language'] ?? 'não disponível',

    
      publisher: json['volumeInfo']['publisher'] ?? 'não disponível',

      // Converte a avaliação média em `double`, tratando possíveis valores nulos ou inválidos
      averageRating: (json['volumeInfo']['averageRating'] != null &&
              json['volumeInfo']['averageRating'] is num)
          ? (json['volumeInfo']['averageRating'] as num).toDouble()
          : 0.0,

      // Define o número de páginas com um valor padrão caso não esteja disponível
      pageCount: json['volumeInfo']['pageCount'] ?? 0,

      // Obtém o link da imagem de capa, se disponível
      thumbnail: json['volumeInfo']['imageLinks']?['medium'],
    );
  }

  // Método para converter a instância de `BookModel` de volta para JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title, 
      'author': author, 
      'categories': categories, 
      'description': description, 
      'language': language, 
      'publisher': publisher, 
      'averageRating': averageRating, 
      'pageCount': pageCount, 
    };
  }
}
