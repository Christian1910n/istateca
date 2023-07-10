import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/solicitud_libro_screen.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/notificacion.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  List<Notificacion> notificaciones = [];

  Future<void> listanotificacionpersona() async {
    final String url =
        '$baseUrl/notificacion/notificacionesxpersona?idsolicitante=${personalog.id_persona}';
    print(url);
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Notificacion> notificacionesNuevas =
          jsonData.map((data) => Notificacion.fromJson(data)).toList();

      setState(() {
        notificaciones.addAll(notificacionesNuevas);
      });

      print("Notificaciones ${response.body}");
    } else {
      print('Error notificaciones personas: ${response.statusCode}');
    }
  }

  Future<void> listanotificacionesbibliotecario() async {
    const String url = '$baseUrl/notificacion/notificacionesbibliotecarios';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Notificacion> notificacionesNuevas =
          jsonData.map((data) => Notificacion.fromJson(data)).toList();

      setState(() {
        notificaciones.addAll(notificacionesNuevas);
      });

      print("Notificaciones ${response.body}");
    } else {
      print('Error notificaciones bibliotecario: ${response.statusCode}');
    }
  }

  Future<void> marcarleido(int id) async {
    Map data = {
      "visto": true,
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/notificacion/editar/$id";
      print(url);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('NOTIFICACION LEIDA ${response.body}');
      } else {
        print('Error al leer notificacion ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error editar notificacion $error");
    }
  }

  @override
  void initState() {
    if (rol == 'ADMIN' || rol == 'BIBLIOTECARIO') {
      listanotificacionesbibliotecario();
    } // else if (rol == 'ESTUDIANTE' || rol == 'DOCENTE') {
    listanotificacionpersona();
    //}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: ListView.builder(
          itemCount: notificaciones.length,
          itemBuilder: (context, index) {
            final notificacion = notificaciones[index];

            String mensaje;
            if (notificacion.mensaje == 1) {
              mensaje =
                  'El usuario ${notificacion.prestamo.idSolicitante!.nombres} ${notificacion.prestamo.idSolicitante!.apellidos}  a solicitado el libro ${notificacion.prestamo.libro!.titulo}';
            } else if (notificacion.mensaje == 2) {
              mensaje =
                  'Su solicitud del libro ${notificacion.prestamo.libro!.titulo} ha sido aprobado';
            } else if (notificacion.mensaje == 3) {
              mensaje =
                  'Su solicitud del libro ${notificacion.prestamo.libro!.titulo} ha sido rechazado';
            } else if (notificacion.mensaje == 4) {
              mensaje =
                  'El prestamo del libro ${notificacion.prestamo.libro!.titulo} al usuario ${notificacion.prestamo.idSolicitante!.nombres} ${notificacion.prestamo.idSolicitante!.apellidos} a superado la fecha máxima ${notificacion.prestamo.fechaMaxima}';
            } else if (notificacion.mensaje == 5) {
              mensaje =
                  'Su prestamo del libro ${notificacion.prestamo.libro!.titulo} a superado la fecha de devolución ${notificacion.prestamo.fechaMaxima}';
            } else if (notificacion.mensaje == 6) {
              mensaje =
                  'La devolución del libro ${notificacion.prestamo.libro!.titulo} a sido registrado exitosamente';
            } else {
              mensaje =
                  'Recuerda que tienes hasta ${notificacion.prestamo.fechaMaxima} para devolver el libro ${notificacion.prestamo.libro!.titulo}';
            }

            final bool leido = notificacion.visto;

            return ListTile(
              title: Row(
                children: [
                  Icon(
                    leido ? Icons.message_outlined : Icons.message,
                    color: leido ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Wrap(
                      children: [
                        Text(
                          mensaje,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                if (notificacion.visto == false) {
                  marcarleido(notificacion.id);
                }

                if (notificacion.mensaje == 1 &&
                    notificacion.prestamo.estadoPrestamo == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookRequestView(prestamo: notificacion.prestamo),
                    ),
                  );
                } else if (notificacion.mensaje == 1) {
                  Navigator.pushNamed(context, SolicitudesLibros.id);
                } else {
                  Navigator.pushNamed(context, LlibrosScreen.id);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
