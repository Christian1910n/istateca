import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/libros.dart';

class Database_services_libro {
  static Future<List<Libro>> getLibro() async {
    var url = Uri.parse(baseUrl + '/listarlibros');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    List responseList = jsonDecode(response.body);
    List<Libro> libros = [];
    for (Map tipoMap in responseList) {
      Libro tipo = Libro.fromMap(tipoMap);
      libros.add(tipo);
    }
    return libros;
  }

  static Future<List<Libro>> getLibronombre(String titulo) async {
    var url = Uri.parse(baseUrl + '/listarlibrosxnombre/$titulo');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    List responseList = jsonDecode(response.body);
    List<Libro> libros = [];
    for (Map tipoMap in responseList) {
      Libro tipo = Libro.fromMap(tipoMap);
      libros.add(tipo);
    }
    return libros;
  }

  static Future<http.Response> updateLibro(int id) async {
    var url = Uri.parse(baseUrl + '/editarlibros/$id');
    http.Response response = await http.put(
      url,
      headers: headers,
    );
    return response;
  }
}
