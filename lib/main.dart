import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Screens/editar_usuario.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/lista_sugerencias.dart';
import 'package:proyectoistateca/Screens/login_page.dart';
import 'package:proyectoistateca/Screens/perfil_screen.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Screens/sugerencias_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:proyectoistateca/widgets/SplashScreen.dart';
import 'package:proyectoistateca/Screens/solicitudes_estudiantes_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //inicializa Firebase en la aplicación
  Future<void> inicializarfirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print(error);
    } finally {
      notificaciones();
    }
  }

  //inicializa las notificaciones locales en la aplicación.
  void initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //configura y maneja las notificaciones push en la aplicación
  void notificaciones() {
    // Obtén el token de registro de FCM
    FirebaseMessaging.instance.getToken().then((token) {
      print('Token notificaciones: $token');
      setState(() {
        tokennotificacion = token!;
      });
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      print(data);

      showNotification(
          notification!.title.toString(), notification.body.toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  // muestra una notificación local en el dispositivo
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void initState() {
    inicializarfirebase();
    initializeNotifications();
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
          Regisbibliotecario.id: (context) => Regisbibliotecario(),
          SugerenciasScreen.id: (context) => SugerenciasScreen(),
          SolicitudesEstudiante.id: (context) => SolicitudesEstudiante(),
          ListasugerenciasScreen.id: ((context) =>
              const ListasugerenciasScreen()),
          PerfilUsuario.id: (context) => const PerfilUsuario(),
          EditarUsuarioScreen.id: (context) => const EditarUsuarioScreen()
        },
      ),
    );
  }
}
