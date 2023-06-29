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
  int persona = 0;
  late Prestamo prestamo;
  final TextEditingController _carreraController = TextEditingController();
  int? selectedValue;

  @override
  void initState() {
    prestamo = widget.prestamo;
    persona = widget.prestamo.idSolicitante?.id_persona ?? 0;
    if (prestamo.estadoLibro == 0) {
      selectedValue = 0;
    }
    prestamo.fechaDevolucion =
        DateTime.now().add(const Duration(days: 1)).toString();
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
    if (prestamo.idSolicitante != null) {
      Map data = {
        "calificacion": prestamo.idSolicitante?.calificacion,
      };
      var body = json.encode(data);
      print("Nuevo Json: $body");

      try {
        var url = "$baseUrl/persona/editar/${persona}";
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
              value: selectedValue,
              items: const [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text('Seleccione'),
                ),
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
                  selectedValue = value;
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
                    initialRating:
                        prestamo.idSolicitante?.calificacion?.toDouble() ?? 0.0,
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
                        if (prestamo.idSolicitante != null) {
                          prestamo.idSolicitante!.calificacion = rating.toInt();
                        }
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
                    if (selectedValue != null && selectedValue != 0) {
                      modificarprestamo();
                      modificarcalificacion();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Debe seleccionar el estado del libro'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
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
