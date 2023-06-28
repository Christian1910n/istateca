import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:http/http.dart' as http;

class SugerenciasScreen extends StatefulWidget {
  static String id = 'sugerencias_screen';

  @override
  State<SugerenciasScreen> createState() => _SugerenciasScreenState();
}

class _SugerenciasScreenState extends State<SugerenciasScreen> {
  TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    crearsugerencia();
  }

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
        "persona": personalog.toJson()
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
