import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoistateca/Screens/editar_usuario.dart';
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

  /*Realiza la autenticación del usuario utilizando Google Sign-In y Firebase Authentication. 
  Se obtienen las credenciales de autenticación de Google 
  y se utilizan para realizar la autenticación con Firebase. 
  Si la autenticación es exitosa, 
  se obtiene información del usuario como el nombre, correo electrónico y foto de perfil. 
  Al finalizar, se devuelve el objeto User si la autenticación es exitosa, 
  y se llama a un método para verificar las credenciales.*/
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
      verificarCredenciales();
    }
    return null;
  }

  /*Se envía una solicitud HTTP POST con el correo electrónico y nombre del usuario. 
  Si la respuesta es exitosa, se muestra un mensaje indicando que el usuario está registrado 
  y se llama a un método de inicio de sesión. 
  Si la respuesta indica que el usuario no está ligado o ya salió del ISTA (código de estado 400), 
  se muestra un mensaje y se cierra la sesión del Google Sign-In*/
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
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$nombre ${response.body}"),
            duration: const Duration(seconds: 4),
          ),
        );
        signOutGoogle();
      } else {
        print('Error en la solicitud');
        signOutGoogle();
      }
    } catch (error) {
      print("Error verificando $error");
      Fluttertoast.showToast(
        msg: "OCURRIO UN ERROR INESPERADO: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  /*cierra la sesión del usuario en Google Sign-In y Firebase Authentication*/
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  /* realiza el inicio de sesión del usuario. 
  Se envía una solicitud con las credenciales del usuario y se obtiene un token de acceso. 
  Se verifica el rol del usuario y se redirige a una pantalla correspondiente. 
  Si faltan datos en el perfil del usuario, se muestra un cuadro de diálogo para completarlos.*/
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
        final Persona p = Persona.fromJson(jsons);

        print(p.celular);
        print(p.direccion);
        // ignore: use_build_context_synchronously
        if ((p.celular == "null" ||
            p.direccion == "null" ||
            p.celular.isEmpty ||
            p.direccion.isEmpty)) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                    'Es necesario completar unos datos antes de iniciar sesión'),
                actions: [
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, EditarUsuarioScreen.id);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          if (authorities == 'ROLE_STUD') {
            setState(() {
              rol = "ESTUDIANTE";
            });
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, LlibrosScreen.id);
          } else if (authorities == 'ROLE_BLIB') {
            setState(() {
              rol = "BIBLIOTECARIO";
            });
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, LlibrosScreen.id);
          } else if (authorities == 'ROLE_ADMIN') {
            setState(() {
              rol = "ADMIN";
            });
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, LlibrosScreen.id);
          } else if (authorities == 'ROLE_DOCEN') {
            setState(() {
              rol = "DOCENTE";
            });
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, LlibrosScreen.id);
          }
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
        modificardevice();
      }
    }
  }

  /*realiza una modificación en el dispositivo asociado al usuario. 
  Este codigo serivirá posteriormente para recibir notificaciones push*/
  Future<void> modificardevice() async {
    Map data = {
      "device": tokennotificacion,
    };
    var body = json.encode(data);
    print("Nuevo Json: $body");

    try {
      var url = "$baseUrl/persona/editar/${personalog.id_persona}";
      print(url);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('DEVICE AGREGADO ${response.body}');
      } else {
        print('Error al agregar device ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error device $error");
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
