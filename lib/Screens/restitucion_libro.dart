import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestitucionLibro extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const RestitucionLibro({Key? key, required this.prestamo}) : super(key: key);

  @override
  _RestitucionLibroState createState() => _RestitucionLibroState();
}

class _RestitucionLibroState extends State<RestitucionLibro> {
  late Prestamo prestamo;
  String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _carreraController = TextEditingController();

  @override
  void initState() {
    prestamo = widget.prestamo;
  }

  @override
  void dispose() {
    _carreraController.dispose();
    super.dispose();
  }

  Future<void> modificarprestamo() async {
    Map data = {
      "estadoPrestamo": 6,
      "fechaDevolucion": fechaActual,
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/prestamo/editar/${widget.prestamo.id_prestamo}";
      print(url);

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Prestamo modificado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
      } else {
        print('Error al editar el prestamo: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error editar prestamo $error");
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SolicitudesLibros()),
      );
    }
  }

  Future<void> confirmarRestitucion(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación de Restitución'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro que quieres restituir este libro?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                modificarprestamo();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restitucion de Libro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(24, 98, 173, 1.0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'N° Solicitud: ${prestamo.id_prestamo}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Cedula Solicitante: ${prestamo.idSolicitante?.cedula ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Nombre Solicitante: ${prestamo.idSolicitante?.nombres ?? ''} ${prestamo.idSolicitante?.apellidos ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Carrera: ${prestamo.carrera?.nombre ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Título del Libro: ${prestamo.libro?.titulo ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Documento Habilitante: ${prestamo.documentoHabilitante == 1 ? 'Cédula' : prestamo.documentoHabilitante == 2 ? 'Pasaporte' : prestamo.documentoHabilitante == 3 ? 'Licencia de conducir' : ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Bibliotecario que entrega: ${prestamo.idEntrega?.nombres ?? ''} ${prestamo.idEntrega?.apellidos ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Bibliotecario que recibe: ${personalog.nombres}  ${personalog.apellidos}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Fecha Entrega: ${prestamo.fechaEntrega}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Fecha Devolución: ${prestamo.fechaDevolucion}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    confirmarRestitucion(context);
                  },
                  child: const Text('Restituir libro'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
