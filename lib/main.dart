import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/login_page.dart';
import 'package:proyectoistateca/Screens/solicitudes_screen.dart';
import 'package:proyectoistateca/Screens/sugerencias_screen.dart';
import 'package:proyectoistateca/models/tipos_data.dart';
import 'package:proyectoistateca/widgets/SplashScreen.dart';

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

  @override
  void initState() {
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
        home: _isShowingSplashScreen ? const SplashScreen() : LlibrosScreen(),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginPage.id: (context) => const LoginPage(),
          LlibrosScreen.id: (context) => LlibrosScreen(),
          SolicitudesLibros.id: (context) => SolicitudesLibros(),
          SugerenciasScreen.id: (context) => SugerenciasScreen()
        },
      ),
    );
  }
}
