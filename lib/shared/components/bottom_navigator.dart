import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/home.dart';
import 'package:flutter_app/features/presentation/pages/bookLoan.dart';
import 'package:flutter_app/features/presentation/pages/ bookListScreen.dart';
import 'package:flutter_app/features/presentation/pages/pendency.dart';
import 'package:flutter_app/features/presentation/pages/without_pendency.dart';
import 'package:flutter_app/features/presentation/pages/book_collection.dart';
import 'package:flutter_app/features/presentation/pages/underConstructionScreen.dart';

class BottomNavigator extends StatefulWidget {
  final String userType; // Parâmetro para definir o tipo de usuário

  const BottomNavigator({super.key, required this.userType});  // recebe o tipo de usuário

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // propriedade q define as páginas disponíveis com base no tipo de usuário
    _pages = _getPagesBasedOnUserType(widget.userType);
  }

  // Função para retornar as páginas com base no tipo de usuário
  List<Widget> _getPagesBasedOnUserType(String userType) {
    if (userType == 'userApi') {
      return [
        const HomeScreen(),
        SearchScreen(),
        const BookLoanScreen(),
        const PendencyWidget(),
      ];
    } else if (userType == 'userSapi_1') { // usuário sem empréstimos e sem pendências
      return [
        const HomeScreen(),
        SearchScreen(),
        const BookLoanScreen(),
        const WithoutPendencyWidget(),
      ];
    } else if (userType == 'userSapi_2') { // usuário sem empréstimos e COM pendências
      return [
        const HomeScreen(),
        SearchScreen(),
        const BookLoanScreen(),
        const PendencyWidget(),
      ];
    } else {
      return [
        const HomeScreen(),
        BookListScreen(),
        const BookLoanScreen(),
        const PendencyWidget(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Página selecionada
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[_selectedIndex],
          ),
          // Bottom Navigation Bar flutuante
          Positioned(
            left: 15,
            right: 15,
            bottom: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // Borda arredondada
              child: Container(
                child: BottomNavigationBar(
                  backgroundColor: Colors.blue, // Cor de fundo do BottomNavigationBar
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.white), // Ícone de Home
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search, color: Colors.white), // Ícone de Pesquisa
                      label: 'Pesquisa',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book, color: Colors.white), // Ícone de Acervo (livro)
                      label: 'Empréstimos',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.warning, color: Colors.white), // Ícone de Pendências (aviso)
                      label: 'Pendências',
                    ),
                  ],
                  currentIndex: _selectedIndex, // Índice da página selecionada
                  selectedItemColor: Colors.white, // Cor do ícone selecionado
                  unselectedItemColor: Color.fromARGB(170, 255, 255, 255), // Cor dos ícones não selecionados
                  showUnselectedLabels: true, // Mostrar rótulos dos ícones não selecionados
                  onTap: _onItemTapped, // Função de troca de página ao clicar no item
                  type: BottomNavigationBarType.fixed, // Tipo do BottomNavigationBar
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
