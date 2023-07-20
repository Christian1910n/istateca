import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/sugerencia.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class ListasugerenciasScreen extends StatefulWidget {
  const ListasugerenciasScreen({super.key});
  static String id = 'lista_sugerencias';

  @override
  State<ListasugerenciasScreen> createState() => _ListasugerenciasScreenState();
}

class _ListasugerenciasScreenState extends State<ListasugerenciasScreen> {
  List<Sugerencias> listasugerencias = [];

  @override
  void initState() {
    getsugerencias();
    super.initState();
  }
/*Este método obtiene la lista de sugerencias de la base de datos utilizando 
una solicitud HTTP GET a la API. Luego, decodifica la respuesta JSON y crea 
una lista de objetos Sugerencias. Finalmente, actualiza el estado de 
listasugerencias con la lista obtenida.*/
  Future<void> getsugerencias() async {
    List<Sugerencias> sugerencias = [];
    var url = Uri.parse('$baseUrl/sugerencia/listar');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      for (dynamic prestamoJson in jsonResponse) {
        Sugerencias sugerencia = Sugerencias.fromJson(prestamoJson);

        sugerencias.add(sugerencia);
        setState(() {
          listasugerencias = sugerencias;
        });
      }
      setState(() {
        listasugerencias = sugerencias;
      });
    } else if (response.statusCode == 204) {
      setState(() {
        listasugerencias = sugerencias;
      });
    } else {
      print(
          'Error en la solicitud GET lista sugerencias: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    listasugerencias.sort((b, a) => b.fecha.compareTo(a.fecha));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'COMENTARIOS Y SUGERENCIAS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
      ),
      drawer: CustomDrawer(),
      body: ListView.separated(
          itemCount: listasugerencias.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            Sugerencias sugerencia = listasugerencias[index];
            String fecha = DateFormat('dd MMM yyyy').format(sugerencia.fecha);
            String nombrePersona =
                "${sugerencia.persona.apellidos} ${sugerencia.persona.nombres}";
            return ListTile(
              title: Text(
                sugerencia.descripcion,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fecha,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    nombrePersona,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Acción al hacer clic en la sugerencia
              },
            );
          }),
    );
  }
}
