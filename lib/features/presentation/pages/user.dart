import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/login.dart';  // Certifique-se de importar a tela de login ou qualquer outra tela para navegação

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3), // Cor azul claro
        title: const Text(
          'Usuário',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone de seta para voltar
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fundo com gradiente e curva
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),
          
          // Conteúdo da tela
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Seção de informações do aluno
                InfoCard(
                  title: 'Empréstimos Ativos',
                  value: 'x livros',
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Histórico de Empréstimos',
                  value: 'x livros',
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Total de Livros Emprestados',
                  value: 'x livros',
                ),
                // Espaço entre as seções
                const Spacer(), // Usado para empurrar os componentes para o topo
              ],
            ),
          ),
          // Botão centralizado na tela (mais para baixo)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top : 150), // Espaço abaixo do botão
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Função para logout, como exemplo
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,  // Remove todas as rotas anteriores
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Cor do fundo do botão
                      onPrimary: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 90), // Tamanho maior do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                      ),
                      shadowColor: Colors.blue.withOpacity(0.5), // Cor da sombra
                      elevation: 15, // Eleva mais o botão
                      side: BorderSide(color: Colors.white, width: 2), // Borda branca
                    ),
                    child: const Text(
                      'Sair',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 20, 
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
    );
  }
}

// Widget para as informações do aluno
class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para criar o efeito de ondas
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3) // Azul claro
      ..style = PaintingStyle.fill;

    // Desenhando a onda no fundo, mais para cima
    final path = Path()
      ..lineTo(0, 0)
      ..lineTo(0, size.height * 0.45) // Mover a onda mais para cima
      ..quadraticBezierTo(
        size.width * 0.25, size.height * 0.55, 
        size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.45,
        size.width, size.height * 0.5)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
