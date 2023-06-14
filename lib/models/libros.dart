import 'dart:convert';

import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/tipos.dart';

class Libro {
  int id;
  String codigoDewey;
  String titulo;
  String adquisicion;
  int anioPublicacion;
  String editor;
  String ciudad;
  int numPaginas;
  String area;
  String conIsbn;
  String idioma;
  String indiceUno;
  String indiceDos;
  String indiceTres;
  String descripcion;
  String dimenciones;
  int estadoLibro;
  String nombreDonante;
  bool activo;
  String urlImagen;
  String urlActaDonacion;
  String urlDigital;
  DateTime fechaCreacion;
  bool disponibilidad;
  Tipo tipo;
  Persona persona;

  Libro({
    required this.id,
    required this.codigoDewey,
    required this.titulo,
    required this.adquisicion,
    required this.anioPublicacion,
    required this.editor,
    required this.ciudad,
    required this.numPaginas,
    required this.area,
    required this.conIsbn,
    required this.idioma,
    required this.indiceUno,
    required this.indiceDos,
    required this.indiceTres,
    required this.descripcion,
    required this.dimenciones,
    required this.estadoLibro,
    required this.nombreDonante,
    required this.activo,
    required this.urlImagen,
    required this.urlActaDonacion,
    required this.urlDigital,
    required this.fechaCreacion,
    required this.disponibilidad,
    required this.tipo,
    required this.persona,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'] ?? 0,
      codigoDewey: utf8.decode(json['codigoDewey'].toString().codeUnits) ?? '',
      titulo: utf8.decode(json['titulo'].toString().codeUnits) ?? '',
      adquisicion: utf8.decode(json['adquisicion'].toString().codeUnits) ?? '',
      anioPublicacion: json['anioPublicacion'] ?? 0,
      editor: utf8.decode(json['editor'].toString().codeUnits) ?? '',
      ciudad: utf8.decode(json['ciudad'].toString().codeUnits) ?? '',
      numPaginas: json['numPaginas'] ?? 0,
      area: utf8.decode(json['area'].toString().codeUnits) ?? '',
      conIsbn: utf8.decode(json['conIsbn'].toString().codeUnits) ?? '',
      idioma: utf8.decode(json['idioma'].toString().codeUnits) ?? '',
      indiceUno: utf8.decode(json['indiceUno'].toString().codeUnits) ?? '',
      indiceDos: utf8.decode(json['indiceDos'].toString().codeUnits) ?? '',
      indiceTres: utf8.decode(json['indiceTres'].toString().codeUnits) ?? '',
      descripcion: utf8.decode(json['descripcion'].toString().codeUnits) ?? '',
      dimenciones: utf8.decode(json['dimenciones'].toString().codeUnits) ?? '',
      estadoLibro: json['estadoLibro'] ?? 0,
      nombreDonante:
          utf8.decode(json['nombreDonante'].toString().codeUnits) ?? '',
      activo: json['activo'] ?? false,
      urlImagen: utf8.decode(json['urlImagen'].toString().codeUnits) ?? '',
      urlActaDonacion:
          utf8.decode(json['urlActaDonacion'].toString().codeUnits) ?? '',
      urlDigital: utf8.decode(json['urlDigital'].toString().codeUnits) ?? '',
      fechaCreacion: DateTime.parse(
          utf8.decode(json['fechaCreacion'].toString().codeUnits) ?? ''),
      disponibilidad: json['disponibilidad'] ?? false,
      tipo: Tipo.fromJson(json['tipo'] ?? {}),
      persona: Persona.fromJson(json['persona'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigoDewey': codigoDewey,
      'titulo': titulo,
      'adquisicion': adquisicion,
      'anioPublicacion': anioPublicacion,
      'editor': editor,
      'ciudad': ciudad,
      'numPaginas': numPaginas,
      'area': area,
      'conIsbn': conIsbn,
      'idioma': idioma,
      'indiceUno': indiceUno,
      'indiceDos': indiceDos,
      'indiceTres': indiceTres,
      'descripcion': descripcion,
      'dimenciones': dimenciones,
      'estadoLibro': estadoLibro,
      'nombreDonante': nombreDonante,
      'activo': activo,
      'urlImagen': urlImagen,
      'urlActaDonacion': urlActaDonacion,
      'urlDigital': urlDigital,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'disponibilidad': disponibilidad,
      'tipo': tipo.toJson(),
      'persona': persona.toJson(),
    };
  }
}
