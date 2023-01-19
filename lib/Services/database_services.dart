import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/tipos.dart';

class DatabaseServices {
  static Future<Tipo> addTipo(String nombre) async {
    Map data = {
      "nombre": nombre,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseUrl + '/creartipo');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Tipo tipo = Tipo.fromMap(responseMap);

    return tipo;
  }

  static Future<List<Tipo>> getTipo() async {
    var url = Uri.parse(baseUrl + '/listartipo');
    print(url);
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    print(response.body);
    List responseList = jsonDecode(response.body);
    List<Tipo> tipos = [];
    for (Map tipoMap in responseList) {
      Tipo tipo = Tipo.fromMap(tipoMap);
      tipos.add(tipo);
    }
    return tipos;
  }

  static Future<http.Response> deleteTipo(int id) async {
    var url = Uri.parse(baseUrl + '/eliminartipo/$id');
    http.Response response = await http.delete(
      url,
      headers: headers,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> updateTipo(int id) async {
    var url = Uri.parse(baseUrl + '/update/$id');
    http.Response response = await http.put(
      url,
      headers: headers,
    );
    print(response.body);
    return response;
  }
}
