import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/login_page.dart';
import 'package:proyectoistateca/Screens/menu_lateral.dart';
import 'package:proyectoistateca/models/tipos_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TiposData>(
      create: (context) => TiposData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginPage.id: (context) => LoginPage(),
          MenuLateralScreen.id: (context) => MenuLateralScreen(),
          LlibrosScreen.id: (context) => LlibrosScreen(),
        },
      ),
    );
  }
}
