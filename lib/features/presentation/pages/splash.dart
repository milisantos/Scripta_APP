import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Após 5 segundos, navega para a tela de login
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ); // se for mudar pra o login sem api lembrar de alterar tbm la na pagina do usuario na opção de sair
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,  // Cor de fundo azul
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.center,  // Centraliza horizontalmente
          children: <Widget>[
            // Texto
            Text(
              'Biblioteca Scripta',
              style: TextStyle(
                color: Colors.white,  // Cor do texto branco
                fontSize: 30,  // Tamanho da fonte
                fontWeight: FontWeight.bold,  // Deixa o texto em negrito
              ),
            ),
            SizedBox(height: 20),  // Espaço entre o texto e o ícone
            
            // imagem
             Image.asset(
                  'assets/images/logo_scripta.png', // Substitua pelo caminho real da sua imagem
                  width: 70, // Define o tamanho da largura da imagem
                  height: 70, // Define o tamanho da altura da imagem
                  fit: BoxFit.contain, // Mantém a proporção da imagem
                ),
            SizedBox(height: 50),  // Espaço entre o ícone e o indicador de carregamento
            
            // Indicador de carregamento (CircularProgressIndicator)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),  // Cor do indicador
            ),
          ],
        ),
      ),
    );
  }
}