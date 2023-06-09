import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Services/database_services_libro.dart';
import 'package:proyectoistateca/libro_tile.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class LlibrosScreen extends StatefulWidget {
  static String id = 'lista_libros_screen';

  @override
  State<LlibrosScreen> createState() => _LlibrosScreenState();
}

class _LlibrosScreenState extends State<LlibrosScreen> with SingleTickerProviderStateMixin {
  List<Libro>? libros;
  late TabController _tabController;
  List<Tab> _tabs = [
    Tab(text: 'Todos'),
    Tab(text: 'Aventura'),
    Tab(text: 'Historia'),
    Tab(text: 'Fantacia'),
  ];
  String _selectedEstado = 'Todos';

  getLibros() async {
    libros = await Database_services_libro.getLibro();
    Provider.of<TiposData>(context, listen: false).libros = libros!;
    setState(() {});
  }

  getLibrosnombre(String titulo) async {
    libros = await Database_services_libro.getLibronombre(titulo);
    Provider.of<TiposData>(context, listen: false).libros = libros!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    getLibros();
  }

  @override
  Widget build(BuildContext context) {
    return libros == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text(
                'Lista de Libros',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Mantenga presionado para obtener una vista previa del libro',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Buscar libro",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      getLibrosnombre(value);
                    } else {
                      getLibros();
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: Provider.of<TiposData>(context).libros.length,
                    itemBuilder: (context, index) {
                      Libro libro = Provider.of<TiposData>(context).libros[index];
                      return LibrosTile(
                        libro: libro,
                        tiposData: Provider.of<TiposData>(context),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: TabBarView(
              controller: _tabController,
              children: [
                _buildTodosScreen(),
                _buildPendientesScreen(),
                _buildAprobadosScreen(),
                _buildRechazadosScreen(),
              ],
            ),
          );
  }

  Widget _buildTodosScreen() {
    return Container();
  }

  Widget _buildPendientesScreen() {
    return Container();
  }

  Widget _buildAprobadosScreen() {
    return Container();
  }

  Widget _buildRechazadosScreen() {
    return Container();
  }
}
