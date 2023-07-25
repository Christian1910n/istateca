import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class BookRequestView extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const BookRequestView({Key? key, required this.prestamo}) : super(key: key);

  @override
  _BookRequestViewState createState() => _BookRequestViewState();
}

class _BookRequestViewState extends State<BookRequestView> {
  late Prestamo prestamo;
  List<Carrera> listacarreras = [];
  final TextEditingController _carreracon = TextEditingController();

  /*Busca las carreras asociadas a una cédula de un solicitante de préstamo 
  si esta tiene la función de docente  en la base de datos, se muestra todos las carreras que existen,
  pero si en la busqueda la cedula pertenece a un estudiante solo se mostrara la carrera con la que esta asociada.
  Los datos de las carreras, se almacenan en una lista llamada listacarreras.*/
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
      print('Error get carreras $error');
    }
  }

  /*Busca y obtiene una lista de todas las carreras disponibles en la base de datos. 
  Los datos de las carreras se almacenan en la lista listacarreras */
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
      print('Error get carreras $error');
    }
  }

  /* Calcula una fecha futura, sin incluir los fines de semana, a partir de la fecha actual 
  y un número de días proporcionado como parámetro.*/
  DateTime getFutureDateWithoutWeekends(int days) {
    final DateTime currentDate = DateTime.now();
    int count = 0;
    DateTime futureDate = currentDate;

    while (count < days) {
      futureDate = futureDate.add(const Duration(days: 1));

      // Si es sábado o domingo, no se cuenta como día adicional
      if (futureDate.weekday == DateTime.saturday ||
          futureDate.weekday == DateTime.sunday) {
        continue;
      }

      count++;
    }

    return futureDate;
  }

  DateTime _selectedDate = DateTime.now();

  /*Modifica un préstamo existente. 
  Se crea un mapa con los datos actualizados del préstamo y se convierte a formato JSON. 
  Luego, se realiza una solicitud PUT a la base de datos con los datos actualizados. 
  Si la solicitud es exitosa, se muestra un mensaje de éxito y se navega a otra página */
  Future<void> modificarprestamo() async {
    if (prestamo.documentoHabilitante == 0 || prestamo.carrera == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, complete todos los campos requeridos.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Devuelve la función sin guardar los cambios
    }

    Map data = {
      "estadoPrestamo": 2,
      "idEntrega": {"id": personalog.id_persona},
      "documentoHabilitante": prestamo.documentoHabilitante,
      "tipoPrestamo": prestamo.tipoPrestamo,
      "fechaMaxima":
          _selectedDate.add(const Duration(days: 1)).toIso8601String(),
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

  /* Rechaza un préstamo existente. 
  Se crea un mapa con el estado de préstamo actualizado con el id del prestamo que seria 7
  se convierte a formato JSON. 
  Luego, se realiza una solicitud PUT a la base de datos para actualizar el estado del préstamo. 
  Si la solicitud es exitosa, se muestra un mensaje de éxito mediante un toast y se navega a otra página*/
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

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('N° Solicitud: ${prestamo.id_prestamo}'),
              Text(
                  'Nombre Solicitante: ${prestamo.idSolicitante!.nombres} ${prestamo.idSolicitante!.apellidos}'),
              Text('Título del Libro: ${prestamo.libro!.titulo}'),
              Text('Carrera: ${prestamo.carrera!.nombre}'),
              Text(
                  'Documento Habilitante: ${getDocumentName(prestamo.documentoHabilitante)}'),
              Text(
                  'Fecha Máxima de Devolución: ${_selectedDate.toIso8601String().substring(0, 10)}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop();
                modificarprestamo();
              },
            ),
          ],
        );
      },
    );
  }

  String getDocumentName(int? documentType) {
    switch (documentType) {
      case 1:
        return 'Cédula';
      case 2:
        return 'Pasaporte';
      case 3:
        return 'Licencia de Conducir';
      default:
        return 'Desconocido';
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
      setState(() {
        prestamo = widget.prestamo;
        _selectedDate = getFutureDateWithoutWeekends(5);
        prestamo.carrera =
            null; // Establecer el valor predeterminado de la carrera como null
      });
    });

    print(widget.prestamo.libro!.titulo);
    if (prestamo.carrera != null) {
      print(prestamo.carrera!.nombre);
    } else {
      print('Carrera no seleccionada');
    }
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  'Nombre de la Persona que Entrega: ${personalog.nombres} ${personalog.apellidos}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                TypeAheadFormField<Carrera>(
                  enabled: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: const InputDecoration(
                      labelText: 'Carrera',
                      labelStyle: TextStyle(color: Colors.black),
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
                      title: Text(suggestion.nombre),
                    );
                  },
                  onSuggestionSelected: (Carrera suggestion) {
                    setState(() {
                      prestamo.carrera = suggestion;
                      _carreracon.text = suggestion.nombre;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione una carrera';
                    }
                    return null;
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
                    setState(() {
                      prestamo.documentoHabilitante = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Documento Habilitante',
                  ),
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'Seleccione un documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Fecha Limite de Devolucion:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Calificación del Usuario:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                RatingBarIndicator(
                  rating:
                      widget.prestamo.idSolicitante!.calificacion.toDouble(),
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
                        if (prestamo.documentoHabilitante != 0 &&
                            prestamo.carrera != null) {
                          showConfirmationDialog();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Por favor, complete todos los campos requeridos.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
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
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmación'),
                              content: Text(
                                  '¿Estás seguro de que deseas rechazar el préstamo?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    rechazarprestamo();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Rechazar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
