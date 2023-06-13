import 'dart:convert';

import 'package:proyectoistateca/models/authorities.dart';

class Persona {
  int id_persona;
  int fenixId;
  String cedula;
  String correo;
  String nombres;
  String apellidos;
  int tipo;
  String celular;
  int calificacion;
  bool activo;
  Authority authorities;

  Persona({
    required this.id_persona,
    required this.fenixId,
    required this.cedula,
    required this.correo,
    required this.nombres,
    required this.apellidos,
    required this.tipo,
    required this.celular,
    required this.calificacion,
    required this.activo,
    required this.authorities,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id_persona: json['id'] as int? ?? 0,
      fenixId: json['fenixId'] as int? ?? 0,
      cedula: utf8.decode(json['cedula'].toString().codeUnits) ?? '',
      correo: utf8.decode(json['correo'].toString().codeUnits) ?? '',
      nombres: utf8.decode(json['nombres'].toString().codeUnits) ?? '',
      apellidos: utf8.decode(json['apellidos'].toString().codeUnits) ?? '',
      tipo: json['tipo'] as int? ?? 0,
      celular: utf8.decode(json['celular'].toString().codeUnits) ?? '',
      calificacion: json['calificacion'] as int? ?? 0,
      activo: json['activo'] as bool? ?? false,
      authorities: Authority.fromJson(json['authorities']),
    );
  }

  void toggle() {
    activo = !activo;
  }
}
