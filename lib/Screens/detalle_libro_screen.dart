import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyectoistateca/Screens/lista_libros_screen.dart';
import 'package:proyectoistateca/Screens/solicitar_libro_screen.dart';
import 'package:proyectoistateca/Services/globals.dart';
import 'package:proyectoistateca/models/carrera.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoistateca/models/prestamo.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proyectoistateca/widgets/camera_screen.dart';

class DetalleLibroScreen extends StatefulWidget {
  final Libro libro;

  const DetalleLibroScreen({super.key, required this.libro});

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
//Datos de ejemplo
  int tipoPrestamo = 0;

  int idsoli = 0;

  bool habilitar = false;

  List<String> mensajes = [];

  Carrera carrera =
      Carrera(id_carrera: 2, idFenix: 0, nombre: "nombre", activo: true);

  /* realiza una solicitud para saber si una persona puede realizat un prestamo 
  y actualiza las variables de estado según la respuesta obtenida. 
  Si la respuesta indica que algo está "habilitado", 
  se establece una variable como verdadero; 
  de lo contrario, se establece como falso y se guardan los mensajes de la respuesta.*/
  Future<void> habilitado() async {
    final url = Uri.parse(
        '$baseUrl/prestamo/habilitado?personaId=${personalog.id_persona}&libroId=${widget.libro.id}');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      if (response.body == "Habilitado") {
        setState(() {
          habilitar = true;
        });
      } else {
        setState(() {
          habilitar = false;
          mensajes = response.body.split(";");
        });
      }
    } else {
      print('Error en la solicitud habilitacion: ${response.statusCode}');
    }
  }

