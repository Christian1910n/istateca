import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/libros.dart';

class Database_services_libro {
  static Future<List<Libro>> getLibro() async {
    var url = Uri.parse(baseUrl + '/libro/listar');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    List responseList = jsonDecode(response.body);
    List<Libro> libros = [];

    for (var item in responseList) {
      libros.add(Libro.fromJson(item));
    }

    return libros;
  }

  static Future<List<Libro>> getLibronombre(String titulo) async {
    try {
      var url =
          Uri.parse(baseUrl + '/libro/buscarxcoincidencia?parametro=$titulo');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      print(response.statusCode);
      List responseList = jsonDecode(response.body);
      List<Libro> libros = [];
      for (var item in responseList) {
        libros.add(Libro.fromJson(item));
      }
      return libros;
    } catch (error) {
      print("error $error");
    }
    return List.empty();
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
