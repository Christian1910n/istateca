import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitud_libro_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../widgets/widget_menu_lateral.dart';

class SolicitudesLibros extends StatefulWidget {
  static String id = 'solicitudes_screen';

  @override
  State<SolicitudesLibros> createState() => _SolicitudesLibrosState();
}

class _SolicitudesLibrosState extends State<SolicitudesLibros> {
  String qrValor = '';
  TextEditingController buscarsoli = TextEditingController();
  List<Prestamo> solicitudes = [];
  Prestamo prestamo = Prestamo(
      id_prestamo: 0,
      fechaFin: "fechaFin",
      estadoLibro: 1,
      estadoPrestamo: 1,
      fechaEntrega: "fechaEntrega",
      documentoHabilitante: 1,
      fechaDevolucion: "",
      fechaMaxima: "fechaMaxima",
      activo: true,
      escaneoMatriz: "null",
      tipoPrestamo: 1,
      idSolicitante: null,
      carrera: null,
      libro: null);

  void scanQr() async {
    try {
      final PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          qrValor = cameraScanResult!;
          buscarsoli.text = cameraScanResult;
        });
      } else {
        print("no hay permiso f");
      }
      /* */
    } catch (error) {
      print('Error al leer el QR Error: $error');
    } finally {
      try {
        List<Prestamo> solicitudess = [];
        var url = Uri.parse('$baseUrl/prestamo/buscar/$qrValor');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          print(response.body);
          Prestamo prestamos = Prestamo.fromJson(jsonResponse);
          solicitudess.add(prestamos);
          setState(() {
            solicitudes = solicitudess;
            prestamo = prestamos;
          });
        } else {
          print('Error en la solicitud GET id: ${response.statusCode}');
        }
      } catch (error) {
        print("Error get solicitudes por id: $error");
      } finally {
        if (prestamo.id_prestamo != 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookRequestView(prestamo: prestamo),
            ),
          );
        } else {
          getsolicitudes();
        }
      }
    }
  }

  Future<void> getsolicitudesid(String value) async {
    try {
      List<Prestamo> solicitudess = [];
      var url = Uri.parse('$baseUrl/prestamo/buscar/$value');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
        solicitudess.add(prestamo);
        setState(() {
          solicitudes = solicitudess;
        });
      } else {
        print('Error en la solicitud GET id: ${response.statusCode}');
      }
    } catch (error) {
      print("Error get solicitudes por id: $error");
    }
  }

  Future<void> getsolicitudes() async {
    try {
      List<Prestamo> solicitudess = [];
      var url = Uri.parse('$baseUrl/prestamo/listar');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        for (dynamic prestamoJson in jsonResponse) {
          Prestamo prestamo = Prestamo.fromJson(prestamoJson);

          solicitudess.add(prestamo);
          setState(() {
            solicitudes = solicitudess;
          });
        }
      } else {
        print('Error en la solicitud GET: ${response.statusCode}');
      }
    } catch (error) {
      print("Error get solicitudes $error");
    }
  }

  @override
  void initState() {
    getsolicitudes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Solicitudes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: buscarsoli,
                    decoration: const InputDecoration(
                      hintText: "Buscar Solicitud",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        getsolicitudesid(value);
                      } else {
                        getsolicitudes();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: scanQr,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookRequestView(prestamo: solicitudes[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(24, 98, 173, 1.0),
                          width: 2.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // Radio de borde
                      ),
                      child: ListTile(
                        title: Text(solicitudes[index].libro!.titulo),
                        subtitle: Text(
                            "${solicitudes[index].idSolicitante!.nombres} ${solicitudes[index].idSolicitante!.apellidos}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookRequestView(
                                        prestamo: solicitudes[index]),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
