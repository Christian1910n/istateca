//10.0.2.2
//10.0.1.6(aisac)
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:proyectoistateca/models/persona.dart';

//const String baseUrl = "http://192.168.18.24:8080";//anthony
const String baseUrl = "http://192.168.68.110:8080";
Map<String, String> headers = {
  "Content-Type": "application/json",
  "Authorization": tokenacceso
};

String rol = 'BIBLIOTECARIO';
String correo = 'elbichonoinciosesion@tecazuay.edu.ec';
String nombre = 'hola';
String tokenacceso = '';
late Persona personalog;
String foto =
    "https://phantom-marca-mx.unidadeditorial.es/887fd9b0e45b9bc9accdd30de6708298/resize/828/f/jpg/mx/assets/multimedia/imagenes/2023/06/05/16859985858899.jpg";

Container animacioncarga() {
  return Container(
    color: Colors.white,
    child: Center(
      child: Stack(
        children: [
          Lottie.network(
              'https://assets7.lottiefiles.com/private_files/lf30_8dfy9zls.json'),
        ],
      ),
    ),
  );
}
