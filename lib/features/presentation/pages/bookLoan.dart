import 'package:flutter/material.dart';
import 'package:flutter_app/features/domain/models/loanModel.dart';
import 'package:flutter_app/features/data/repositories/loan_repository.dart';

class BookLoanScreen extends StatefulWidget {
  const BookLoanScreen({super.key});

  @override
  _BookLoanScreenState createState() => _BookLoanScreenState();
}

class _BookLoanScreenState extends State<BookLoanScreen> {
  List<LoanModel> _emprestimos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmprestimos();
  }

  Future<void> _loadEmprestimos() async { //buscar emprestimos na api
    try {
      var emprestimos = await LoanRepository().fetchEmprestimosByMatricula();
      setState(() {
        _emprestimos = emprestimos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erro ao carregar os empréstimos: $e");
    }
  }

  void _showLoanDetailsDialog(LoanModel emprestimo) {
  String dataAprovacao = emprestimo.dataAprovacao.toLocal().toString().split(' ')[0];
  String dataDevolucao = emprestimo.dataDevolucao.toLocal().toString().split(' ')[0];

  // Flag para mostrar se houve erro ao renovar
  String mensagemErro = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Detalhes do Empréstimo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              // Detalhes do empréstimo
              Text(
                'Título: ${emprestimo.livro.titulo}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                'Autor: ${emprestimo.livro.autor}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 14),
              Text(
                'Data de Aprovação: $dataAprovacao',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Data de Devolução: $dataDevolucao',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 24),
              // Mensagem de erro, caso haja
              if (mensagemErro.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    mensagemErro,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              // Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão de renovação
                  ElevatedButton(
                    onPressed: () async {
                      // Chama o método de renovação
                      bool sucesso = await LoanRepository().renovarEmprestimo(emprestimo.emprestimoID);

                      if (sucesso) {
                        // Se a renovação foi bem-sucedida
                        Navigator.of(context).pop(); // Fecha o modal
                        await _loadEmprestimos();
                        _showRenewalSnackBar(); // Exibe o SnackBar de renovação
                        
                      } else {
                        Navigator.of(context).pop();
                        _showErrorSnackBar();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('Renovar'),
                  ),
                  // Botão de fechar
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o modal sem fazer nada
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text('Fechar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
void _showErrorSnackBar() {
  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.red.shade200, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(
          color: Colors.red.shade800, 
          width: 2, 
        ),
      ),
      child: Text(
        "Falha ao renovar o empréstimo.",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color.fromARGB(0, 214, 213, 213), 
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 70), 
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}



  void _showRenewalSnackBar() {
  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue.shade200, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(
          color: Colors.blue.shade800, 
          width: 2, 
        ),
      ),
      child: Text(
        "Renovação aprovada!",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent, 
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 70), 
    duration: Duration(seconds: 3),
  );

  // Exibe o SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Empréstimos de Livros',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Aqui você pode visualizar todos os livros emprestados. Acompanhe os prazos de devolução e gerencie seus empréstimos.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 50),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _emprestimos.isEmpty
                      ? Center(
                          child: Text(
                            'Você ainda não tem empréstimos.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 51, 65, 92),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _emprestimos.length,
                            itemBuilder: (context, index) {
                              var emprestimo = _emprestimos[index];

                              // Formatando as datas para um formato mais legível
                              String dataAprovacao = emprestimo.dataAprovacao.toLocal().toString().split(' ')[0];
                              String dataDevolucao = emprestimo.dataDevolucao.toLocal().toString().split(' ')[0];

                              // Verificando se o livro está em atraso
                              bool emAtraso = DateTime.now().isAfter(emprestimo.dataDevolucao);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 20),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.blue.shade50,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(15),
                                  leading: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.book,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  ),
                                  title: Text(
                                    emprestimo.livro.titulo,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        emprestimo.livro.autor,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Devolução: $dataDevolucao',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      // Exibindo a tag "Em atraso" se a data de devolução passou
                                      if (emAtraso)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade400,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Em atraso',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.blue.shade700,
                                  ),
                                  onTap: () {
                                    // Ação quando o usuário clicar no livro
                                    _showLoanDetailsDialog(emprestimo); // Exibe o modal
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
