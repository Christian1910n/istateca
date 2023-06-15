import 'dart:convert';

import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/tipos.dart';

class Prestamo {
  int id_prestamo;
  String fechaFin;
  int estadoLibro;
  int estadoPrestamo;
  String fechaEntrega;
  int documentoHabilitante;
  String fechaDevolucion;
  String fechaMaxima;
  bool activo;
  String escaneoMatriz;
  int tipoPrestamo;
  Persona? idSolicitante;
  Persona? idEntrega;
  Persona? idRecibido;
  Carrera? carrera;
  Libro? libro;

  Prestamo({
    required this.id_prestamo,
    required this.fechaFin,
    required this.estadoLibro,
    required this.estadoPrestamo,
    required this.fechaEntrega,
    required this.documentoHabilitante,
    required this.fechaDevolucion,
    required this.fechaMaxima,
    required this.activo,
    required this.escaneoMatriz,
    required this.tipoPrestamo,
    this.idSolicitante,
    this.idEntrega,
    this.idRecibido,
    this.carrera,
    this.libro,
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      id_prestamo: json['id'] as int ?? 0,
      fechaFin: utf8.decode(json['fechaFin'].toString().codeUnits) ?? '',
      estadoPrestamo: json['estadoPrestamo'] as int ?? 0,
      estadoLibro: json['estadoLibro'] as int ?? 0,
      fechaEntrega:
          utf8.decode(json['fechaEntrega'].toString().codeUnits) ?? '',
      documentoHabilitante: json['documentoHabilitante'] as int ?? 0,
      fechaDevolucion:
          utf8.decode(json['fechaDevolucion'].toString().codeUnits) ?? '',
      fechaMaxima: utf8.decode(json['fechaMaxima'].toString().codeUnits) ?? '',
      activo: json['activo'] ?? false,
      escaneoMatriz:
          utf8.decode(json['escaneoMatriz'].toString().codeUnits) ?? '',
      tipoPrestamo: json['tipoPrestamo'] as int ?? 0,
      idSolicitante: Persona.fromJson(json['idSolicitante'] ?? {}),
      idEntrega: Persona.fromJson(json['idEntrega'] ?? {}),
      idRecibido: Persona.fromJson(json['idRecibido'] ?? {}),
      carrera: Carrera.fromJson(json['carrera'] ?? {}),
      libro: Libro.fromJson(json['libro'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_prestamo': id_prestamo,
      'fechaFin': fechaFin,
      'estadoPrestamo': estadoPrestamo,
      'estadoLibro': estadoLibro,
      'fechaEntrega': fechaEntrega,
      'documentoHabilitante': documentoHabilitante,
      'fechaDevolucion': fechaDevolucion,
      'fechaMaxima': fechaMaxima,
      'activo': activo,
      'escaneoMatriz': escaneoMatriz,
      'tipoPrestamo': tipoPrestamo,
      'idSolicitante': idSolicitante?.toJson(),
      'idEntrega': idEntrega?.toJson(),
      'idRecibido': idRecibido?.toJson(),
      'carrera': carrera?.toJson(),
      'libro': libro?.toJson(),
    };
  }

  void toggle() {
    activo = !activo;
  }
}
