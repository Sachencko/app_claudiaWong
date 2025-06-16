import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:claudia_wong_app/src/presentation/screens/agregar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class pantallaPrincipal extends StatefulWidget {
  final String usuario;
  const pantallaPrincipal({super.key, required this.usuario});

  @override
  _NavegadorState createState() => _NavegadorState();
}

class _NavegadorState extends State<pantallaPrincipal> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      Screen1(usuario: widget.usuario),
      Screen2(usuario: widget.usuario),
      Screen3(usuario: widget.usuario),
      Screen4(usuario: widget.usuario),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Citas',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.delete),
              label: 'Eliminar',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.pencil),
              label: 'Modificar',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.alarm),
              label: 'Notificaciones',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  final String usuario;

  const Screen1({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Bienvenido $usuario',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(131, 0, 0, 0),
                    ),
                  ),
                ),
                const Icon(
                  Icons.supervised_user_circle,
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12, height: 6),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 73, 73, 73),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const SizedBox(
                width: 150,
                height: 40,
                child: Center(
                  child: Text(
                    'Mis citas',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12, height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('agregar')
                  .where('usuario', isEqualTo: usuario)
                  //.where('estado', isEqualTo: 'activa') // 👉 ahora solo citas activas
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay citas registradas."));
                }

                final citas = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    final data = cita.data() as Map<String, dynamic>;

                    final fecha = (data['fecha'] as Timestamp?)?.toDate();
                    final ahora = DateTime.now();
                    final estadoPendiente =
                        fecha != null && fecha.isAfter(ahora);
                    final icono =
                        estadoPendiente ? Icons.schedule : Icons.check_circle;
                    final color =
                        estadoPendiente ? Colors.orange : Colors.green;
                    final textoEstado = estadoPendiente ? 'Pendiente' : 'Hecho';

                    final servicio = data['servicio'] ?? 'Sin servicio';
                    final horario = data['horario'] ?? 'Sin horario';

                    return Card(
                      color: const Color.fromARGB(255, 128, 128, 128),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(icono, color: color),
                        title: Text(
                          "Servicio: $servicio",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          fecha != null
                              ? "Fecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario"
                              : "Horario: $horario",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          textoEstado,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 15
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Agregar(usuario: usuario),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


class Screen2 extends StatefulWidget {
  const Screen2({super.key, required this.usuario});
  final String usuario;

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<DocumentSnapshot> citas = [];
  DocumentSnapshot? citaSeleccionada;

  @override
  void initState() {
    super.initState();
    cargarCitas();
  }

  void cargarCitas() async {
    final query = await FirebaseFirestore.instance.collection("agregar").where('usuario', isEqualTo: widget.usuario).orderBy('fecha', descending: true).get();

    setState(() {
      citas = query.docs;
    });
  }

  void cancelarCitaConfirmada() async {
  String motivo = "";

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("¿Seguro deseas cancelar la cita?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Motivo:", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => motivo = value,
            decoration: const InputDecoration(
              hintText: "Escribe el motivo",
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text("No", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (motivo.trim().isEmpty || citaSeleccionada == null) return;

            // Obtener datos de la cita
            final citaData = citaSeleccionada!.data() as Map<String, dynamic>;

            // 1. Guardar en colección de cancelaciones
            await FirebaseFirestore.instance.collection("cancelaciones_pendientes").add({
  "idCita": citaSeleccionada!.id,
  "usuario": citaSeleccionada!['usuario'],
  "servicio": citaSeleccionada!['servicio'],
  "fecha": citaSeleccionada!['fecha'],
  "horario": citaSeleccionada!['horario'],
  "motivo": motivo,
  "estado": "pendiente",
  "solicitadoEl": Timestamp.now(),
});

            // 2. Eliminar la cita
            await FirebaseFirestore.instance
                .collection("agregar")
                .doc(citaSeleccionada!.id);

            // 3. Refrescar lista
            setState(() {
              citas.remove(citaSeleccionada);
              citaSeleccionada = null;
            });


            // 4. Mostrar mensaje
            Navigator.pop(context);

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("Se envió notificación al administrador")),
);

setState(() {
  citaSeleccionada = null; // Desmarcar la selección
});

          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 219, 172, 31),),
          child: const Text("Sí", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  Widget buildCitaItem(DocumentSnapshot cita) {
    final bool seleccionada = citaSeleccionada?.id == cita.id;

    final data = cita.data() as Map<String, dynamic>;

    final fechaTimestamp = data.containsKey('fecha') ? data['fecha'] : null;
    final fecha = fechaTimestamp is Timestamp ? fechaTimestamp.toDate() : null;

    final codigo = data.containsKey('codigo') ? data['codigo'] : 'Sin código';
    final horario =
        data.containsKey('horario') ? data['horario'] : 'Sin horario';
    final servicio =
        data.containsKey('servicio') ? data['servicio'] : 'Sin servicio';

    return Card(
      color: const Color.fromARGB(255, 128, 128, 128),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: const Color.fromARGB(255, 219, 172, 31),
          value: seleccionada,
          onChanged: (value) {
            setState(() {
              citaSeleccionada = value! ? cita : null;
            });
          },
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Código de Cita : $codigo\n",
                style: const TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,),
              ),
              TextSpan(
                text: "Fecha : ${fecha != null ? DateFormat('dd/MM/yyyy').format(fecha) : 'No disponible'}\n", style: TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,)
              ),
              TextSpan(text: "Hora programada: $horario\n", style: TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,)),
              TextSpan(text: "Servicio : $servicio\n" ,style: TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,)),
            ],
          ),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 230, 215, 186),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 73, 73, 73),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const SizedBox(
                width: 250,
                height: 40,
                child: Center(
                  child: Text(
                    'Seleccione cita a eliminar',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("agregar")
                  .where('usuario', isEqualTo: widget.usuario)
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No hay citas."));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) =>
                      buildCitaItem(docs[index]),
                );
              },
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: citaSeleccionada == null ? null : cancelarCitaConfirmada,
      backgroundColor: const Color.fromARGB(255, 219, 172, 31),
      icon: const Icon(Icons.cancel, color: Colors.black),
      label: const Text(
        "Cancelar Cita",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
}

class Screen3 extends StatefulWidget {
  const Screen3({super.key, required this.usuario});
  final String usuario;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final List<String> servicios = [
    'Corte de cabello',
    'Peinado',
    'Manicura',
    'Masaje',
  ];

  final List<String> horarios = [
    "9:00 a.m",
    "10:00 a.m",
    "11:00 a.m",
    "2:00 p.m",
    "3:00 p.m",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('agregar')
                .where('usuario', isEqualTo: widget.usuario)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final citas = snapshot.data!.docs;

          if (citas.isEmpty) {
            return const Center(child: Text("No tienes citas."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final data = cita.data() as Map<String, dynamic>;

              String fechaStr = 'Sin fecha';
              DateTime? fechaDateTime;
              if (data['fecha'] != null && data['fecha'] is Timestamp) {
                final Timestamp ts = data['fecha'];
                fechaDateTime = ts.toDate();
                fechaStr = DateFormat('dd/MM/yyyy').format(fechaDateTime);
              }

              String servicioActual = data['servicio'] ?? 'No seleccionado';
              String horarioActual = data['horario'] ?? 'No seleccionado';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fecha: $fechaStr"),
                      Text("Servicio: $servicioActual"),
                      Text("Horario: $horarioActual"),
                    ],
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.blue),
                  onTap:
                      () => _mostrarDialogoModificacion(context, cita.id, data),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDialogoModificacion(
    BuildContext context,
    String citaId,
    Map<String, dynamic> data,
  ) {
    // No hay campo descripción editable ahora

    // Fecha inicial
    DateTime selectedDate = DateTime.now();
    if (data['fecha'] != null && data['fecha'] is Timestamp) {
      selectedDate = (data['fecha'] as Timestamp).toDate();
    }

    // Servicio inicial
    final List<String> servicios = [
      'Corte de cabello',
      'Peinado',
      'Manicura',
      'Masaje',
    ];

    String servicioSeleccionado = data['servicio'] ?? servicios.first;

    // Horario inicial
    final List<String> horarios = [
      "9:00 a.m",
      "10:00 a.m",
      "11:00 a.m",
      "2:00 p.m",
      "3:00 p.m",
    ];

    String horarioSeleccionado = data['horario'] ?? horarios.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Modificar cita'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selector fecha en Card
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: const Text("Fecha"),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 2),
                            ),
                          );
                          if (picked != null) {
                            setStateDialog(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ),

                    // Selector servicio en Card
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Servicio",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children:
                                  servicios.map((servicio) {
                                    final isSelected =
                                        servicioSeleccionado == servicio;
                                    return ChoiceChip(
                                      label: Text(servicio),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        setStateDialog(() {
                                          servicioSeleccionado = servicio;
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Selector horario en Card
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Horario",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children:
                                  horarios.map((hora) {
                                    final isSelected =
                                        horarioSeleccionado == hora;
                                    return ChoiceChip(
                                      label: Text(hora),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        setStateDialog(() {
                                          horarioSeleccionado = hora;
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('agregar')
                          .doc(citaId)
                          .update({
                            'fecha': Timestamp.fromDate(selectedDate),
                            'servicio': servicioSeleccionado,
                            'horario': horarioSeleccionado,
                          });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cita modificada correctamente'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key, required this.usuario});
  final String usuario;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // El usuario no ha iniciado sesión. Muestra un mensaje o redirige.
      return Center(child: Text("Debes iniciar sesión para ver tus citas."));
    }

    // Si sí está autenticado:
    final uid = user.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('agregar')
                .where('usuario', isEqualTo: usuario)
                .orderBy('fecha', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay notificaciones."));
          }

          final citas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final data = cita.data() as Map<String, dynamic>;

              final fecha = (data['fecha'] as Timestamp?)?.toDate();
              if (fecha == null) return const SizedBox.shrink();

              final ahora = DateTime.now();
              final estadoPendiente = fecha.isAfter(ahora);
              final icono =
                  estadoPendiente ? Icons.notifications : Icons.check_circle;
              final color = estadoPendiente ? Colors.blue : Colors.green;
              final textoEstado = estadoPendiente ? 'Próxima' : 'Pasada';

              final codigo = data['codigo'] ?? 'Sin código';
              final servicio = data['servicio'] ?? 'Sin servicio';
              final horario = data['horario'] ?? 'Sin horario';

              return Card(
                color: const Color.fromARGB(255, 128, 128, 128),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: Icon(icono, color: color),
                  title: Text(
                    "Código: $codigo",
                    style: TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18, color: Colors.white),
                  ),
                  subtitle: Text(
                    "Servicio: $servicio\nFecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario",
                    style: TextStyle(fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 18, color: Colors.white),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textoEstado,
                        style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}