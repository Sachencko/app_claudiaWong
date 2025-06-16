import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActualizarCitasScreen extends StatelessWidget {
  const ActualizarCitasScreen({super.key});

  Future<void> actualizarCitasAntiguas(BuildContext context) async {
    try {
      final snapshots = await FirebaseFirestore.instance.collection('agregar').get();

      int actualizadas = 0;

      for (var doc in snapshots.docs) {
        final data = doc.data();
        if (!data.containsKey('estado')) {
          await doc.reference.update({'estado': 'activa'});
          actualizadas++;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Citas actualizadas: $actualizadas')),
      );
    } catch (e) {
      print('Error al actualizar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar citas')),
      );
    }
  }
 void corregirCitasSinFecha() async {
  final query = await FirebaseFirestore.instance.collection('agregar').get();

  for (final doc in query.docs) {
    final data = doc.data();
    if (!data.containsKey('fecha') || data['fecha'] == null) {
      await doc.reference.update({
        'fecha': Timestamp.now(), // o pon una fecha predeterminada si prefieres
      });
    }
  }

  print("✅ Se actualizaron todas las citas sin fecha");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Citas')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.update),
          label: Text('Actualizar citas antiguas'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () => corregirCitasSinFecha(),
        ),
      ),
    );
  }
}
