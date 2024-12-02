import 'package:flutter/material.dart';
import 'package:flutter_app/features/domain/models/bookmodel.dart';
import 'package:flutter_app/features/data/repositories/book_repository.dart';
import 'package:flutter_app/features/presentation/pages/book_profile.dart';

// Tela principal de busca de livros
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController(); // Controlador para capturar o texto de busca
  List<BookModel> _allBooks = []; // Lista completa de livros carregados
  List<BookModel> _filteredBooks = []; // Lista de livros filtrados pela busca
  bool _isLoading = true; // Estado para mostrar o carregamento inicial
  bool _noResultsFound = false; // Indica se nenhum resultado foi encontrado

  @override
  void initState() {
    super.initState();
    _loadBooks(); // Carrega os livros no início
    _searchController.addListener(_filterBooks); // Adiciona listener para busca
  }

  @override
  void dispose() {
    _searchController.dispose(); // Libera o controlador ao sair da tela
    super.dispose();
  }

  // Função para carregar os livros da API
  Future<void> _loadBooks() async {
    try {
      final books = await BookRepository().fetchBooks("a"); // Chamada para buscar os livros (exemplo com termo "a")

      // Filtra os livros no idioma português
      final filteredBooks = books.where((book) => book.language.toLowerCase() == 'pt').toList();

      setState(() {
        _allBooks = filteredBooks; // Atualiza lista completa
        _filteredBooks = filteredBooks; // Inicializa a lista filtrada como todos os livros
        _isLoading = false; // Conclui o carregamento
      });
    } catch (error) {
      // Trata erros e notifica o usuário
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar livros: $error')),
      );
    }
  }


  // Filtra os livros com base no texto de busca
  void _filterBooks() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      // Caso o campo de busca esteja vazio, exibe todos os livros
      setState(() {
        _filteredBooks = _allBooks;
        _noResultsFound = false;
      });
    } else {
      // Filtra os livros pelo título ou autor
      final filtered = _allBooks.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList();

      setState(() {
        _filteredBooks = filtered;
        _noResultsFound = filtered.isEmpty; // Define se há ou não resultados
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Define a cor da barra superior
        title: const Text('Buscar Livro'), // Título do app
      ),
      body: Column(
        children: [
          // Campo de entrada de texto para busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController, // Vinculado ao controlador
              decoration: InputDecoration(
                hintText: 'Digite o título ou autor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                ),
              ),
            ),
          ),
          if (!_isLoading && !_noResultsFound)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Acervo de livros', // Texto para contexto dos resultados
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // Mostra loading enquanto carrega os dados
                : _noResultsFound
                    ? const Center(
                        child: Text(
                          'Nenhum resultado encontrado.', // Mensagem de busca vazia
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredBooks.length, // Quantidade de itens na lista filtrada
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Design do card
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: Icon(
                                Icons.book, // Ícone representando livro
                                color: Colors.blue,
                                size: 40,
                              ),
                              title: Text(
                                book.title, // Título do livro
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(book.author), // Autor do livro
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                // Navegação para a página de perfil do livro
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookProfileWidget(
                                      title: book.title,
                                      author: book.author,
                                      categories: book.categories,
                                      description: book.description,
                                      thumbnail: book.thumbnail,
                                      language: book.language,
                                      publisher: book.publisher,
                                      pageCount: book.pageCount,
                                      averageRating: book.averageRating,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
