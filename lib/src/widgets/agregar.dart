import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FechaScreen.dart';

class Agregar extends StatefulWidget {
  final String usuario;
  const Agregar({super.key, required this.usuario});

  @override
  State<Agregar> createState() => _AgregarState();
}

class _AgregarState extends State<Agregar> {
  void guardarYContinuar(String servicio) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection("agregar").add({
    "usuario": widget.usuario,
    "servicio": servicio,
    "fecha": null,
    "creado": Timestamp.now(),
  });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FechaScreen(documentId: docRef.id, servicio: servicio, usuario: widget.usuario,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añade tu cita"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "¿Qué desea hacerse?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                servicioBoton("assets/claudia.jpg", "Tratamientos\nfaciales"),
                servicioBoton("assets/claudia.jpg", "Manicure"),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                servicioBoton("assets/claudia.jpg", "Masajes"),
                servicioBoton("assets/claudia.jpg", "Tatuajes"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget servicioBoton(String imagen, String texto) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => guardarYContinuar(texto),
          child: ClipOval(
            child: Image.asset(
              imagen,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            texto,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
