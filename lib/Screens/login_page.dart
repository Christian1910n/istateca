import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/models/persona.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInGoogle() async {
    try {
      final GoogleSignInAccount googleUser = (await _googleSignIn.signIn())!;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        user.providerData.forEach((userInfo) {
          print(userInfo);
        });
        print(user.displayName);
        setState(() {
          correo = user.email!;
          nombre = user.displayName!;
          foto = user.photoURL ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpcPxlFYJ0N5s1l3Lj5u5v2EOumwZjJ37XfTeEoaQ&s";
        });
      }
      if (user!.uid == _auth.currentUser!.uid) return user;
    } catch (e) {
      print('Error en el el Metodo: ${e.toString()}');
    } finally {
      print("hola");
      verificarCredenciales();
    }
    return null;
  }

  Future<void> verificarCredenciales() async {
    setState(() {
      _loading = true;
    });
    try {
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
            content: Text("$nombre ${response.body}"),
            duration: const Duration(seconds: 4),
          ),
        );
        signOutGoogle();
      } else {
        // Error en la solicitud
        print('Error en la solicitud');
        signOutGoogle();
      }
    } catch (error) {
      print("Error verificando $error");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No se pudo iniciar sesion $error"),
          duration: const Duration(seconds: 4),
        ),
      );
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
    if (_loading) {
      return animacioncarga();
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset('assets/logoista.png', width: 400),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        '¡Bienvenido!',
                        textStyle: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Inicia sesión con tu cuenta de Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: signInGoogle,
              icon: const Icon(Icons.login),
              label: const Text('INICIO DE SESIÓN CON GOOGLE',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
