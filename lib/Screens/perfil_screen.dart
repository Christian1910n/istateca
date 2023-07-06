import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyectoistateca/Services/globals.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});
  static String id = 'perfil_screen';

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(foto),
                radius: 80,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Rol:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              rol,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Nombres:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${personalog.nombres} ${personalog.apellidos}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Cédula:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              personalog.cedula,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Correo:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              personalog.correo,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Dirección:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              personalog.direccion,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Calificación:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            RatingBarIndicator(
              rating: personalog.calificacion.toDouble(),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 24.0,
              unratedColor: Colors.grey,
              direction: Axis.horizontal,
            ),
          ],
        ),
      ),
    );
  }
}
