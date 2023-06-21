import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/detalle_libro_screen.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class LibrosTile extends StatelessWidget {
  final Libro libro;
  final TiposData tiposData;

  const LibrosTile({Key? key, required this.libro, required this.tiposData})
      : super(key: key);

  Future<ImageProvider> loadImage() async {
    try {
      final response = await http.get(Uri.parse(libro.urlImagen));
      if (response.statusCode == 200) {
        return MemoryImage(response.bodyBytes);
      } else {
        return Image.asset('assets/vacio.jpg').image;
      }
    } catch (e) {
      return Image.asset('assets/vacio.jpg').image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisponible = libro.disponibilidad;
    final imageWidget = FutureBuilder<ImageProvider>(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Image.asset('assets/vacio.jpg');
          } else {
            return Image(image: snapshot.data!);
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );

    Widget contentWidget;

    if (isDisponible) {
      contentWidget = imageWidget;
    } else {
      contentWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: imageWidget,
      );
    }

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
        child: Container(
          height: 200, // Ajusta la altura según tus necesidades
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: contentWidget,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(libro.titulo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
