import 'package:flutter/material.dart';
import 'package:flutter_app/features/presentation/pages/splash.dart';

void main() {
  runApp(const MyApp());
}

//StatelessWidget - O conteúdo desse widget não muda ao longo do tempo, ou seja, ele é imutável.
class MyApp extends StatelessWidget {
  const MyApp({super.key});


// build é onde a interface é definida
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Scripta',
      home: SplashScreen(), // define a tela inicial
      debugShowCheckedModeBanner: false,
    );
  }
}
