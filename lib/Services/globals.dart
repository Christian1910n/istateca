//10.0.2.2
//10.0.1.6(aisac)
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const String baseUrl = "http://192.168.18.24:8080";
const Map<String, String> headers = {"Content-Type": "application/json"};

String rol = 'BIBLIOTECARIO';

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
