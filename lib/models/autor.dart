import 'dart:convert';

class Autor {
  int id_autor;
  String nombre;

  Autor({
    required this.id_autor,
    required this.nombre,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id_autor: json['id'] as int? ?? 0,
      nombre: utf8.decode(json['nombre'].toString().codeUnits) ?? '',
    );
  }
}
