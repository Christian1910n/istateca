import 'dart:convert';

import 'package:proyectoistateca/models/tipos.dart';

class Persona {
  int id;
  int fenixId;
  String cedula;
  String correo;
  String nombres;
  String apellidos;
  int tipo;
  String celular;
  int calificacion;
  bool activo;

  Persona({
    required this.id,
    required this.fenixId,
    required this.cedula,
    required this.correo,
    required this.nombres,
    required this.apellidos,
    required this.tipo,
    required this.celular,
    required this.calificacion,
    required this.activo,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'] ?? 0,
      fenixId: json['fenixId'] ?? 0,
      cedula: utf8.decode(json['cedula'].toString().codeUnits) ?? '',
      correo: utf8.decode(json['correo'].toString().codeUnits) ?? '',
      nombres: utf8.decode(json['nombres'].toString().codeUnits) ?? '',
      apellidos: utf8.decode(json['apellidos'].toString().codeUnits) ?? '',
      tipo: json['tipo'] ?? 0,
      celular: utf8.decode(json['celular'].toString().codeUnits) ?? '',
      calificacion: json['calificacion'] ?? 0,
      activo: json['activo'] ?? false,
    );
  }
}
