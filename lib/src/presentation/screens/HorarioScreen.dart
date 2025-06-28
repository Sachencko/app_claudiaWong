/*

 _   _  ___  ____      _    ____  ___ ___  
| | | |/ _ \|  _ \    / \  |  _ \|_ _/ _ \ 
| |_| | | | | |_) |  / _ \ | |_) || | | | |
|  _  | |_| |  _ <  / ___ \|  _ < | | |_| |
|_|_|_|\___/|_|_\_\/_/__ \_\_| \_\___\___/ 
/ ___| / ___|  _ \| ____| ____| \ | |      
\___ \| |   | |_) |  _| |  _| |  \| |      
 ___) | |___|  _ <| |___| |___| |\  |      
|____/ \____|_| \_\_____|_____|_| \_

*/
import 'dart:math';

import 'package:claudia_wong_app/src/widgets/noti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorarioScreen extends StatefulWidget {
  final String documentId;
  final DateTime fecha;
  final String usuario;

  const HorarioScreen({
    super.key,
    required this.documentId,
    required this.fecha,
    required this.usuario,
  });

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  String? horarioSeleccionado;

  final List<String> horarios = [
    "9:00 a.m",
    "10:00 a.m",
    "11:00 a.m",
    "2:00 p.m",
    "3:00 p.m",
  ];

  Future<void> guardarHorario() async {
    await FirebaseFirestore.instance
        .collection("agregar")
        .doc(widget.documentId)
        .update({"horario": horarioSeleccionado});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Horario guardado: $horarioSeleccionado")),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final fechaTexto = DateFormat('dd/MM/yyyy').format(widget.fecha);

    return Scaffold(
      appBar: AppBar(title: Text("Selecciona tu horario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              fechaTexto,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Separa tu cita\nHorarios disponibles:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: horarios.length,
                itemBuilder: (context, index) {
                  final hora = horarios[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        horarioSeleccionado = hora;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            horarioSeleccionado == hora
                                ? Colors.blue.shade50
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hora,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Disponible",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            fechaTexto,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  horarioSeleccionado == null
                      ? null
                      : () async {
                        int codigo = Random().nextInt(900000) + 100000;

                        await FirebaseFirestore.instance
                            .collection("agregar")
                            .doc(widget.documentId)
                            .update({
                              "horario": horarioSeleccionado,
                              "codigo": codigo,
                            });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Noti(
                                  codigo: codigo,
                                  usuario: widget.usuario,
                                ),
                          ),
                        );
                      },
              child: const Text("Agregar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
