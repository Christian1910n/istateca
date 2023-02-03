import 'package:proyectoistateca/models/tipos.dart';

class Libro {
  final int id_libro;
  final String codigo_dewey;
  final String titulo;
  //final Tipo tipo;
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

  factory Libro.fromMap(Map tipoMap) {
    return Libro(
        id_libro: tipoMap['id_libro'],
        codigo_dewey: tipoMap['codigo_dewey'],
        titulo: tipoMap['titulo'],
        //tipo: tipoMap['tipo'],
        adquisicion: tipoMap['adquisicion'],
        anio_publicacion: tipoMap['anio_publicacion'],
        editor: tipoMap['editor'],
        ciudad: tipoMap['ciudad'],
        num_paginas: tipoMap['num_paginas'],
        area: tipoMap['area'],
        cod_ISBN: tipoMap['cod_ISBN'],
        idioma: tipoMap['idioma'],
        descripcion: tipoMap['descripcion'],
        dimensiones: tipoMap['dimensiones'],
        estado_libro: tipoMap['estado_libro'],
        activo: tipoMap['activo'],
        url_digital: tipoMap['url_digital'],
        fecha_creacion: tipoMap['fecha_creacion'],
        disponibilidad: tipoMap['disponibilidad'],
        indice_uno: tipoMap['indice_uno'],
        indice_dos: tipoMap['indice_dos'],
        indice_tres: tipoMap['indice_tres'],
        nombre_donante: tipoMap['nombre_donante']);
  }

  void toggle() {
    activo = !activo;
    disponibilidad = !disponibilidad;
  }
}
