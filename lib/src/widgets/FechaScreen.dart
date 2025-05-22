import 'package:claudia_wong_app/src/widgets/HorarioScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FechaScreen extends StatefulWidget {
  final String servicio;
  final String documentId;

  const FechaScreen({
    super.key,
    required this.servicio,
    required this.documentId,
  });

  @override
  State<FechaScreen> createState() => _FechaScreenState();
}

class _FechaScreenState extends State<FechaScreen> {
  DateTime? fechaSeleccionada;

  Future<void> guardarFechaEnFirebase() async {
    await FirebaseFirestore.instance
        .collection("agregar")
        .doc(widget.documentId)
        .update({"fecha": fechaSeleccionada});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Cita guardada: ${widget.servicio} - ${fechaSeleccionada!.toLocal().toString().split(' ')[0]}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("¿Cuándo?")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return fechaSeleccionada != null &&
                  day.year == fechaSeleccionada!.year &&
                  day.month == fechaSeleccionada!.month &&
                  day.day == fechaSeleccionada!.day;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                fechaSeleccionada = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  fechaSeleccionada == null
                      ? null
                      : () async {
                        await guardarFechaEnFirebase();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HorarioScreen(
                                  documentId: widget.documentId,
                                  fecha: fechaSeleccionada!,
                                ),
                          ),
                        ); 
                      },
              child: Text("Aceptar"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
