class Tipo {
  final int id_tipo;
  final String nombre;

  Tipo({
    required this.id_tipo,
    required this.nombre,
  });

  factory Tipo.fromMap(Map tipoMap) {
    return Tipo(id_tipo: tipoMap['id_tipo'], nombre: tipoMap['nombre']);
  }
}
