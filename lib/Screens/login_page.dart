import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/models/persona.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _loading = false;

  Future<void> _handleSignIn() async {
    try {
      var response = await _googleSignIn.signIn();
      setState(() {
        correo = response!.email;
        nombre = response.displayName!;
        foto = response.photoUrl ??
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpcPxlFYJ0N5s1l3Lj5u5v2EOumwZjJ37XfTeEoaQ&s";
      });
      print(response?.displayName);
      print(response?.email);
    } catch (error) {
      print(error);
    } finally {
      verificarCredenciales();
    }
  }

  Future<void> verificarCredenciales() async {
    var url = Uri.parse('$baseUrl/credentials');
    var response = await http.post(
      url,
      body: {
        'email': correo,
        'nombres': nombre,
      },
    );

    if (response.statusCode == 200) {
      // Persona registrada
      print('Persona registrada ${response.body}');
      login();
    } else if (response.statusCode == 400) {
      // No estás ligado al ISTA o ya saliste del ISTA
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          duration: const Duration(seconds: 4),
        ),
      );
      signOutGoogle();
    } else {
      // Error en la solicitud
      print('Error en la solicitud');
      signOutGoogle();
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> login() async {
    setState(() {
      _loading = true;
    });
    try {
      final auth =
          'Basic ${base64Encode(utf8.encode('$correo:$nombre$correo'))}';

      const url = '$baseUrl/ingresar';
      final response =
          await http.get(Uri.parse(url), headers: {'Authorization': auth});

      if (response.statusCode == 200) {
        final token = response.headers['authorization'];
        print('Token de acceso: $token');
        tokenacceso = token!;

        final jsons = json.decode(response.body);
        setState(() {
          personalog = Persona.fromJson(jsons);
        });

        final cookie = response.headers['set-cookie'];

        print('La cookie es: $cookie');

        final decodedToken = JwtDecoder.decode(token);
        final authorities = decodedToken['authorities'];
        print("El rol es $authorities");
        if (authorities == 'ROLE_STUD') {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, HomeScreen.id);
        } else if (authorities == 'ROLE_BIBL') {
          print('TUTOR ESPECIFICO');
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, HomeScreen.id);
        }
      } else {
        print('Error login: ${response.statusCode}');
      }

      print(response.body);
    } catch (error) {
      print('Error Login $error');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
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
