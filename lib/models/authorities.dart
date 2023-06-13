import 'dart:convert';
import 'package:proyectoistateca/models/persona.dart';

class Authority {
  int id_authorities;
  String name;
  Persona persona;

  Authority({
    required this.id_authorities,
    required this.name,
    required this.persona,
  });

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      id_authorities: json['id'] as int? ?? 0,
      name: utf8.decode(json['name'].toString().codeUnits) ?? '',
      persona: Persona.fromJson(json['persona']),
    );
  }
}
