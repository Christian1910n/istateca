import 'dart:convert';

import 'package:proyectoistateca/models/tipos.dart';

class Libro {
  final int id_libro;
  final String codigo_dewey;
  final String titulo;
  // final Tipo tipo;
  final String adquisicion;
  final int anio_publicacion;
  final String editor;
  final String ciudad;
  final String num_paginas;
  final String area;
  final String cod_ISBN;
  final String idioma;
  final String descripcion;
  final String dimensiones;
  final String estado_libro;
  bool activo;
  //final String imagen;
  final String url_digital;
  //final Bibliotecarios bibliotecarios;
  final String fecha_creacion;
  bool disponibilidad;
  final String indice_uno;
  final String indice_dos;
  final String indice_tres;
  final String nombre_donante;
  //final byte[] documento_donacion;

  Libro({
    required this.id_libro,
    required this.codigo_dewey,
    required this.titulo,
    //required this.tipo,
    required this.adquisicion,
    required this.anio_publicacion,
    required this.editor,
    required this.ciudad,
    required this.num_paginas,
    required this.area,
    required this.cod_ISBN,
    required this.idioma,
    required this.descripcion,
    required this.dimensiones,
    required this.estado_libro,
    required this.activo,
    //required this.imagen,
    required this.url_digital,
    //required this.bibliotecario,
    required this.fecha_creacion,
    required this.disponibilidad,
    required this.indice_uno,
    required this.indice_dos,
    required this.indice_tres,
    required this.nombre_donante,
    //required this.documento_donacion
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id_libro: json['id_libro'] as int,
      codigo_dewey: json['codigo_dewey'] as String,
      titulo: json['titulo'] as String,
      //tipo: Tipo.fromJson(json['tipo']),
      adquisicion: json['adquisicion'] as String,
      anio_publicacion: json['anio_publicacion'] as int,
      editor: json['editor'] as String,
      ciudad: json['ciudad'] as String,
      num_paginas: json['num_paginas'] as String,
      area: json['area'] as String,
      cod_ISBN: json['cod_ISBN'] as String,
      idioma: utf8.decode(json['idioma'].toString().codeUnits),
      descripcion: utf8.decode(json['descripcion'].toString().codeUnits),
      dimensiones: json['dimensiones'] as String,
      estado_libro: json['estado_libro'] as String,
      activo: json['activo'] as bool,
      url_digital: json['url_digital'] as String,
      fecha_creacion: json['fecha_creacion'] as String,
      disponibilidad: json['disponibilidad'] as bool,
      indice_uno: json['indice_uno'] as String,
      indice_dos: json['indice_dos'] as String,
      indice_tres: json['indice_tres'] as String,
      nombre_donante: json['nombre_donante'] as String,
    );
  }

  void toggle() {
    activo = !activo;
    disponibilidad = !disponibilidad;
  }
}
