import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/book_collection.dart';
import 'package:flutter_app/shared/components/bottom_navigator.dart';


class WithoutPendencyWidget extends StatefulWidget {
  const WithoutPendencyWidget({super.key});

  @override
  State<WithoutPendencyWidget> createState() => _WithoutPendencyWidgetState();
}

class _WithoutPendencyWidgetState extends State<WithoutPendencyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pendências',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Texto alinhado à esquerda
        backgroundColor: Colors.blue, // Azul padrão do Flutter
        elevation: 2, // Pequena sombra para destaque
      ),
      backgroundColor: const Color(0xFFFCFDFF), // Cor de fundo alterada
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Imagem central
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/no_content.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Texto "Usuário sem pendências"
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: const Text(
                'Usuário sem pendências',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Texto descritivo
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 15, 30, 0),
              child: const Text(
                'Parece que você está sem pendências. \nDê uma olhada no acervo da biblioteca e descubra novos livros, autores ou temas que podem te surpreender. Sempre há algo novo esperando por você!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // Botão
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: 270,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Redirecionamento para a página de acervo
                     Navigator.pushReplacement(
                      context,
                     MaterialPageRoute(builder: (context) => const BottomNavigator(userType: 'userSapi_1')), 
                    ); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2264E5), // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Explorar acervo',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
