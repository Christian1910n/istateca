import 'package:flutter/material.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class LlibrosScreen extends StatefulWidget {
  static String id = 'lista_libros_screen';

  @override
  State<LlibrosScreen> createState() => _LlibrosScreenState();
}

class _LlibrosScreenState extends State<LlibrosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
    );
  }
}
