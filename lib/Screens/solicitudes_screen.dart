import 'package:flutter/material.dart';
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
  void scanQr() async {
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
    }
  }

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
      body: Center(
        child: Container(child: Text(qrValor)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: scanQr),
    );
  }
}
