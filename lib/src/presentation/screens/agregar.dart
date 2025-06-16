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
  final Map<String, List<Map<String, dynamic>>> serviciosPorCategoria = {
    "TRATAMIENTOS FACIALES": [
      {"nombre": "Limpieza facial profunda", "precio": 50, "img": "assets/facial1.png"},
      {"nombre": "Exfoliación facial", "precio": 35, "img": "assets/facial2.png"},
    ],
    "ESTÉTICA FACIAL": [
      {"nombre": "Diseño de cejas", "precio": 40, "img": "assets/estetica1.png"},
      {"nombre": "Laminado de cejas", "precio": 50, "img": "assets/estetica2.png"},
    ],
    "MANICURE": [
      {"nombre": "Esmaltado gel", "precio": 30, "img": "assets/mani1.png"},
      {"nombre": "Uñas acrílicas", "precio": 55, "img": "assets/mani2.png"},
    ],
    "MASAJES": [
      {"nombre": "Masaje relajante", "precio": 60, "img": "assets/masaje1.png"},
      {"nombre": "Masaje con piedras", "precio": 75, "img": "assets/masaje2.png"},
    ],
  };

  final Map<String, Set<String>> serviciosSeleccionados = {};
  DateTime? fechaSeleccionada;
  String? horarioSeleccionado;
  bool mostrarConfirmacion = false;
  bool pagoConfirmado = false;
  String tipoPago = '';
  int total = 0;

  final List<String> horarios = [
    "9:00 a.m",
    "10:00 a.m",
    "11:00 a.m",
    "2:00 p.m",
    "3:00 p.m",
  ];

  @override
  void initState() {
    super.initState();
    for (var categoria in serviciosPorCategoria.keys) {
      serviciosSeleccionados[categoria] = {};
    }
  }

  void toggleServicio(String categoria, String nombre) {
    setState(() {
      if (serviciosSeleccionados[categoria]!.contains(nombre)) {
        serviciosSeleccionados[categoria]!.remove(nombre);
      } else {
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
      setState(() {
        fechaSeleccionada = picked;
      });
    }
  }

  void irAPago() {
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
      total = seleccionFinal.fold(0, (sum, item) => sum + item['precio'] as int);
    });
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
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cita registrada correctamente")),
    );

    Navigator.pop(context);
  }

  Widget buildCategoria(String categoria, List<Map<String, dynamic>> servicios) {
    return ExpansionTile(
      backgroundColor: const Color.fromARGB(255, 240, 222, 190),
      collapsedBackgroundColor: Colors.white,
      title: Text(categoria, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: servicios.map((servicio) {
        final seleccionado = serviciosSeleccionados[categoria]!.contains(servicio['nombre']);
        return ListTile(
          leading: Image.asset(servicio['img'], width: 40, height: 40),
          title: Text(servicio['nombre']),
          subtitle: Text("S/. ${servicio['precio']}"),
          trailing: Checkbox(
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 0.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset("assets/claudiaLogin.png"),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  color: Colors.red,
                  iconSize: 30,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    214,
                                    29,
                                    16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Si",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            content: Text(
                              "¿Seguro deseas cerrar sesion?",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    );
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                    print('SESION SALIDA');
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            title: const Text("Seleccionar Fecha"),
            subtitle: Text(fechaSeleccionada != null
                ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)
                : "No seleccionada"),
            trailing: const Icon(Icons.calendar_today),
            onTap: seleccionarFecha,
          ),
          const SizedBox(height: 10),
          const Text("Seleccionar Horario", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: horarios.map((h) {
              return ChoiceChip(
                color: MaterialStateProperty.all(const Color.fromARGB(255, 228, 186, 61)),
                label: Text(h, style: TextStyle(color: Colors.black),),
                selected: horarioSeleccionado == h,
                onSelected: (_) {
                  setState(() {
                    horarioSeleccionado = h;
                  });
                },
              );
            }).toList(),
          ),
          const Divider(height: 30),
          ...serviciosPorCategoria.entries.map((e) => buildCategoria(e.key, e.value)).toList(),
          if (mostrarConfirmacion) ...[
            const SizedBox(height: 20),
            const Text("Para separar tu cita es necesario realizar un adelanto de S/.10", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("SERVICIOS SELECCIONADOS", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...serviciosPorCategoria.entries.expand((entry) => entry.value.where((s) => serviciosSeleccionados[entry.key]!.contains(s['nombre'])).map((s) => Text("- ${s['nombre']}  S/. ${s['precio']}"))).toList(),
                  const SizedBox(height: 10),
                  Text("Total a pagar: S/. $total", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Image.asset("assets/qr_yape.png", width: 200),
                  const Text("CLAUDIA WONG ARIAS\n987654321", textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Confirmación de pago"),
                    value: tipoPago.isEmpty ? null : tipoPago,
                    items: const [
                      DropdownMenuItem(value: "adelanto", child: Text("Pago por adelanto - reserva de cita (S/10)")),
                      DropdownMenuItem(value: "completo", child: Text("Pago por servicio completo")),
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
                  ElevatedButton(
                    onPressed: finalizar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Finalizar", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: mostrarConfirmacion ? null : irAPago,
          child: const Text("Confirmar", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
