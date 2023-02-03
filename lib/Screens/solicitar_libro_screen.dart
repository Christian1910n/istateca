import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class SolicitarLibroScreen extends StatefulWidget {
  final Libro libro;
  static String id = 'solicitar_libro_screen';

  const SolicitarLibroScreen({super.key, required this.libro});
  @override
  State<SolicitarLibroScreen> createState() => _SolicitarLibroScreenState();
}

class _SolicitarLibroScreenState extends State<SolicitarLibroScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.libro.titulo);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
