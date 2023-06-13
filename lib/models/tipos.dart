import 'dart:convert';

class Tipo {
  int id;
  String nombre;
  bool activo;

  Tipo({required this.id, required this.nombre, required this.activo});

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      id: json['id'] ?? 0,
      nombre: utf8.decode(json['nombre'].toString().codeUnits),
      activo: json['activo'] ?? false,
    );
  }
}
