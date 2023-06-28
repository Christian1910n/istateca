import 'dart:convert';

import 'package:proyectoistateca/models/persona.dart';

class Sugerencias {
  final int id;
  final String descripcion;
  final DateTime fecha;
  final Persona persona;

  Sugerencias(
      {required this.id,
      required this.descripcion,
      required this.fecha,
      required this.persona});

  factory Sugerencias.fromJson(Map<String, dynamic> json) {
    return Sugerencias(
        id: json['id'] as int? ?? 0,
        descripcion: utf8.decode(json['descripcion'].toString().codeUnits),
        fecha: DateTime.parse(json['fecha']),
        persona: Persona.fromJson(json['persona']));
  }
}
