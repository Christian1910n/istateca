import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/persona.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class BookRequestView extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const BookRequestView({super.key, required this.prestamo});

  @override
  _BookRequestViewState createState() => _BookRequestViewState();
}

class _BookRequestViewState extends State<BookRequestView> {
  late Prestamo prestamo;
  List<Carrera> listacarreras = [];
  final TextEditingController _carreracon = TextEditingController();

  Future<void> getcarrerascedula() async {
    try {
      List<Carrera> carreras = [];
      var url = Uri.parse(
          '$baseUrl/carrera/carreraest/${widget.prestamo.idSolicitante!.cedula}');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        Carrera carrera = Carrera.fromJson(jsonResponse);

        carreras.add(carrera);
        setState(() {
          listacarreras = carreras;
          _carreracon.text = carrera.nombre;
          prestamo.carrera = carrera;
        });

        setState(() {
          listacarreras = carreras;
        });
      } else {
        print(
            'Error en la solicitud GET lista carreras: ${response.statusCode}');
      }
    } catch (error) {
      print("Error get carreras $error");
    }
  }

  Future<void> getcarreras() async {
    try {
      List<Carrera> carreras = [];
      var url = Uri.parse('$baseUrl/carrera/listar');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        for (dynamic Json in jsonResponse) {
          Carrera carrera = Carrera.fromJson(Json);

          carreras.add(carrera);
          setState(() {
            listacarreras = carreras;
          });
        }
        setState(() {
          listacarreras = carreras;
        });
      } else {
        print(
            'Error en la solicitud GET lista carreras: ${response.statusCode}');
      }
    } catch (error) {
      print("Error get carreras $error");
    }
  }

  DateTime _selectedDate = DateTime.now();
  Future<void> modificarprestamo() async {
    Map data = {
      "estadoPrestamo": 2,
      "idEntrega": {"id": personalog.id_persona},
      "documentoHabilitante": prestamo.documentoHabilitante,
      "tipoPrestamo": prestamo.tipoPrestamo,
      "fechaMaxima": prestamo.fechaMaxima,
      "carrera": {"id": prestamo.carrera!.id_carrera}
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/prestamo/editar/${widget.prestamo.id_prestamo}";
      print(url);

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Prestamo modificado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
      } else {
        print('Error al editar el prestamo: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error editar prestamo $error");
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SolicitudesLibros()),
      );
    }
  }

  Future<void> rechazarprestamo() async {
    Map data = {
      "estadoPrestamo": 7,
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/prestamo/editar/${widget.prestamo.id_prestamo}";
      print(url);

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Prestamo modificado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
        Fluttertoast.showToast(
          msg: "PRESTAMO RECHAZADO",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
      } else {
        print('Error al editar el prestamo: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error editar prestamo $error");
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SolicitudesLibros()),
      );
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        prestamo.fechaMaxima = picked.add(const Duration(days: 1)).toString();
      });
    }
  }

  @override
  void initState() {
    if (widget.prestamo.tipoPrestamo == 1) {
      getcarrerascedula();
    } else {
      getcarreras();
    }
    setState(() {
      prestamo = widget.prestamo;
    });

    print(widget.prestamo.libro!.titulo);
    print(prestamo.carrera!.nombre);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SolicitudesLibros()),
          );

          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Formulario de Solicitudes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre Solicitante: ${prestamo.idSolicitante!.nombres} ${prestamo.idSolicitante!.apellidos}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Título del Libro: ${prestamo.libro!.titulo}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Fecha de Solicitud: ${prestamo.fechaFin}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Nombre de la Persona que Entrega: ${personalog.nombres}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16.0),
                    TypeAheadFormField<Carrera>(
                      enabled: true,
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: const InputDecoration(
                          labelText: 'Carrera',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(color: Colors.black),
                        controller: _carreracon,
                      ),
                      suggestionsCallback: (pattern) async {
                        return listacarreras
                            .where((carrera) => carrera.nombre
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, Carrera suggestion) {
                        return ListTile(
                            title: Text(
                          suggestion.nombre,
                        ));
                      },
                      onSuggestionSelected: (Carrera suggestion) {
                        setState(() {
                          prestamo.carrera = suggestion;
                          _carreracon.text = suggestion.nombre;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      value: prestamo.documentoHabilitante,
                      items: const [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text('Seleccione:'),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Cédula'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Pasaporte'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('Licencia de Conducir'),
                        ),
                      ],
                      onChanged: (value) {
                        prestamo.documentoHabilitante = value!;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Documento Habilitante'),
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: const Text('Fecha Maxima de Devolución'),
                      subtitle: Text(
                          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectDate,
                    ),
                    const Text(
                      'Calificación del Usuario:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    RatingBarIndicator(
                      rating: personalog.calificacion.toDouble(),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 40.0,
                      unratedColor: Colors.grey,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            modificarprestamo();
                          },
                          child: const Text('Guardar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            rechazarprestamo();
                          },
                          child: const Text('Rechazar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
