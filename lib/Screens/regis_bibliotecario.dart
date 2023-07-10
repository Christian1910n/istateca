import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        // ignore: use_build_context_synchronously
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

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registro exitoso'),
              content: Text(
                'Registro exitoso para ${persona!.cedula} como bibliotecario.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Borrar todo el contenido
                    setState(() {
                      persona = null;
                      _searchTerm = '';
                      _searchController.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else {
        print(response);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registro exitoso'),
              content: Text(
                'Registro exitoso para ${persona!.nombres} ${persona!.apellidos} como bibliotecario.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      persona = null;
                      _searchTerm = '';
                      _searchController.clear();
                    });
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
    TextInputType keyboardType;
    List<TextInputFormatter> inputFormatters;

    if (isEditable) {
      if (title == 'Correo') {
        keyboardType = TextInputType.emailAddress;
        inputFormatters = [];
      } else if (title == 'Celular') {
        keyboardType = TextInputType.phone;
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
        ];
      } else {
        keyboardType = TextInputType.text;
        inputFormatters = [];
      }
    } else {
      keyboardType = TextInputType.text;
      inputFormatters = [];
    }

    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: 250.0,
        child: isEditable
            ? TextFormField(
                initialValue: value,
                onChanged: onChanged,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
                    keyboardType: TextInputType.number,
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
                    if (_searchTerm.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Por favor, ingrese una cédula.'),
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
                      cedula = _searchTerm;
                      searchPersona();
                      _searchController.clear();
                    }
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
