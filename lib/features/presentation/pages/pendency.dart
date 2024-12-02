import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PendencyWidget extends StatefulWidget {
  const PendencyWidget({super.key});

  @override
  State<PendencyWidget> createState() => _PendencyWidgetState();
}

class _PendencyWidgetState extends State<PendencyWidget> {
  final List<Map<String, dynamic>> pendencies = [
    {'title': 'A Dictionary of Music and Musicians', 'author': 'George Grove', 'value': 3.00},
    {'title': 'A manual of the mollusca', 'author': 'S. P. Woodward', 'value': 11.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2264E5),
        title: const Text(
          'Pendências',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2264E5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 10),
                  Text(
                    'Atenção: Caso você tenha pendências, não será possível realizar reservas ou empréstimos de livros até que elas sejam resolvidas.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Lista de pendências
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: pendencies.length,
                itemBuilder: (context, index) {
                  final pendency = pendencies[index];
                  return GestureDetector(
                    onTap: () {
                      _showPaymentModal(context, pendency);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Débito de livro',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'R\$ ${pendency['value'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pendency['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentModal(BuildContext context, Map<String, dynamic> pendency) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pendency['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Autor: ${pendency['author']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pagar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'R\$ ${pendency['value'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _generateAndShowPaymentCode(context, 'PIX');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2264E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('PIX'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _generateAndShowPaymentCode(context, 'Boleto');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Boleto'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _generateAndShowPaymentCode(BuildContext context, String method) {
  final randomCode = _generateRandomCode();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Código de pagamento ($method)'),
        content: SelectableText(randomCode),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: randomCode));

              // Aqui garantimos que o ScaffoldMessenger use o contexto principal
              Navigator.pop(dialogContext); // Fecha o diálogo antes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Código de pagamento copiado'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Copiar código'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}


  String _generateRandomCode() {
    final random = Random();
    return List.generate(15, (_) => random.nextInt(10)).join();
  }
}
