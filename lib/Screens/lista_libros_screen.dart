import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Services/database_services_libro.dart';
import 'package:proyectoistateca/libro_tile.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/tipos.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class LlibrosScreen extends StatefulWidget {
  static String id = 'lista_libros_screen';

  @override
  State<LlibrosScreen> createState() => _LlibrosScreenState();
}

class _LlibrosScreenState extends State<LlibrosScreen> {
  List<Libro>? libros;

  getLibros() async {
    libros = await Database_services_libro.getLibro();
    Provider.of<TiposData>(context, listen: false).libros = libros!;
    setState(() {});
  }

  getLibrosnombre(String titulo) async {
    libros = await Database_services_libro.getLibronombre(titulo);
    Provider.of<TiposData>(context, listen: false).libros = libros!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLibros();
  }

  @override
  Widget build(BuildContext context) {
    return libros == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text(
                'Libros (${Provider.of<TiposData>(context).libros.length})',
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<TiposData>(
                builder: (context, tiposData, child) {
                  return Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Searches",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != "") {
                            getLibrosnombre(value);
                          } else {
                            getLibros();
                          }
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: tiposData.libros.length,
                            itemBuilder: (context, index) {
                              Libro libro = tiposData.libros[index];
                              return LibrosTile(
                                libro: libro,
                                tiposData: tiposData,
                              );
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
