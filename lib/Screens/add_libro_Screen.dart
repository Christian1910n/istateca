import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/models/tipos_data.dart';

class AddTipoScreen extends StatefulWidget {
  @override
  State<AddTipoScreen> createState() => _AddTipoScreenState();
}

class _AddTipoScreenState extends State<AddTipoScreen> {
  String nombreTipo = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Añadir Tipo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.green,
              ),
            ),
            TextField(
              autofocus: true,
              onChanged: (val) {
                nombreTipo = val;
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                if (nombreTipo.isNotEmpty) {
                  Provider.of<TiposData>(context, listen: false)
                      .addTipo(nombreTipo);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.green),
            )
          ],
        ));
  }
}
