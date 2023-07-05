import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/lista_sugerencias.dart';
import 'package:proyectoistateca/Screens/login_page.dart';
import 'package:proyectoistateca/Screens/perfil_screen.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Screens/sugerencias_screen.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:proyectoistateca/widgets/SplashScreen.dart';
import 'package:proyectoistateca/Screens/solicitudes_estudiantes_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Screens/regis_bibliotecario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isShowingSplashScreen = true;

  Future<void> inicializarfirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print(error);
    } finally {
      notificaciones();
    }
  }

  void notificaciones() {
    // Obtén el token de registro de FCM
    FirebaseMessaging.instance.getToken().then((token) {
      print('Token notificaciones: $token');
    });

    // Maneja la notificación inicial si la aplicación se abrió mediante una notificación
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    // Maneja las notificaciones recibidas en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      // Obtén los datos personalizados de la notificación
      final data = message.data;

      print(data);

      String mensaje =
          notification!.title.toString() + '\n' + notification.body.toString();

      // Muestra una alerta con el contenido de la notificación
      Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    });

    // Maneja las notificaciones cuando la aplicación se abre desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ...
    });
  }

  @override
  void initState() {
    inicializarfirebase();
    super.initState();

    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        _isShowingSplashScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TiposData>(
      create: (context) => TiposData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isShowingSplashScreen ? const SplashScreen() : LoginPage(),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginPage.id: (context) => const LoginPage(),
          LlibrosScreen.id: (context) => LlibrosScreen(),
          SolicitudesLibros.id: (context) => SolicitudesLibros(),
          Regisbibliotecario.id: (context) =>  Regisbibliotecario(),
          SugerenciasScreen.id: (context) => SugerenciasScreen(),
          SolicitudesEstudiante.id: (context) => SolicitudesEstudiante(),
          ListasugerenciasScreen.id: ((context) =>
              const ListasugerenciasScreen()),
          PerfilUsuario.id: (context) => const PerfilUsuario(),
        },
      ),
    );
  }
}
