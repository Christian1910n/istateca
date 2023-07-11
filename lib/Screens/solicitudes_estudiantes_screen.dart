import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/Screens/solicitar_libro_screen.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class SolicitudesEstudiante extends StatefulWidget {
  static String id = 'soliciudes_estudiante';

  @override
  State<SolicitudesEstudiante> createState() => _SolicitudesEstudianteState();
}

class _SolicitudesEstudianteState extends State<SolicitudesEstudiante>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool carga = false;

  TextEditingController buscarsoli = TextEditingController();
  List<Prestamo> solicitudes = [];

  Future<void> getsolicitudes(String cedula) async {
    setState(() {
      carga = true;
    });
    try {
      List<Prestamo> solicitudess = [];
      var url = Uri.parse('$baseUrl/prestamo/listarxcedula?cedula=$cedula');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        for (dynamic prestamoJson in jsonResponse) {
          Prestamo prestamo = Prestamo.fromJson(prestamoJson);
          solicitudess.add(prestamo);
        }
        setState(() {
          solicitudes = solicitudess;
        });
      } else {
        print('Error en la solicitud GET: ${response.statusCode}');
      }
    } catch (error) {
      print("Error get solicitudes $error");
    } finally {
      setState(() {
        carga = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      getsolicitudes(personalog.cedula);
    });
    getsolicitudes(personalog.cedula);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitudes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Solicitadas'),
            Tab(text: 'Pendientes'),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildListView(1),
          buildListView(2),
        ],
      ),
    );
  }

  Widget buildListView(int tabId) {
    if (carga) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Prestamo> filteredSolicitudes = solicitudes
        .where((prestamo) => prestamo.estadoPrestamo == tabId)
        .toList();

    if (filteredSolicitudes.isEmpty) {
      return Center(
        child: const Text(
          'No hay solicitudes pendientes',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredSolicitudes.length,
            itemBuilder: (context, index) {
              return Card(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      validar = 1;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SolicitarLibroScreen(
                          libro: filteredSolicitudes[index].libro!,
                          idsolicitud: filteredSolicitudes[index].id_prestamo,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(filteredSolicitudes[index].libro!.titulo),
                    subtitle: filteredSolicitudes[index].estadoPrestamo == 1
                        ? null
                        : Text(
                            "Fecha entrega: ${filteredSolicitudes[index].fechaEntrega}\nFecha máxima: ${filteredSolicitudes[index].fechaMaxima}",
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
