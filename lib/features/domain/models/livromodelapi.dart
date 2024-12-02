class LivroModelApi {

  final String titulo;
  final String autor;


  // construtor
  LivroModelApi ({
    required this.titulo, 
    required this.autor
    });


  // recebe os dados json e passa pra objeto 
  factory LivroModelApi.fromJson(Map<String, dynamic> json) {
      return LivroModelApi(

        titulo: json['titulo'] ?? 'Título não disponível', 
        
        autor: json['autor'] ?? 'Autor não disponível', // se nulo, valor padrão é a frase
        
      );
    }


  Map<String, dynamic> toJson() { // metodo parapassar um objeto para json
    return {
      'title': titulo,
      'author': autor,
    };
  }



} //class