/*crea un nuevo préstamo, se determina el tipo de préstamo según el rol del usuario 
  y se obtiene la fecha actual. 
  Se realiza una solicitud para crear el préstamo y se manejan las respuestas.
  Si el préstamo se crea exitosamente, se obtiene el ID del préstamo
  y se redirige a una pantalla de solicitud de libro.*/
  Future<void> crearPrestamo() async {
    if (rol == "ESTUDIANTE") {
      tipoPrestamo = 1;
    } else if (rol == "BIBLIOTECARIO" || rol == "DOCENTE" || rol == "ADMIN") {
      tipoPrestamo = 2;
    } else {
      tipoPrestamo = 3;
    }
    String fecha = DateTime.now().add(const Duration(days: 1)).toString();
    Prestamo prestamo = Prestamo(
        id_prestamo: 0,
        fechaFin: fecha,
        estadoLibro: 2,
        estadoPrestamo: 1,
        fechaEntrega: fecha,
        documentoHabilitante: 0,
        fechaDevolucion: fecha,
        fechaMaxima: fecha,
        activo: true,
        escaneoMatriz: "",
        tipoPrestamo: tipoPrestamo,
        idSolicitante: personalog,
        idEntrega: null,
        idRecibido: null,
        carrera: carrera,
        libro: widget.libro);

    try {
      const url = "$baseUrl/prestamo/crear";

      final prestamoJson = jsonEncode(prestamo);
      print(prestamoJson);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: prestamoJson,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Prestamo creado ${response.body}');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Prestamo prestamo = Prestamo.fromJson(jsonResponse);
        setState(() {
          idsoli = prestamo.id_prestamo;
        });
      } else {
        print('Error al crear el prestamo: ${response.statusCode}');
        print('ERROR ${response.body}');
      }
    } catch (error) {
      print("Error crear prestamo $error");
    } finally {
      if (idsoli != 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SolicitarLibroScreen(
                  libro: widget.libro, idsolicitud: idsoli)),
        );
        setState(() {
          validar = 2;
        });
      } else {
        Fluttertoast.showToast(
          msg:
              "OCURRIO UN ERROR AL SOLICITAR EL LIBRO POR FAVOR VUELVA A INTENTARLO",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
      }
    }
  }

  //carga la imagen del libro
  Future<ImageProvider> loadImage() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl${widget.libro.urlImagen}'));
      if (response.statusCode == 200) {
        return MemoryImage(response.bodyBytes);
      } else {
        return Image.asset('assets/vacio.jpg').image;
      }
    } catch (e) {
      return Image.asset('assets/vacio.jpg').image;
    }
  }

  /*sube una imagen para el libro. 
  Se realiza una solicitud adjuntando la imagen en el cuerpo de la solicitud. */
  void subirImagen(int id, String imagePath) async {
    try {
      String url = '$baseUrl/libro/subirimagen/$id';
      print(url);

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('imagen', imagePath),
      );
      request.headers['Authorization'] = tokenacceso;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('La imagen se subió exitosamente.');
        Fluttertoast.showToast(
          msg: "IMAGEN GUARDADA CON EXITO",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LlibrosScreen()),
        );
      } else {
        print(
            'Error al subir la imagen. Código de respuesta: ${response.statusCode}');
        Fluttertoast.showToast(
          msg:
              "Error al subir la imagen. Código de respuesta: ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
      }
    } catch (error) {
      print("Error subiendo imagen $error");
    }
  }

  /*muestra un diálogo que permite al usuario capturar o seleccionar una imagen para asociarla a un libro. 
  Se proporcionan opciones para capturar una nueva imagen, 
  seleccionar una imagen de la galería, guardar la imagen o cancelar el proceso. 
  Al seleccionar una imagen y guardarla, se llama al método subirImagen() para subirla al servidor. 
  Al cancelar, se redirige a la pantalla de libros.*/
  void _dialogoimagen() async {
    FilePickerResult? _imageFile;
    var imagePath;

    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.libro.urlImagen.isNotEmpty)
                      if (imagePath == null)
                        FutureBuilder<ImageProvider>(
                          future: loadImage(),
                          builder: (BuildContext context,
                              AsyncSnapshot<ImageProvider> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Image.asset('assets/vacio.jpg');
                              } else {
                                return Image(image: snapshot.data!);
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                    if (imagePath != null)
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(imagePath as String)),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final path = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CameraScreen(camera: firstCamera),
                          ),
                        );

                        if (mounted) {
                          print("hola $path");
                          setState(() {
                            imagePath = path;
                          });
                        }

                        print("pathhh $imagePath");
                      },
                      icon: Icon(Icons.camera),
                      label: Text('CAPTURAR NUEVA IMAGEN'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        _imageFile = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );

                        if (_imageFile != null) {
                          if (mounted) {
                            setState(() {
                              imagePath = _imageFile!.files.single.path;
                            });
                          }
                        }
                      },
                      icon: Icon(Icons.photo_library),
                      label: Text('SELECCIONAR IMAGEN DE GALERÍA'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (imagePath != null) {
                          subirImagen(widget.libro.id, imagePath);
                        } else {
                          Fluttertoast.showToast(
                            msg: "AGREGE UNA IMAGEN PARA GUARDAR",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.grey[700],
                            textColor: Colors.white,
                          );
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('GUARDAR'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LlibrosScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.cancel),
                      label: Text('CANCELAR'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    habilitado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Center(
            child: Text(
              widget.libro.titulo,
              style: const TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(24, 98, 173, 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRow("Descripción:", widget.libro.descripcion, Colors.blue,
              Colors.black),
          _buildRow(
              "Año de Publicación:",
              widget.libro.anioPublicacion.toString(),
              Colors.blue,
              Colors.black),
          _buildRow("Ciudad:", widget.libro.ciudad, Colors.blue, Colors.black),
          _buildRow("Editor:", widget.libro.editor, Colors.blue, Colors.black),
          _buildRow("Idioma:", widget.libro.idioma, Colors.blue, Colors.black),
          _buildRow("Estado del Libro:", "${widget.libro.estadoLibro}",
              Colors.blue, Colors.black),
          _buildRow("Número de páginas:", widget.libro.numPaginas.toString(),
              Colors.blue, Colors.black),
          _buildRow("Código Dewey:", widget.libro.codigoDewey, Colors.blue,
              Colors.black),
          const SizedBox(height: 20),
          if (habilitar)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: widget.libro.disponibilidad == false
                    ? Colors.grey
                    : Colors.green[400],
              ),
              onPressed: widget.libro.disponibilidad == false
                  ? null
                  : () {
                      crearPrestamo();
                    },
              child: const Text(
                "Solicitar Libro",
                style: TextStyle(fontSize: 18),
              ),
            ),
          if (habilitar == false && mensajes.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final m = mensajes[index];
                  if (m.isNotEmpty) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.01),
                      leading: const Icon(Icons.error, color: Colors.red),
                      title: Text(
                        m,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          const SizedBox(height: 10),
          if (rol == 'BIBLIOTECARIO' || rol == 'ADMIN')
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green[400],
              ),
              onPressed: () {
                _dialogoimagen();
              },
              child: const Text(
                "Agregar Imagen",
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(
      String title, String value, Color titleColor, Color valueColor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, color: titleColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 15, color: valueColor),
          ),
        ),
      ],
    );
  }
}
