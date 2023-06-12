import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectoistateca/models/libros.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';

class SolicitarLibroScreen extends StatefulWidget {
  final Libro libro;
  static String id = 'solicitar_libro_screen';

  const SolicitarLibroScreen({super.key, required this.libro});
  @override
  State<SolicitarLibroScreen> createState() => _SolicitarLibroScreenState();
}

class _SolicitarLibroScreenState extends State<SolicitarLibroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud del libro'),
        backgroundColor: Color.fromRGBO(28, 105, 183, 1.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Nro Solicitud: 3\n'
                'Titulo del libro: ${widget.libro.titulo}\n'
                'Fecha Solicitud: 6/6/2023',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: CustomPaint(
                painter: QrPainter(
                  data: widget.libro.titulo,
                  options: const QrOptions(
                    shapes: QrShapes(
                      darkPixel: QrPixelShapeRoundCorners(cornerFraction: .0),
                      frame: QrFrameShapeRoundCorners(cornerFraction: .0),
                      ball: QrBallShapeRoundCorners(cornerFraction: .0),
                    ),
                    colors: QrColors(
                        dark: QrColorLinearGradient(colors: [
                      Colors.black,
                      Colors.black,
                    ], orientation: GradientOrientation.leftDiagonal)),
                  ),
                ),
                size: const Size(350, 350),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
