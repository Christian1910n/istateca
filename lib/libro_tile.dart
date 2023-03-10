import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/detalle_libro_screen.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/tipos_data.dart';

class LibrosTile extends StatelessWidget {
  final Libro libro;
  final TiposData tiposData;

  const LibrosTile({Key? key, required this.libro, required this.tiposData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 10,
          backgroundColor: libro.disponibilidad ? Colors.red : Colors.green,
          child: const Text(""),
        ),
        title: Text(libro.titulo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return DetalleLibroScreen(libro: libro);
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
