import 'package:flutter/material.dart';
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
                  fontSize: 30, color: Colors.red, fontFamily: "cursive"),
            ),
          ),
          Row(
            children: [
              const Text(
                "Descripcion: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Expanded(
                child: Text(
                  widget.libro.descripcion,
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Año de Publicación: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 40),
              Center(
                child: Text(
                  widget.libro.anio_publicacion.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Ciudad: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 137),
              Text(
                widget.libro.ciudad,
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Editor ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 152),
              Text(
                widget.libro.editor,
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Idioma: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 138),
              Text(
                widget.libro.idioma,
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Estado del Libro: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 63),
              Text(
                widget.libro.estado_libro,
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Número de páginas: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 33),
              Text(
                widget.libro.num_paginas.toString(),
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Codigo Dewey: ",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(width: 80),
              Text(
                widget.libro.codigo_dewey,
                style: TextStyle(fontSize: 15, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
