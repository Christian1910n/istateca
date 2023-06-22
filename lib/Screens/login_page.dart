import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoistateca/Services/globals.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn() async {
    try {
      var response = await _googleSignIn.signIn();
      setState(() {
        correo = response!.email;
        foto = response.photoUrl ??
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpcPxlFYJ0N5s1l3Lj5u5v2EOumwZjJ37XfTeEoaQ&s";
      });
      print(response?.displayName);
      print(response?.email);

      Navigator.pushNamed(context, HomeScreen.id);
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: Text('Iniciar sesión con Google'),
        ),
      ),
    );
  }
}
