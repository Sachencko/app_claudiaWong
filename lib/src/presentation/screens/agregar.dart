import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Agregar extends StatefulWidget {
  final String usuario;
  const Agregar({super.key, required this.usuario});

  @override
  State<Agregar> createState() => _AgregarState();
}

class _AgregarState extends State<Agregar> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _pagoKey = GlobalKey();

  String generarCodigoAleatorio() {
    final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    return random.toString().padLeft(6, '0');
  }

  final Map<String, List<Map<String, dynamic>>> serviciosPorCategoria = {
    "TRATAMIENTOS FACIALES": [
      {
        "nombre": "Limpieza facial profunda",
        "precio": 75,
        "img": "assets/facial1.png",
      },
      {
        "nombre": "Limpieza facial basica",
        "precio": 35,
        "img": "assets/facial2.png",
      },
    ],
    "ESTÉTICA FACIAL": [
      {
        "nombre": "Depilación de rostro (con cera)",
        "precio": 40,
        "img": "assets/estetica1.png",
      },
      {
        "nombre": "Visagismo de cejas y depilacion con cera",
        "precio": 25,
        "img": "assets/estetica2.png",
      },
      {
        "nombre": "Lifting de pestañas",
        "precio": 55,
        "img": "assets/estetica3.png",
      },
      {
        "nombre": "Laminado de cejas",
        "precio": 60,
        "img": "assets/estetica4.png",
      },
    ],
    "MANICURE": [
      {"nombre": "Esmaltado gel", "precio": 35, "img": "assets/mani1.png"},
      {
        "nombre": "Esmaltado semipermanente",
        "precio": 30,
        "img": "assets/mani2.png",
      },
      {"nombre": "Uñas poligel", "precio": 40, "img": "assets/mani3.png"},
      {"nombre": "Uñas acrílicas", "precio": 65, "img": "assets/mani4.png"},
      {
        "nombre": "Capping con acrilico",
        "precio": 60,
        "img": "assets/mani5.png",
      },
      {
        "nombre": "Cromados y relieves",
        "precio": 50,
        "img": "assets/mani6.png",
      },
      {"nombre": "Manicure francesa", "precio": 30, "img": "assets/mani7.png"},
      {"nombre": "Efecto ojo de gato", "precio": 45, "img": "assets/mani8.png"},
      {"nombre": "Efecto espejo", "precio": 40, "img": "assets/mani9.png"},
      {
        "nombre": "Tecnica baby boomer",
        "precio": 45,
        "img": "assets/mani10.png",
      },
      {"nombre": "Tecnica rubber", "precio": 40, "img": "assets/mani11.png"},
      {"nombre": "Diseño tribal", "precio": 35, "img": "assets/mani12.png"},
    ],
    "MASAJES": [
      {
        "nombre": "Masaje relajante y Aromaterapia",
        "precio": 65,
        "img": "assets/masaje1.png",
      },
      {
        "nombre":
            "Masoterapia, piedras calientes, Tens y pistola de percusion. 1hr",
        "precio": 75,
        "img": "assets/masaje2.png",
      },
      {
        "nombre":
            "Masoterapia, piedras calientes, Tens y pistola de percusion. 2hr",
        "precio": 100,
        "img": "assets/masaje3.png",
      },
    ],
  };

  final Map<String, Set<String>> serviciosSeleccionados = {};
  DateTime? fechaSeleccionada;
  String? horarioSeleccionado;
  bool mostrarConfirmacion = false;
  bool pagoConfirmado = false;
  String tipoPago = '';
  int total = 0;
  final int maxServiciosPermitidos = 4;

  final List<String> horarios = [
    "9:00 a.m",
    "10:00 a.m",
    "11:00 a.m",
    "2:00 p.m",
    "3:00 p.m",
  ];

  Set<String> horariosOcupados = {};

  @override
  void initState() {
    super.initState();
    for (var categoria in serviciosPorCategoria.keys) {
      serviciosSeleccionados[categoria] = {};
    }
  }

  void toggleServicio(String categoria, String nombre) {
    final totalSeleccionados = serviciosSeleccionados.values.fold(
      0,
      (sum, set) => sum + set.length,
    );

    setState(() {
      if (serviciosSeleccionados[categoria]!.contains(nombre)) {
        serviciosSeleccionados[categoria]!.remove(nombre);
      } else {
        if (totalSeleccionados >= maxServiciosPermitidos) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Solo puedes seleccionar hasta $maxServiciosPermitidos servicios.",
              ),
            ),
          );
          return;
        }
        serviciosSeleccionados[categoria]!.add(nombre);
      }
    });
  }

  void seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final fechaInicio = DateTime(picked.year, picked.month, picked.day);
      final fechaFin = fechaInicio.add(const Duration(days: 1));

      final snapshot =
          await FirebaseFirestore.instance
              .collection("agregar")
              .where(
                "fecha",
                isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio),
              )
              .where("fecha", isLessThan: Timestamp.fromDate(fechaFin))
              .get();

      final ocupados =
          snapshot.docs.map((doc) => doc['horario'] as String).toSet();

      setState(() {
        fechaSeleccionada = picked;
        horariosOcupados = ocupados;
        horarioSeleccionado = null;
      });
    }
  }

  void irAPago() async {
    final seleccionFinal = <Map<String, dynamic>>[];

    serviciosPorCategoria.forEach((categoria, servicios) {
      for (var servicio in servicios) {
        if (serviciosSeleccionados[categoria]!.contains(servicio['nombre'])) {
          seleccionFinal.add(servicio);
        }
      }
    });

    if (fechaSeleccionada == null || horarioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona fecha y horario")),
      );
      return;
    }

    if (seleccionFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona al menos un servicio")),
      );
      return;
    }

    setState(() {
      mostrarConfirmacion = true;
      total = seleccionFinal.fold(
        0,
        (sum, item) => sum + item['precio'] as int,
      );
    });

    // Esperar a que se construya el widget y luego hacer scroll con animación
    await Future.delayed(const Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void finalizar() async {
    if (!pagoConfirmado || tipoPago.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Confirma el pago para continuar")),
      );
      return;
    }

    final seleccionFinal = <String>[];

    serviciosPorCategoria.forEach((categoria, servicios) {
      for (var servicio in servicios) {
        if (serviciosSeleccionados[categoria]!.contains(servicio['nombre'])) {
          seleccionFinal.add(servicio['nombre']);
        }
      }
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final docRef = FirebaseFirestore.instance.collection("agregar").doc();
    final codigo = generarCodigoAleatorio();

    await docRef.set({
      "id": docRef.id,
      "usuario": widget.usuario,
      "usuarioId": currentUser.uid,
      "servicio": seleccionFinal.join(", "),
      "fecha": Timestamp.fromDate(fechaSeleccionada!),
      "horario": horarioSeleccionado,
      "estado": "activa",
      "estado_pago": "simulado",
      "tipo_pago": tipoPago,
      "creado": Timestamp.now(),
      "total": total,
      "codigo": codigo,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cita registrada correctamente")),
    );

    Navigator.pop(context);
  }

  Widget buildCategoria(
    String categoria,
    List<Map<String, dynamic>> servicios,
  ) {
    return ExpansionTile(
      backgroundColor: const Color.fromARGB(255, 240, 222, 190),
      collapsedBackgroundColor: Colors.white,
      title: Text(
        categoria,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children:
          servicios.map((servicio) {
            final seleccionado = serviciosSeleccionados[categoria]!.contains(
              servicio['nombre'],
            );
            return ListTile(
              leading: Image.asset(servicio['img'], width: 40, height: 40),
              title: Text(servicio['nombre']),
              subtitle: Text("S/. ${servicio['precio']}"),
              trailing: Checkbox(
                activeColor: const Color.fromARGB(255, 206, 172, 69),
                value: seleccionado,
                onChanged: (_) => toggleServicio(categoria, servicio['nombre']),
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Image.asset("assets/claudiaLogin.png", height: 50),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          children: [
            ListTile(
              title: const Text("Seleccionar Fecha"),
              subtitle: Text(
                fechaSeleccionada != null
                    ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)
                    : "No seleccionada",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: seleccionarFecha,
            ),
            const SizedBox(height: 10),
            const Text(
              "Seleccionar Horario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  horarios.map((h) {
                    return ChoiceChip(
                      label: Text(
                        h,
                        style: const TextStyle(color: Colors.black),
                      ),
                      selected: horarioSeleccionado == h,
                      selectedColor: const Color.fromARGB(255, 204, 173, 48),
                      backgroundColor: const Color.fromARGB(255, 228, 186, 61),
                      disabledColor: Colors.grey.shade400,
                      onSelected:
                          horariosOcupados.contains(h)
                              ? null
                              : (_) {
                                setState(() {
                                  horarioSeleccionado = h;
                                });
                              },
                    );
                  }).toList(),
            ),
            const Divider(height: 30),
            ...serviciosPorCategoria.entries
                .map((e) => buildCategoria(e.key, e.value))
                .toList(),
            if (mostrarConfirmacion) ...[
              const SizedBox(height: 20),
              const Text(
                "Para separar tu cita es necesario realizar un adelanto de S/.10",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                key: _pagoKey,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "SERVICIOS SELECCIONADOS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...serviciosPorCategoria.entries.expand((entry) {
                      return entry.value
                          .where((s) {
                            return serviciosSeleccionados[entry.key]!.contains(
                              s['nombre'],
                            );
                          })
                          .map((s) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(child: Text("- ${s['nombre']}")),
                                  Text("S/. ${s['precio']}"),
                                ],
                              ),
                            );
                          });
                    }).toList(),
                    const SizedBox(height: 10),
                    Text(
                      "Total a pagar: S/. $total",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Image.asset("assets/yape.jpg", width: 200),
                    const Text(
                      "CLAUDIA WONG ARIAS\n987654321",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Confirmación de pago",
                      ),
                      value: tipoPago.isEmpty ? null : tipoPago,
                      items: const [
                        DropdownMenuItem(
                          value: "adelanto",
                          child: Text(
                            "Pago por adelanto - reserva de cita (S/10)",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "completo",
                          child: Text("Pago por servicio completo"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoPago = value ?? '';
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: pagoConfirmado,
                      onChanged: (value) {
                        setState(() {
                          pagoConfirmado = value ?? false;
                        });
                      },
                      title: const Text("He realizado el pago"),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: finalizar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text(
                          "Finalizar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: mostrarConfirmacion ? null : irAPago,
          child: const Text(
            "Confirmar",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
