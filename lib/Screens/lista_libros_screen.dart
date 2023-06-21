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
  String _selectedEstado = 'Todos';

  getLibros() async {
    libros = await Database_services_libro.getLibro();
    Provider.of<TiposData>(context, listen: false).libros = libros!;

    // Obtener los tipos de libros únicos
    Set<String> uniqueTipos = libros!.map((libro) => libro.tipo.nombre).toSet();

    // Actualizar la lista de pestañas
    _tabs = [
      Tab(text: 'Todos'),
      ...uniqueTipos.map((tipo) => Tab(text: tipo)).toList(),
    ];

    // Actualizar el TabController con el nuevo número de pestañas
    _tabController = TabController(length: _tabs?.length ?? 0, vsync: this);

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
    _tabController = TabController(
      length: 1,
      vsync: this,
    ); // Inicialmente, solo hay una pestaña "Todos"
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
                Container(
                  color: Colors.blue, // Color de fondo azul para el TabBar
                  child: TabBar(
                    controller: _tabController,
                    tabs: _tabs!,
                    isScrollable: true, // Habilitar desplazamiento horizontal
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Mantenga presionado para obtener una vista previa del libro',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
    return ListView.builder(
      itemCount: Provider.of<TiposData>(context)?.libros.length ?? 0,
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

    return ListView.builder(
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
