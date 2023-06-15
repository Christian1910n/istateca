import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitar_libro_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:intl/intl.dart';

class DetalleLibroScreen extends StatefulWidget {
  final Libro libro;

  const DetalleLibroScreen({super.key, required this.libro});

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
//Datos de ejemplo
  int idsoli = 0;

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

  Carrera carrera =
      Carrera(id_carrera: 2, idFenix: 0, nombre: "nombre", activo: true);

  Future<void> crearPrestamo() async {
    String fecha = "2022-12-12";
    Prestamo prestamo = Prestamo(
        id_prestamo: 0,
        fechaFin: fecha,
        estadoLibro: 2,
        estadoPrestamo: 1,
        fechaEntrega: fecha,
        documentoHabilitante: 0,
        fechaDevolucion: fecha,
        fechaMaxima: fecha,
        activo: true,
        escaneoMatriz: "",
        tipoPrestamo: 2,
        idSolicitante: persona,
        idEntrega: null,
        idRecibido: null,
        carrera: carrera,
        libro: widget.libro);

    try {
      const url = "$baseUrl/prestamo/crear";

      final headers = {'Content-Type': 'application/json'};

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: prestamoJson,
      );

      if (response.statusCode == 201) {
        print('Prestamo creado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
        setState(() {
          idsoli = prestamo.id_prestamo;
        });
      } else {
        print('Error al crear el prestamo: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error crear prestamo $error");
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SolicitarLibroScreen(libro: widget.libro, idsolicitud: idsoli)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Center(
            child: Text(
              widget.libro.titulo,
              style: const TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(24, 98, 173, 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRow("Descripción:", widget.libro.descripcion, Colors.blue,
              Colors.black),
          _buildRow(
              "Año de Publicación:",
              widget.libro.anioPublicacion.toString(),
              Colors.blue,
              Colors.black),
          _buildRow("Ciudad:", widget.libro.ciudad, Colors.blue, Colors.black),
          _buildRow("Editor:", widget.libro.editor, Colors.blue, Colors.black),
          _buildRow("Idioma:", widget.libro.idioma, Colors.blue, Colors.black),
          _buildRow("Estado del Libro:", "${widget.libro.estadoLibro}",
              Colors.blue, Colors.black),
          _buildRow("Número de páginas:", widget.libro.numPaginas.toString(),
              Colors.blue, Colors.black),
          _buildRow("Código Dewey:", widget.libro.codigoDewey, Colors.blue,
              Colors.black),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: widget.libro.disponibilidad == false
                  ? Colors.grey
                  : Colors.green[400],
            ),
            onPressed: widget.libro.disponibilidad == false
                ? null
                : () {
                    crearPrestamo();
                  },
            child: const Text(
              "Solicitar Libro",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      String title, String value, Color titleColor, Color valueColor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, color: titleColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 15, color: valueColor),
          ),
        ),
      ],
    );
  }
}
