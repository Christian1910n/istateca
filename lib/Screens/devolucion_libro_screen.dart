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

class DevolucionLibro extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const DevolucionLibro({Key? key, required this.prestamo}) : super(key: key);

  @override
  _DevolucionLibroState createState() => _DevolucionLibroState();
}

class _DevolucionLibroState extends State<DevolucionLibro> {
  late Prestamo prestamo;
  final TextEditingController _carreraController = TextEditingController();

  @override
  void initState() {
    prestamo = widget.prestamo;
    prestamo.fechaDevolucion = DateTime.now().toIso8601String();
    super.initState();
  }

  @override
  void dispose() {
    _carreraController.dispose();
    super.dispose();
  }

  Future<void> modificarprestamo() async {
    Map data = {
      "estadoPrestamo": prestamo.estadoPrestamo,
      "idRecibido": {"id": personalog.id_persona},
      "estadoLibro": prestamo.estadoLibro,
      "fechaDevolucion": prestamo.fechaDevolucion,
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

  Future<void> modificarcalificacion() async {
    Map data = {
      "calificacion": personalog.calificacion,
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/persona/editar/${personalog.id_persona}";
      print(url);

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Calificacion modificado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
      } else {
        print('Error al editar la calificacion: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error editar la calificacion $error");
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SolicitudesLibros()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formulario de Devolución',
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
              'Fecha Máxima de Devolución: ${prestamo.fechaMaxima}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: prestamo.estadoLibro,
              items: const [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Bueno'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Regular'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Malo'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  prestamo.estadoLibro = value!;
                  prestamo.estadoPrestamo = (value == 3) ? 4 : 3;
                });
              },
              decoration: const InputDecoration(labelText: 'Estado del Libro'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Fecha de Devolución: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Calificación del estudiante',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  RatingBar.builder(
                    initialRating: personalog.calificacion.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        personalog.calificacion = rating.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    modificarprestamo();
                    modificarcalificacion();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
