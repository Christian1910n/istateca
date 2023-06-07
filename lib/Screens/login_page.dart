import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.add,
      ),
      onPressed: () {
        setState(() {
          Navigator.pushNamed(context, LlibrosScreen.id);
        });
      },
    ));
  }
}
