import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';

import '../Screens/home_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: _buildDrawer(context));
  }

  Widget _buildDrawer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 120, 194, 255),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 80.0,
                  child: Image.network(
                    'http://dev2020.tecazuay.edu.ec/wp-content/uploads/2022/11/cropped-LOGO-RECTANGULAR_SIN-FONDO.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "usuario@tecazuay.edu.ec",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'cursive',
                        fontSize: 30.0),
                  ),
                ),
              ],
            )),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Lista de Libros'),
          onTap: () {
            setState(() {
              Navigator.pushNamed(context, HomeScreen.id);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Lista de Libros'),
          onTap: () {
            setState(() {
              Navigator.pushNamed(context, LlibrosScreen.id);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Lista de Libros'),
          onTap: () {
            setState(() {
              Navigator.pushNamed(context, HomeScreen.id);
            });
          },
        ),
      ],
    );
  }
}
