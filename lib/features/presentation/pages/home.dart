import 'dart:async'; // Para usar o Timer
import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/user.dart';
import 'package:flutter_app/features/domain/models/bookmodel.dart';  // Importando o modelo
import 'package:flutter_app/features/data/repositories/book_repository.dart';  // Importando o repositório

// Consumir a API

class HomeScreen extends StatefulWidget {
  //final BookModel book;
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controlador para o PageView
  late PageController _pageController;

  // Timer para mudar as páginas do carrossel automaticamente
  late Timer _timer;

  // Índice atual da página
  int _currentPage = 0;

  // Lista de livros recomendados
  late List<BookModel> _recommendedBooks;

  // Flag para indicar quando os dados estão carregando
  bool _isRecommending = true;  // Para mostrar o carregamento das recomendações

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Carregar os dados da API
    _recommendations();

    // Configurando o Timer para mudar de página a cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }


  // Função para carregar as recomendações de livros
  Future<void> _recommendations() async {
    try {
      final bookRepository = BookRepository();
      final recommendedBooks = await bookRepository.recommendation('flutter'); // querry
      setState(() {
        _recommendedBooks = recommendedBooks;  // Armazenando os dados na variável
        _isRecommending = false;  // Alterando o estado para indicar que as recomendações foram carregadas
      });
    } catch (e) {
      print("Erro ao carregar recomendações: $e");
      setState(() {
        _isRecommending = false;  // Alterando o estado mesmo que haja erro
      });
    }
  }

  @override
  void dispose() {
    // Cancelar o timer quando a tela for destruída
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0, // Remove a sombra da AppBar
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_scripta.png', // Caminho para a sua logo
              height: 25, // Tamanho da logo
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              print('Notificação pressionada!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel com bordas arredondadas na parte inferior
            Container(
              height: 220, // Altura do carrossel
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 33, 150, 243).withOpacity(0.4),
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: PageView(
                  controller: _pageController, // Passando o controlador para o PageView
                  children: [
                    _buildCarouselItem(
                      title: "Bem-vindo à sua Biblioteca Digital!",
                      subtitle:
                          "Explore, descubra e organize seu acervo de forma prática e intuitiva.",
                      icon: Icons.book,
                    ),
                    _buildCarouselItem(
                      title: "Descubra Novos Títulos",
                      subtitle:
                          "Encontre facilmente livros e artigos relevantes para você.",
                      icon: Icons.search,
                    ),
                    _buildCarouselItem(
                      title: "Sua Coleção, Suas Regras",
                      subtitle:
                          "Organize seu acervo da forma que preferir e sempre tenha o que precisa.",
                      icon: Icons.folder,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40), // Espaçamento entre o carrossel e a lista de blocos

            
            Padding(
              padding: EdgeInsets.zero,
              child: Text(
                'Recomendados',
                style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 108, 106, 106), 
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Seção de recomendações de livros
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: _isRecommending
                  ? Center(child: CircularProgressIndicator()) // Exibe um carregamento enquanto espera as recomendações
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recommendedBooks.length, // Número de recomendações
                      itemBuilder: (context, index) {
                        // Passa o livro recomendado para o método de construção do bloco
                        return _buildBlockItem(book: _recommendedBooks[index]);
                      },
                    ),
            ),

            // Espaçamento no final da lista de blocos
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Método para construir os itens do carrossel
  Widget _buildCarouselItem({required String title, required String subtitle, required IconData icon}) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                icon,
                size: 70,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir os blocos da lista com design clean
  Widget _buildBlockItem({required BookModel book}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12), // Mais espaçamento entre os blocos
      padding: const EdgeInsets.all(16), // Adicionando padding interno para dar espaçamento ao conteúdo
      decoration: BoxDecoration(
        color: Colors.white, // Cor de fundo branca
        borderRadius: BorderRadius.circular(10), // Bordas arredondadas
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Sombra suave
            blurRadius: 10,
            offset: Offset(0, 4), // Sombra para baixo
          ),
        ],
      ),
      child: Row(
        children: [
            Icon(
              Icons.book, 
              color: Colors.blue.shade600, // Ícone azul mais forte
              size: 50, 
            ),
          const SizedBox(width: 16),  // Espaçamento entre imagem e texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title, // Título do livro
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  book.author, // Autor do livro
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
