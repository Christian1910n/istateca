import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/models/persona.dart';

class EditarUsuarioScreen extends StatefulWidget {
  static String id = 'editar_usuario';

  const EditarUsuarioScreen({super.key});

  @override
  State<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();

  Future<void> editarpersona() async {
    if (_direccionController.text != "" && _celularController.text != "") {
      Map data = {
        "direccion": _direccionController.text,
        "celular": _celularController.text
      };
      var body = json.encode(data);
      print("Nuevo Json: $body");

      try {
        var url = "$baseUrl/persona/editar/${personalog.id_persona}";
        print(url);

        final response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: body,
        );
        if (response.statusCode == 200) {
          print('Persona modificada ${response.body}');
          Fluttertoast.showToast(
            msg: "DATOS GUARDADOS CORRECTAMENTE",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.grey[700],
            textColor: Colors.white,
          );
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          setState(() {
            personalog = Persona.fromJson(jsonResponse);
          });
        } else {
          print('Error al editar persona: ${response.statusCode}');
          print('ERROR ${response.body}');
        }
      } catch (error) {
        print("Error editar persona $error");
      } finally {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LlibrosScreen()),
        );
      }
    } else {
      const snackbar = SnackBar(
        content: Text('COMPLETE TODOS LOS CAMPOS'),
        duration: Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    _nombresController.text = "${personalog.nombres} ${personalog.apellidos}";
    _cedulaController.text = personalog.cedula;
    _correoController.text = personalog.correo;
    if (personalog.celular == "null") {
      _celularController.text = "";
    } else {
      _celularController.text = personalog.celular;
    }

    if (personalog.direccion == "null") {
      _direccionController.text = "";
    } else {
      _direccionController.text = personalog.direccion;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _cedulaController.dispose();
    _correoController.dispose();
    _celularController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: _nombresController,
              decoration: const InputDecoration(
                labelText: 'Nombres',
              ),
            ),
            TextFormField(
              readOnly: true,
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula',
              ),
            ),
            TextFormField(
              readOnly: true,
              controller: _correoController,
              decoration: const InputDecoration(
                labelText: 'Correo',
              ),
            ),
            TextFormField(
              controller: _celularController,
              decoration: const InputDecoration(
                labelText: 'Celular',
              ),
            ),
            TextFormField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_celularController.text.length == 10 &&
                    _direccionController.text != "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmación'),
                        content:
                            const Text('¿Estás seguro de guardar los datos?'),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el cuadro de diálogo
                            },
                          ),
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              editarpersona();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('DATOS INVALIDOS'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
