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
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return DetalleLibroScreen(libro: libro);
            },
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 500, // Ajusta la altura según tus necesidades
                child: Image.network(
                  'https://www.eluniverso.com/resizer/a7RzV9cpgq3r0Pxpo__CtrcH2Wk=/arc-anglerfish-arc2-prod-eluniverso/public/NUNM6L7XP26ZH2ZX2UUP7C5JIA.jpg',
                  fit: BoxFit
                      .cover, // Ajusta la forma en que la imagen se ajusta al contenedor
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(24, 98, 173, 1.0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10), // Radio de borde
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 10,
              backgroundColor: libro.disponibilidad ? Colors.green : Colors.red,
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
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
