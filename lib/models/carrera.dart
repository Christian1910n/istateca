import 'dart:convert';

class Carrera {
  int id_carrera;
  int idFenix;
  String nombre;
  bool activo;

  Carrera({
    required this.id_carrera,
    required this.idFenix,
    required this.nombre,
    required this.activo,
  });

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id_carrera: json['id'] as int? ?? 0,
      idFenix: json['idFenix'] as int? ?? 0,
      nombre: utf8.decode(json['nombre'].toString().codeUnits) ?? '',
      activo: json['activo'] as bool? ?? false,
    );
  }

  void toggle() {
    activo = !activo;
  }
}
