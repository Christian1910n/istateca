import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyectoistateca/models/prestamo.dart';

class BookRequestView extends StatefulWidget {
  final Prestamo prestamo;
  static String id = 'book_screen';

  const BookRequestView({super.key, required this.prestamo});

  @override
  _BookRequestViewState createState() => _BookRequestViewState();
}

class _BookRequestViewState extends State<BookRequestView> {
  late Prestamo prestamo;
  DateTime _selectedDate = DateTime.now();
  TextEditingController cedulacontroller = TextEditingController();
  TextEditingController codDeweycontroller = TextEditingController();
  TextEditingController titulolibrocontroller = TextEditingController();
  TextEditingController estadodellibrocontroller = TextEditingController();

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      prestamo = widget.prestamo;
    });
    print(widget.prestamo.libro!.titulo);
    cedulacontroller.text = widget.prestamo.idSolicitante!.cedula;
    codDeweycontroller.text = widget.prestamo.libro!.codigoDewey;
    titulolibrocontroller.text = widget.prestamo.libro!.titulo;
    estadodellibrocontroller.text = widget.prestamo.estadoLibro.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formulario de Solicitudes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre Solicitante: ${prestamo.idSolicitante!.nombres} ${prestamo.idSolicitante!.apellidos}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Título del Libro: ${prestamo.libro!.titulo}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fecha de Solicitud: ${prestamo.fechaFin}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nombre de la Persona que Entrega: bibliotecario',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: prestamo.estadoLibro,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Bueno'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Regular'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Malo'),
                ),
              ],
              onChanged: (value) {
                // Actualizar el estado del libro con el valor seleccionado
                // prestamo.estadoLibro = value;
              },
              decoration: InputDecoration(labelText: 'Estado del Libro'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: prestamo.documentoHabilitante ?? 0,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Seleccione:'),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Cédula'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Pasaporte'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Licencia de Conducir'),
                ),
              ],
              onChanged: (value) {
                // Actualizar el tipo de documento habilitante con el valor seleccionado
                // prestamo.documentoHabilitante = value;
              },
              decoration: InputDecoration(labelText: 'Documento Habilitante'),
            ),
            SizedBox(height: 16.0),
            ListTile(
              title: Text('Fecha Maxima de Devolución'),
              subtitle: Text(
                  '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: prestamo.tipoPrestamo,
              items: const [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Estudiantil'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Docencia'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Terceros'),
                ),
              ],
              onChanged: (value) {
                // Actualizar el tipo de préstamo con el valor seleccionado
                // prestamo.tipoPrestamo = value;
              },
              decoration: const InputDecoration(labelText: 'Tipo de Préstamo'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para aprobar la solicitud
                  },
                  child: Text('Aprobar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para rechazar la solicitud
                  },
                  child: Text('Rechazar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
