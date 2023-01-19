import 'package:flutter/material.dart';
import 'package:proyectoistateca/models/tipos_data.dart';

import 'models/tipos.dart';

class TipoTile extends StatelessWidget {
  final Tipo tipo;
  final TiposData tipoData;

  const TipoTile({Key? key, required this.tipo, required this.tipoData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tipo.nombre),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            tipoData.deleteTipo(tipo);
          },
        ),
      ),
    );
  }
}
