
class UserModel {
  
  final String matricula;
  final String senha;

  // Construtor da classe
  UserModel ({required this.matricula, required this.senha});


  // Método para converter um Map (JSON) para um objeto 
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      matricula: json['matricula'],
      senha: json['senha'],
    );
  }

  // Método para converter um objeto para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'matricula': matricula,
      'senha' : senha,
    };
  }


} // class