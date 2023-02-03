import 'package:flutter/cupertino.dart';
import 'package:proyectoistateca/Services/database_services.dart';
import 'package:proyectoistateca/Services/database_services_libro.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/tipos.dart';

class TiposData extends ChangeNotifier {
  List<Tipo> tipos = [];

  void addTipo(String nombretipo) async {
    Tipo tipo = await DatabaseServices.addTipo(nombretipo);
    tipos.add(tipo);
    notifyListeners();
  }

  void updateTipo(Tipo tipo) {
    DatabaseServices.updateTipo(tipo.id_tipo);
    notifyListeners();
  }

  void deleteTipo(Tipo tipo) {
    tipos.remove(tipo);
    DatabaseServices.deleteTipo(tipo.id_tipo);
    notifyListeners();
  }

  List<Libro> libros = [];

  void updateLibro(Libro libro) {
    Database_services_libro.updateLibro(libro.id_libro);
    notifyListeners();
  }
}
