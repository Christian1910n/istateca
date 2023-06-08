import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BookRequestView extends StatefulWidget {
  static String id = 'book_screen';

  @override
  _BookRequestViewState createState() => _BookRequestViewState();
}

class _BookRequestViewState extends State<BookRequestView> {
  String selectedDocumentType = 'Seleccione';
  DateTime selectedDate = DateTime.now();
  DateTime? selectedReturnDate;

  Future<void> _selectDate(BuildContext context, bool isReturnDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isReturnDate ? selectedReturnDate ?? DateTime.now() : DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isReturnDate) {
          selectedReturnDate = picked;
        } else {
          selectedDate = picked;
        }
      });
    }
  }

  Widget _buildFormField(String label, String hintText,
      {bool isReturnDate = false, List<String>? documentTypes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        if (documentTypes != null)
          DropdownButtonFormField<String>(
            value: selectedDocumentType,
            onChanged: (value) {
              setState(() {
                selectedDocumentType = value!;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'Seleccione',
                child: Text('Seleccione'),
              ),
              ...documentTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }),
            ],
            decoration: InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
        if (documentTypes == null && !isReturnDate)
          TextFormField(
            decoration: InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
        if (isReturnDate)
          GestureDetector(
            onTap: () {
              if (!isReturnDate) {
                _selectDate(context, true);
              }
            },
            child: AbsorbPointer(
              absorbing: true,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: hintText,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: selectedDate.toString().split(' ')[0],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitud',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(24, 98, 173, 1.0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormField('Cédula del Estudiante', 'Ingrese la cédula'),
              SizedBox(height: 16.0),
              _buildFormField('Código DEWEY', 'Ingrese el código DEWEY'),
              SizedBox(height: 16.0),
              _buildFormField(
                  'Título del Libro', 'Ingrese el título del libro'),
              SizedBox(height: 16.0),
              _buildFormField(
                  'Estado del Libro', 'Ingrese el estado del libro'),
              SizedBox(height: 16.0),
              _buildFormField(
                'Documento Habilitante',
                'Seleccione el documento habilitante',
                documentTypes: ['Cédula', 'Pasaporte', 'Licencia'],
              ),
              SizedBox(height: 16.0),
              _buildFormField(
                'Fecha de Entrega',
                'Seleccione la fecha de entrega',
                isReturnDate: true,
              ),
              SizedBox(height: 16.0),
              _buildFormField(
                'Bibliotecario Encargado',
                'Ingrese el nombre del bibliotecario',
              ),
              SizedBox(height: 16.0),
              _buildFormField(
                'Fecha Máxima de Devolución',
                'Seleccione la fecha máxima de devolución',
                isReturnDate: true,
              ),
              SizedBox(height: 16.0),
              _buildFormField(
                  'Estado del Préstamo', 'Ingrese el estado del préstamo'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Acción para imprimir
                },
                child: Text('Imprimir'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Acción para guardar
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: BookRequestView()));
}
