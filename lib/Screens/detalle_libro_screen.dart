import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitar_libro_screen.dart';
import 'package:proyectoistateca/models/libros.dart';

class DetalleLibroScreen extends StatefulWidget {
  final Libro libro;

  const DetalleLibroScreen({super.key, required this.libro});

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
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
                color: Color.fromRGBO(
                    24, 98, 173, 1.0), // Color rojo personalizado
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
          _buildRow("Estado del Libro:", widget.libro.estadoLibro, Colors.blue,
              Colors.black),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SolicitarLibroScreen(libro: widget.libro)),
                    );
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
