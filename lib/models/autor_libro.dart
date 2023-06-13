import 'dart:convert';

import 'package:proyectoistateca/models/autor.dart';
import 'package:proyectoistateca/models/libros.dart';

class AutorLibro {
  int id_autor_libro;
  Libro libro;
  Autor autor;

  AutorLibro({
    required this.id_autor_libro,
    required this.libro,
    required this.autor,
  });

  factory AutorLibro.fromJson(Map<String, dynamic> json) {
    return AutorLibro(
      id_autor_libro: json['id'] as int? ?? 0,
      libro: Libro.fromJson(json['libro']),
      autor: Autor.fromJson(json['autor']),
    );
  }
}
