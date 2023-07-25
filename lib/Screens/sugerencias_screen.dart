import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/sugerencia.dart';
import 'package:http/http.dart' as http;

class SugerenciasScreen extends StatefulWidget {
  static String id = 'sugerencias_screen';

  @override
  State<SugerenciasScreen> createState() => _SugerenciasScreenState();
}

class _SugerenciasScreenState extends State<SugerenciasScreen> {
  TextEditingController _feedbackController = TextEditingController();
  List<Carrera> listacarreras = [];
  TextEditingController _carreracon = TextEditingController();
  Carrera? carrerita;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();

    if (rol == 'ESTUDIANTE') {
      getcarrerascedula();
    } else {
      getcarreras();
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _carreracon.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackController.text.isNotEmpty || _carreracon.text.isNotEmpty) {
      crearsugerencia();
    } else {
      Fluttertoast.showToast(
        msg: "Complete todos los campos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    }
  }

/*Busca las carreras asociadas a una cédula de un solicitante de préstamo 
  si esta tiene la función de docente  en la base de datos, se muestra todos las carreras que existen,
  pero si en la busqueda la cedula pertenece a un estudiante solo se mostrara la carrera con la que esta asociada.
  Los datos de las carreras, se almacenan en una lista llamada listacarreras.*/
  Future<void> getcarrerascedula() async {
    try {
      List<Carrera> carreras = [];
      var url = Uri.parse('$baseUrl/carrera/carreraest/${personalog.cedula}');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        Carrera carrera = Carrera.fromJson(jsonResponse);

        carreras.add(carrera);
        setState(() {
          listacarreras = carreras;
          _carreracon.text = carrera.nombre;
          carrerita = carrera;
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
      print('Error get carreras ,,$error');
    }
  }

  /*Crear una nueva sugerencia y enviarla a la base de datos mediante una solicitud POST. 
  Obtiene la descripción y fecha actual, 
  crea un mapa con los datos de la sugerencia y lo convierte a formato JSON. 
  Luego, realiza la solicitud POST y muestra un mensaje de éxito o error según el resultado. 
  Finalmente, limpia el campo de descripción para futuras sugerencias. */
  Future<void> crearsugerencia() async {
    String fecha =
        DateTime.now().add(const Duration(days: 1)).toIso8601String();

    try {
      const url = "$baseUrl/sugerencia/crear";
      print(url);
      Map data = {
        "id": 0,
        "descripcion": _feedbackController.text,
        "fecha": fecha,
        "persona": personalog.toJson(),
        "carrera": carrerita?.toJson(),
        "estado": true
      };
      print(data);
      var body = json.encode(data);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Sugerencia creada creado ${response.body}');
        print(response.body);
        Fluttertoast.showToast(
          msg: "SUGERENCIA CREADA CON EXITO",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
      } else {
        print('Error al crear el sugerencia: ${response.statusCode}');
        print('ERROR ${response.body}');
        Fluttertoast.showToast(
          msg: "Error al crear el sugerencia: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
      }
    } catch (error) {
      print("Error crear sugerencia $error");
    } finally {
      _carreracon.clear();
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios y Sugerencias'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
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
                  carrerita = suggestion;
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
            const SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Escribe tu comentario o sugerencia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
