import 'package:proyectoistateca/models/prestamo.dart';

class Notificacion {
  final int id;
  final int mensaje;
  final bool visto;
  final Prestamo prestamo;

  Notificacion(
      {required this.id,
      required this.mensaje,
      required this.visto,
      required this.prestamo});

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as int? ?? 0,
      mensaje: json['mensaje'] as int? ?? 0,
      visto: json['visto'] ?? false,
      prestamo: Prestamo.fromJson(json['prestamo'] ?? {}),
    );
  }
}
