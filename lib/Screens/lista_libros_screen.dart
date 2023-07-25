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

class _LlibrosScreenState extends State<LlibrosScreen>
    with TickerProviderStateMixin {
  List<Libro>? libros;
  late TabController _tabController;
  List<Tab>? _tabs;

/* Obtiene una lista de libros desde una base de datos 
y actualiza la interfaz con las pestañas correspondientes para filtrar los libros por tipo.*/
  getLibros() async {
    libros = await Database_services_libro.getLibro();
    Provider.of<TiposData>(context, listen: false).libros = libros!;

    Set<String> uniqueTipos = libros!.map((libro) => libro.tipo.nombre).toSet();

    _tabs = [
      Tab(text: 'Todos'),
      ...uniqueTipos.map((tipo) => Tab(text: tipo)).toList(),
    ];
    _tabController = TabController(length: _tabs?.length ?? 0, vsync: this);

    setState(() {});
  }

  /*Obtiene una lista de libros con un título específico desde la base de datos 
  y actualiza la interfaz. */
  getLibrosnombre(String titulo) async {
    libros = await Database_services_libro.getLibronombre(titulo);
    Provider.of<TiposData>(context, listen: false).libros = libros!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 1,
      vsync: this,
    );
    _tabs = [
      Tab(text: 'Todos'),
    ];
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
            ),
            body: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Buscar libro",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
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
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    controller: _tabController,
                    tabs: _tabs!,
                    isScrollable: true,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTodosScreen(),
                      ..._tabs!
                          .skip(1)
                          .map((tab) => _buildTabScreen(tab.text!))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildTodosScreen() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: Provider.of<TiposData>(context).libros.length,
      itemBuilder: (context, index) {
        Libro libro = Provider.of<TiposData>(context).libros[index];
        return LibrosTile(
          libro: libro,
          tiposData: Provider.of<TiposData>(context),
        );
      },
    );
  }

  Widget _buildTabScreen(String tabText) {
    final List<Libro> librosFiltrados = Provider.of<TiposData>(context)
        .libros
        .where((libro) => libro.tipo.nombre == tabText)
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: librosFiltrados.length,
      itemBuilder: (context, index) {
        Libro libro = librosFiltrados[index];
        return LibrosTile(
          libro: libro,
          tiposData: Provider.of<TiposData>(context),
        );
      },
    );
  }
}
