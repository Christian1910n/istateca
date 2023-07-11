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
      print("Persona nueva ${data}");
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
      Map data = {
        "fenixId": persona?.fenixId,
        "cedula": persona?.cedula,
        "correo": persona?.correo,
        "nombres": persona?.nombres,
        "apellidos": persona?.apellidos,
        "direccion": persona?.direccion,
        "tipo": 3,
        "celular": persona?.celular,
        "calificacion": persona?.calificacion,
        "activo": persona?.activo,
        "device": persona?.device
      };
      var body;
      if (persona?.id_persona == 0) {
        body = json.encode(data);
      } else {
        body = json.encode(persona);
      }

      final response = await http.post(
        Uri.parse('$baseUrl/persona/registrardocenteadmin?rol=ROLE_BLIB'),
        headers: headers,
        body: body,
      );

      print("nuevo json $body");

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
      } else {
        print("Error registro bibliotecario ${response.statusCode}");
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registro Error'),
              content: Text(
                'Ocurrio un error para registro como bibliotecario. ${response.statusCode}',
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
    bool isEditable,
  ) {
    return ListTile(
      trailing: SizedBox(
          child: Container(
              constraints: BoxConstraints(maxWidth: 315.0),
              child: TextFormField(
                initialValue: value,
                onChanged: onChanged,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                readOnly: isEditable,
                decoration: InputDecoration(
                  labelText: title,
                  border: OutlineInputBorder(),
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de bibliotecario'),
      ),
      body: SingleChildScrollView(
        // Envolver con SingleChildScrollView
        child: Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 10),
                    buildEditableTile('Nombres', persona!.nombres, (value) {
                      setState(() {
                        persona!.nombres = value;
                      });
                    }, true),
                    const SizedBox(height: 10),
                    buildEditableTile('Apellidos', persona!.apellidos, (value) {
                      setState(() {
                        persona!.apellidos = value;
                      });
                    }, true),
                    const SizedBox(height: 10),
                    buildEditableTile(
                      'Correo',
                      persona!.correo == "null" ? "" : persona!.correo,
                      (value) {
                        setState(() {
                          persona!.correo = value;
                        });
                      },
                      false,
                    ),
                    const SizedBox(height: 10),
                    buildEditableTile(
                      'Dirección',
                      persona!.direccion == "null" ? "" : persona!.direccion,
                      (value) {
                        setState(() {
                          persona!.direccion = value;
                        });
                      },
                      false,
                    ),
                    const SizedBox(height: 10),
                    buildEditableTile(
                      'Celular',
                      persona!.celular == "null" ? "" : persona!.celular,
                      (value) {
                        setState(() {
                          persona!.celular = value;
                        });
                      },
                      false,
                    ),
                    const SizedBox(height: 20),
                    if (persona!.id_persona != null && persona!.tipo == 3)
                      const Text("Persona ya registrada como bibliotecario"),
                    if (persona!.tipo != 3)
                      ElevatedButton(
                        onPressed: () {
                          if (persona!.celular.length == 10 &&
                              persona!.direccion != "") {
                            if (persona!.correo.endsWith("@tecazuay.edu.ec")) {
                              registrarComoBibliotecario();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'CORREO NO PERTENECE AL ISTA'),
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
                        child: const Text('Registrar como bibliotecario'),
                      ),
                  ],
                )
              else
                const Text('Cédula no encontrada'),
            ],
          ),
        ),
      ),
    );
  }
}
