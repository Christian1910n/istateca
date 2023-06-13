import 'dart:convert';

import 'package:proyectoistateca/models/persona.dart';

class BibliotecarioCargo {
  int id_bibliotecario;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool activoBibliotecario;
  Persona persona;

  BibliotecarioCargo({
    required this.id_bibliotecario,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activoBibliotecario,
    required this.persona,
  });

  factory BibliotecarioCargo.fromJson(Map<String, dynamic> json) {
    return BibliotecarioCargo(
      id_bibliotecario: json['id'] as int? ?? 0,
      fechaInicio: DateTime.parse(
          utf8.decode(json['fechaInicio'].toString().codeUnits) ?? ''),
      fechaFin: DateTime.parse(
          utf8.decode(json['fechaFin'].toString().codeUnits) ?? ''),
      activoBibliotecario: json['activoBibliotecario'] as bool? ?? false,
      persona: Persona.fromJson(json['persona']),
    );
  }

  void toggle() {
    activoBibliotecario = !activoBibliotecario;
  }
}
