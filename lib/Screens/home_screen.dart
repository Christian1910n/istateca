import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Screens/add_libro_Screen.dart';
import 'package:proyectoistateca/Services/database_services.dart';
import 'package:proyectoistateca/models/tipos.dart';
import 'package:proyectoistateca/models/tipos_data.dart';

import '../tipo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Tipo>? tipos;

  getTipos() async {
    tipos = await DatabaseServices.getTipo();
    Provider.of<TiposData>(context, listen: false).tipos = tipos!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTipos();
  }

  @override
  Widget build(BuildContext context) {
    return tipos == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Todo tipos (${Provider.of<TiposData>(context).tipos.length})',
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<TiposData>(builder: (context, tiposData, child) {
                return ListView.builder(
                    itemCount: tiposData.tipos.length,
                    itemBuilder: ((context, index) {
                      Tipo tipo = tiposData.tipos[index];
                      return TipoTile(
                        tipo: tipo,
                        tipoData: tiposData,
                      );
                    }));
              }),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddTipoScreen();
                    });
              },
            ),
          );
  }
}
