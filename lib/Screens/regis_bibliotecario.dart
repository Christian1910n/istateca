import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:proyectoistateca/Services/globals.dart';
import '../models/persona.dart';

class Regisbibliotecario extends StatefulWidget {
  static String id = 'regis_bibliotecario';

  @override
  State<Regisbibliotecario> createState() => _RegisbibliotecarioState();
}

class _RegisbibliotecarioState extends State<Regisbibliotecario> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String cedula = '';
  Persona? persona;
  bool isLoading = false;

  Future<void> searchPersona() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('$baseUrl/persona/personadocente/$cedula'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null) {
        setState(() {
          persona = Persona.fromJson(data);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'No se encontró ninguna persona con la cédula ingresada.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Solo los profesores pueden ser bibliotecarios.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void registrarComoBibliotecario() async {
    if (persona != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/persona/registrardocenteadmin?rol=ROLE_BLIB'),
        headers: headers,
        body: json.encode(persona),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registro exitoso'),
              content: Text(
                  'Registro exitoso para ${persona!.cedula} como bibliotecario.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
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
              content: const Text('Ocurrió un error al realizar el registro.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget buildEditableTile(
    String title,
    String value,
    void Function(String) onChanged,
  ) {
    bool isEditable = title != 'Cédula';

    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: 250.0,
        child: isEditable
            ? TextFormField(
                initialValue: value,
                onChanged: onChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              )
            : Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de bibliotecario'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Ingrese la Cédula del docente',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    cedula = _searchTerm;
                    searchPersona();
                    _searchController.clear();
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            if (isLoading)
              const CircularProgressIndicator()
            else if (persona != null)
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Align(
                        alignment: Alignment.center,
                        child: Text('Cédula'),
                      ),
                      subtitle: Align(
                        alignment: Alignment.center,
                        child: Text(persona!.cedula),
                      ),
                    ),
                    buildEditableTile(
                      'Nombres',
                      persona!.nombres,
                      (value) {
                        setState(() {
                          persona!.nombres = value;
                        });
                      },
                    ),
                    buildEditableTile(
                      'Apellidos',
                      persona!.apellidos,
                      (value) {
                        setState(() {
                          persona!.apellidos = value;
                        });
                      },
                    ),
                    buildEditableTile(
                      'Correo',
                      persona!.correo,
                      (value) {
                        setState(() {
                          persona!.correo = value;
                        });
                      },
                    ),
                    buildEditableTile(
                      'Dirección',
                      persona!.direccion,
                      (value) {
                        setState(() {
                          persona!.direccion = value;
                        });
                      },
                    ),
                    buildEditableTile(
                      'Celular',
                      persona!.celular,
                      (value) {
                        setState(() {
                          persona!.celular = value;
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              const Text('Cédula no encontrada'),
            if (persona != null)
              ElevatedButton(
                onPressed: () {
                  registrarComoBibliotecario();
                },
                child: const Text('Registrar como bibliotecario'),
              ),
          ],
        ),
      ),
    );
  }
}
