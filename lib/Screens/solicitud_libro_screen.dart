import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:http/http.dart' as http;

class BookRequestView extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const BookRequestView({super.key, required this.prestamo});

  @override
  _BookRequestViewState createState() => _BookRequestViewState();
}

class _BookRequestViewState extends State<BookRequestView> {
  late Prestamo prestamo;
  Persona persona = Persona(
      id_persona: 1,
      fenixId: 0,
      cedula: "cedula",
      correo: "correo",
      nombres: "nombres",
      apellidos: "",
      tipo: 0,
      celular: "",
      calificacion: 0,
      activo: true);
  DateTime _selectedDate = DateTime.now();
  Future<void> modificarprestamo() async {
    setState(() {
      prestamo.estadoPrestamo = 2;
      prestamo.idEntrega = persona;
      prestamo.idRecibido = persona;
    });

    Map data = {
      "estadoPrestamo": 2,
      "idEntrega": {"id": 1},
      "estadoLibro": prestamo.estadoLibro,
      "documentoHabilitante": prestamo.documentoHabilitante,
      "tipoPrestamo": prestamo.tipoPrestamo,
      "fechaMaxima": prestamo.fechaMaxima
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/prestamo/editar/${widget.prestamo.id_prestamo}";
      print(url);

      final headers = {'Content-Type': 'application/json'};

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Prestamo creado ${response.body}');
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

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        prestamo.fechaMaxima = picked.add(const Duration(days: 1)).toString();
      });
    }
  }

  @override
  void initState() {
    setState(() {
      prestamo = widget.prestamo;
    });
    print(widget.prestamo.libro!.titulo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SolicitudesLibros()),
          );

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Formulario de Solicitudes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
          ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre Solicitante: ${prestamo.idSolicitante!.nombres} ${prestamo.idSolicitante!.apellidos}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Título del Libro: ${prestamo.libro!.titulo}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Fecha de Solicitud: ${prestamo.fechaFin}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Nombre de la Persona que Entrega: bibliotecario',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  value: prestamo.estadoLibro,
                  items: [
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
                    });
                  },
                  decoration: InputDecoration(labelText: 'Estado del Libro'),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  value: prestamo.documentoHabilitante,
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Seleccione:'),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Cédula'),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Pasaporte'),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text('Licencia de Conducir'),
                    ),
                  ],
                  onChanged: (value) {
                    prestamo.documentoHabilitante = value!;
                  },
                  decoration:
                      InputDecoration(labelText: 'Documento Habilitante'),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  title: Text('Fecha Maxima de Devolución'),
                  subtitle: Text(
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  value: prestamo.tipoPrestamo,
                  items: const [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Estudiantil'),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Docencia'),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text('Terceros'),
                    ),
                  ],
                  onChanged: (value) {
                    prestamo.tipoPrestamo = value!;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Préstamo'),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        modificarprestamo();
                      },
                      child: Text('Aprobar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para rechazar la solicitud
                      },
                      child: Text('Rechazar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
