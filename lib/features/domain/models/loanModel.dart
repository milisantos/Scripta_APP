import 'package:flutter_app/features/domain/models/userModel.dart';
import 'package:flutter_app/features/domain/models/livromodelapi.dart';
import 'package:intl/intl.dart';  // Importar o pacote intl

class LoanModel {
  final int emprestimoID;
  final UserModel usuario;
  final LivroModelApi livro;
  final DateTime dataAprovacao;
  final DateTime dataDevolucao;

  LoanModel({
    required this.emprestimoID,
    required this.usuario,
    required this.livro,
    required this.dataAprovacao,
    required this.dataDevolucao,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    // Pegando as strings das datas
    String dataAprovacaoString = json['dataAprovacao'];
    String dataDevolucaoString = json['dataDevolucao'];


 // Removendo o '@' da string da data
    dataAprovacaoString = dataAprovacaoString.replaceAll('@', ' ');
    dataDevolucaoString = dataDevolucaoString.replaceAll('@', ' ');
    
    // Usando o DateFormat para converter as strings para DateTime
    DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");

    // Convertendo as strings para DateTime com o formato correto
    DateTime dataAprovacao = format.parse(dataAprovacaoString);
    DateTime dataDevolucao = format.parse(dataDevolucaoString);

    return LoanModel(
      emprestimoID: json['emprestimoID'],
      usuario: UserModel.fromJson(json['usuario']),
      livro: LivroModelApi.fromJson(json['livro']),
      dataAprovacao: dataAprovacao,
      dataDevolucao: dataDevolucao,
    );
  }
}
