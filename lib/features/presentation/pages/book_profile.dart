import 'package:flutter/material.dart';

class BookProfileWidget extends StatefulWidget {
  final String title;
  final String author;
  final List<String> categories;
  final String description;
  final String? thumbnail; // Link para a capa do livro
  final String language; // Idioma
  final String publisher; // Editora
  final int pageCount; // Número de páginas
  final double averageRating; // Avaliação

  const BookProfileWidget({
    required this.title,
    required this.author,
    required this.categories,
    required this.description,
    this.thumbnail,
    required this.language,
    required this.publisher,
    required this.pageCount,
    required this.averageRating,
    Key? key,
  }) : super(key: key);

  @override
  State<BookProfileWidget> createState() => _BookProfileWidgetState();
}

class _BookProfileWidgetState extends State<BookProfileWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do livro
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                image: widget.thumbnail != null
                    ? DecorationImage(
                        image: NetworkImage(widget.thumbnail!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.thumbnail == null
                  ? const Center(
                      child: Icon(Icons.book, size: 100, color: Colors.grey),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            // Título e autor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Autor: ${widget.author}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Classificação com estrelas
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < widget.averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Linha divisória
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),
            // Informações adicionais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.language, 'Idioma', widget.language),
                  const SizedBox(height: 10),
                  _infoRow(Icons.account_balance, 'Editora', widget.publisher),
                  const SizedBox(height: 10),
                  _infoRow(Icons.menu_book, 'Páginas', widget.pageCount.toString()),
                  const SizedBox(height: 10),
                  _infoRow(Icons.star, 'Avaliação', widget.averageRating.toStringAsFixed(1)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // // Subtítulo "Categorias"
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     'Categorias',
            //     style: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            // Categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.start,
                children: widget.categories
                    .map((category) => Chip(
                          label: Text(category),
                          backgroundColor: Colors.lightBlueAccent,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Subtítulo "Descrição"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Descrição',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Descrição com "ler mais/ler menos"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isExpanded
                          ? widget.description
                          : widget.description.length > 200
                              ? '${widget.description.substring(0, 200)}...'
                              : widget.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (widget.description.length > 200)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? "Ler menos" : "Ler mais",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para criar linhas de informações
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
