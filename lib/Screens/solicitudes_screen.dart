import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/solicitud_libro_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../widgets/widget_menu_lateral.dart';

class SolicitudesLibros extends StatefulWidget {
  static String id = 'solicitudes_screen';

  @override
  State<SolicitudesLibros> createState() => _SolicitudesLibrosState();
}

class _SolicitudesLibrosState extends State<SolicitudesLibros>
    with SingleTickerProviderStateMixin {
  String qrValor = '';
  late TabController _tabController;
  bool carga = false;

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
    setState(() {
      carga = true;
    });
    try {
      final PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          qrValor = cameraScanResult!;
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
            prestamo = prestamos;
          });
        } else {
          print('Error en la solicitud GET id: ${response.statusCode}');
        }
      } catch (error) {
        print("Error get solicitudes por id: $error");
      } finally {
        setState(() {
          carga = false;
        });
        if (prestamo.id_prestamo != 0) {
          if (prestamo.estadoPrestamo == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookRequestView(prestamo: prestamo),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('No se encontro una solicitud con el id $qrValor'),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        } else {
          getsolicitudes(1);
        }
      }
    }
  }

  Future<void> getsolicitudesid(String value) async {
    setState(() {
      carga = true;
    });
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

  Future<void> getsolicitudes(int estado) async {
    setState(() {
      carga = true;
    });
    try {
      List<Prestamo> solicitudess = [];
      var url = Uri.parse('$baseUrl/prestamo/listarxestado?parametro=$estado');
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
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      getsolicitudes(_tabController.index + 1);
    });
    getsolicitudes(1);
    super.initState();
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
          'Lista de Solicitudes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Solicitado'),
            Tab(text: 'Prestado'),
            Tab(text: 'Recibido'),
            Tab(text: 'Destruido'),
            Tab(text: 'No devuelto'),
            Tab(text: 'Restituido'),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildListView(1),
          buildListView(2),
          buildListView(3),
          buildListView(4),
          buildListView(5),
          buildListView(6),
        ],
      ),
    );
  }

  Widget buildListView(int tabId) {
    if (carga) {
      return animacioncarga();
    }

    return Column(
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
                      getsolicitudes(tabId);
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
                    if (solicitudes[index].estadoPrestamo == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookRequestView(prestamo: solicitudes[index]),
                        ),
                      );
                    }
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
                      title: Text(solicitudes[index].libro!.titulo),
                      subtitle: Text(
                          "${solicitudes[index].idSolicitante!.nombres} ${solicitudes[index].idSolicitante!.apellidos}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              if (solicitudes[index].estadoPrestamo == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookRequestView(
                                        prestamo: solicitudes[index]),
                                  ),
                                );
                              }
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
    );
  }
}
