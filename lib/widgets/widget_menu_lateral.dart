import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/lista_sugerencias.dart';
import 'package:proyectoistateca/Screens/login_page.dart';
import 'package:proyectoistateca/Screens/notificaciones.dart';
import 'package:proyectoistateca/Screens/perfil_screen.dart';
import 'package:proyectoistateca/Screens/solicitud_libro_screen.dart';
import 'package:proyectoistateca/Screens/solicitudes_estudiantes_screen.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Screens/sugerencias_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';

import '../Screens/home_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(child: _buildDrawer(context));
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 28, 105, 183),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45.0,
                  backgroundImage: NetworkImage(foto),
                ),
                const SizedBox(height: 10.0),
                Text(
                  correo,
                  style: const TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Notificaciones',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: NotificacionesPage(),
                        backgroundColor: Colors.black12,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.notifications),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.book,
                        color: Color.fromARGB(255, 28, 105, 183)),
                    title: const Text(
                      'Lista de Libros',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, LlibrosScreen.id);
                      });
                    },
                  ),
                ),
                if (rol == "BIBLIOTECARIO" || rol == "ADMIN")
                  const SizedBox(height: 10),
                if (rol == "BIBLIOTECARIO" || rol == "ADMIN")
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.request_quote,
                          color: Color.fromARGB(255, 28, 105, 183)),
                      title: const Text(
                        'Lista de Solicitudes de libros',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(context, SolicitudesLibros.id);
                        });
                      },
                    ),
                  ),
                if (rol == "ADMIN") const SizedBox(height: 10),
                if (rol == "ADMIN")
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.app_registration,
                          color: Color.fromARGB(255, 28, 105, 183)),
                      title: const Text(
                        'Registrar Bibliotecario',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(context, SolicitudesLibros.id);
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.my_library_books_sharp,
                        color: Color.fromARGB(255, 28, 105, 183)),
                    title: const Text(
                      'Mis Solicitudes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, SolicitudesEstudiante.id);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person,
                        color: Color.fromARGB(255, 28, 105, 183)),
                    title: const Text(
                      'Mi Perfil',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, PerfilUsuario.id);
                      });
                    },
                  ),
                ),
                if (rol == "BIBLIOTECARIO" || rol == "ADMIN")
                  const SizedBox(height: 10),
                if (rol == "BIBLIOTECARIO" || rol == "ADMIN")
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.settings_suggest,
                          color: Color.fromARGB(255, 28, 105, 183)),
                      title: const Text(
                        'Ver Sugerencias',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(
                              context, ListasugerenciasScreen.id);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.comment, color: Colors.black),
              title: const Text(
                'Envíanos tus comentarios',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, SugerenciasScreen.id);
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                signOutGoogle();
                setState(() {
                  Navigator.pushNamed(context, LoginPage.id);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
