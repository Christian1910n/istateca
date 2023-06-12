import 'package:flutter/material.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

import '../widgets/widget_menu_lateral.dart';

class SolicitudesLibros extends StatefulWidget {
  static String id = 'solicitudes_screen';

  @override
  State<SolicitudesLibros> createState() => _SolicitudesLibrosState();
}

class _SolicitudesLibrosState extends State<SolicitudesLibros> {
  String qrValor = '';
  TextEditingController buscarsoli = TextEditingController();
  List<Libro> solicitudes = [];
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
    }
  }

  void getsolicitudesid(String value) {}

  void getsolicitudes() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Libros',
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
                return ListTile(
                  title: Text(solicitudes[index].titulo),
                  subtitle: Text(solicitudes[index].area),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
