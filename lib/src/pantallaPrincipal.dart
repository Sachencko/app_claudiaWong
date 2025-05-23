  import 'dart:ui';
  import 'package:intl/intl.dart';
  import 'package:claudia_wong_app/src/login.dart';
  import 'package:claudia_wong_app/src/widgets/agregar.dart';
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
                      fontWeight: FontWeight.w500,
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('agregar')
                  .where('usuario', isEqualTo: usuario)
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

                    print("Cita encontrada: $data"); // 👈 debug

                    final fecha = (data['fecha'] as Timestamp?)?.toDate();
                    final ahora = DateTime.now();
                    final estadoPendiente = fecha != null && fecha.isAfter(ahora);
                    final icono = estadoPendiente ? Icons.schedule : Icons.check_circle;
                    final color = estadoPendiente ? Colors.orange : Colors.green;
                    final textoEstado = estadoPendiente ? 'Pendiente' : 'Hecho';

                    final servicio = data['servicio'] ?? 'Sin servicio';
                    final horario = data['horario'] ?? 'Sin horario';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: Icon(icono, color: color),
                        title: Text(
                          "Servicio: $servicio",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          fecha != null
                              ? "Fecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario"
                              : "Horario: $horario",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Text(
                          textoEstado,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
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
            MaterialPageRoute(builder: (context) => Agregar(usuario: usuario)),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


  class Screen2 extends StatefulWidget {
    const Screen2({super.key, required String usuario});

    @override
    State<Screen2> createState() => _Screen2State();
  }
  class _Screen2State extends State<Screen2> {
    final TextEditingController codigoController = TextEditingController();
    DocumentSnapshot? citaEncontrada;

    void buscarCita() async {
      final codigoBuscado = int.tryParse(codigoController.text.trim());
      if (codigoBuscado == null) return;

      final query = await FirebaseFirestore.instance
          .collection("agregar")
          .where("codigo", isEqualTo: codigoBuscado)
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          citaEncontrada = query.docs.first;
        });
      } else {
        setState(() {
          citaEncontrada = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cita no encontrada")),
        );
      }
    }
    void cancelarCita(DocumentSnapshot cita) async {
      String motivo = "";

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("¿Seguro deseas cancelar la cita?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => motivo = value,
                decoration: const InputDecoration(
                  hintText: "Escribe el motivo aquí...",
                ),
                maxLines: 1,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 58, 58, 58)),
              child: const Text("No", style: TextStyle(color: Colors.white),),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("agregar")
                    .doc(cita.id)
                    .delete(); // O usa .update({"estado": "cancelado"}) si no quieres eliminar

                Navigator.pop(context);

                setState(() {
                  citaEncontrada = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cita cancelada exitosamente")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 221, 51, 39)),
              child: const Text("Sí", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    } @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Buscar cita por código", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: codigoController,
              decoration: InputDecoration(
                labelText: "Código de cita",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: buscarCita,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            if (citaEncontrada != null)
    Card(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: ListTile(
        title: Text(
          "Servicio: ${citaEncontrada!['servicio']}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "Fecha: ${DateFormat('dd/MM/yyyy').format((citaEncontrada!['fecha'] as Timestamp).toDate())}\n"
          "Horario: ${citaEncontrada!['horario']}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: ElevatedButton(
          onPressed: () => cancelarCita(citaEncontrada!),
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 221, 51, 39)),
          child: const Text("Cancelar", style: TextStyle(color: Colors.white),),
        ),
        isThreeLine: true,
      ),
    ),
          ],
        ),
      );
    }
  }

  class Screen3 extends StatelessWidget {
    const Screen3({super.key, required String usuario});

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text("Pantalla 3 (Modificar)", style: TextStyle(fontSize: 30)),
      );
    }
  }

  class Screen4 extends StatelessWidget {
    const Screen4({super.key, required String usuario});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('agregar')
              .orderBy('fecha')
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
                final data = citas[index].data() as Map<String, dynamic>;

                final fecha = (data['fecha'] as Timestamp?)?.toDate();
                if (fecha == null) return const SizedBox.shrink();

                final ahora = DateTime.now();
                final estadoPendiente = fecha.isAfter(ahora);
                final icono = estadoPendiente ? Icons.notifications : Icons.check_circle;
                final color = estadoPendiente ? Colors.blue : Colors.green;
                final textoEstado = estadoPendiente ? 'Próxima' : 'Pasada';

                final codigo = data['codigo'] ?? 'Sin código';
                final servicio = data['servicio'] ?? 'Sin servicio';
                final horario = data['horario'] ?? 'Sin horario';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Icon(icono, color: color),
                    title: Text(
                      "Código: $codigo",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Servicio: $servicio\nFecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                    ),
                    trailing: Text(
                      textoEstado,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
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