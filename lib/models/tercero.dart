import 'dart:convert';

import 'package:proyectoistateca/models/prestamo.dart';

class Tercero {
  int id_tercero;
  String cedula;
  String correo;
  String nombre;
  String telefono;
  Prestamo prestamo;

  Tercero({
    required this.id_tercero,
    required this.cedula,
    required this.correo,
    required this.nombre,
    required this.telefono,
    required this.prestamo,
  });

  factory Tercero.fromJson(Map<String, dynamic> json) {
    return Tercero(
      id_tercero: json['id'] as int? ?? 0,
      cedula: utf8.decode(json['cedula'].toString().codeUnits) ?? '',
      correo: utf8.decode(json['correo'].toString().codeUnits) ?? '',
      nombre: utf8.decode(json['nombre'].toString().codeUnits) ?? '',
      telefono: utf8.decode(json['telefono'].toString().codeUnits) ?? '',
      prestamo: Prestamo.fromJson(json['prestamo']),
    );
  }
}
