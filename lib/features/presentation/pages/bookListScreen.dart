import 'package:flutter/material.dart';
import 'package:flutter_app/features/domain/models/bookmodel.dart';
import 'package:flutter_app/features/data/repositories/book_repository.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final TextEditingController _controller = TextEditingController(); // o que o usuario digitar
  late Future<List<BookModel>> books; // lista q armazena a resposta da api

  void searchBooks(String query) { // função ativada quandoo usuario aperta a lupa
    setState(() {
      books = BookRepository().fetchBooks(query);
    });
  }

  @override
  void initState() {
    super.initState();
    books = Future.value([]);  // Inicializa com uma lista vazia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesquisa de Livros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite o termo de pesquisa',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchBooks(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<BookModel>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum livro encontrado.'));
                  } else {
                    final bookList = snapshot.data!;
                    return ListView.builder(
                      itemCount: bookList.length,
                      itemBuilder: (context, index) {
                         final book = bookList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          
                          
                          
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
