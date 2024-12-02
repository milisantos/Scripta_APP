import 'package:flutter/material.dart';
import 'package:flutter_app/features/domain/models/userModel.dart';
import 'package:flutter_app/features/data/repositories/user_repository.dart'; 
import 'package:flutter_app/features/presentation/pages/underConstructionScreen.dart';
import 'package:flutter_app/shared/components/bottom_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isChecked = false;

  // Variável para controlar a exibição da mensagem de erro
  String? _errorMessage;


  // Função para fazer o login
  Future<void> _login() async {
    // objeto UserModel com os dados dos controladores
    UserModel user = UserModel(
      matricula: _matriculaController.text,
      senha: _senhaController.text,
    );

    //método de autenticação da API
    UserRepository api = UserRepository();
    String result = await api.authenticate(user);

    // Verifica o erro de servidor, para o caso da apresentação qualquer um conseguir entrar
    if (result == "Erro ao conectar com o servidor") {
      setState(() {
        _errorMessage = "Erro ao conectar com o servidor. Tente novamente mais tarde.";
      });
      // Verifica a matrícula antes de permitir o login
      if (user.matricula.isNotEmpty && 
        (user.matricula[0] == '0' || user.matricula[0] == '1' || user.matricula[0] == '2' || 
        user.matricula[0] == '3'|| user.matricula[0] == '4')) {
        // usuario sem emprestimos e sem pendencias
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigator(userType: 'userSapi_1')), 
        );
      } else if(user.matricula.isNotEmpty && 
        ( user.matricula[0] == '5' || user.matricula[0] == '6' || user.matricula[0] == '7'|| 
         user.matricula[0] == '8'|| user.matricula[0] == '9')){
        // usuario sem emprestimos e COM pendencias
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigator(userType: 'userSapi_2')), 
        );
      }
    } else if (result == "Login bem-sucedido!") {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigator(userType: 'userApi')),
      );      
      
    } else {
      // Se o login falhar, exibe a mensagem de erro
      setState(() {
        _errorMessage = result;  // Armazena a mensagem de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(70),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
              height: MediaQuery.of(context).size.height * 0.77,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: _matriculaController,
                    decoration: InputDecoration(
                      labelText: 'Matrícula',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  
                  // Exibir a mensagem de erro
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isChecked = !_isChecked;
                            });
                          },
                          child: const Text(
                            'Lembrar-me',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _login, // Chama a função _login ao pressionar
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 70),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UnderConstructionScreen()),
                      );
                    },
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.85,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_scripta.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
