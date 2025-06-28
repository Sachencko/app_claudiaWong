/*

 ____   _    _   _ _____  _    _     _        _      ____  _____ 
|  _ \ / \  | \ | |_   _|/ \  | |   | |      / \    |  _ \| ____|
| |_) / _ \ |  \| | | | / _ \ | |   | |     / _ \   | | | |  _|  
|  __/ ___ \| |\  | | |/ ___ \| |___| |___ / ___ \  | |_| | |___ 
|_| /_/  _\_\_|_\_|_|_/_/ _ \_\_____|_____/_/   \_\ |____/|_____|
   / \  |  _ \|  \/  |_ _| \ | |                                 
  / _ \ | | | | |\/| || ||  \| |                                 
 / ___ \| |_| | |  | || || |\  |                                 
/_/   \_\____/|_|  |_|___|_| \_|                                 

*/

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:claudia_wong_app/src/widgets/agregar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class pantallaPrincipalAdmin extends StatefulWidget {
  final String usuario;
  const pantallaPrincipalAdmin({super.key, required this.usuario});

  @override
  _NavegadorState createState() => _NavegadorState();
}

class _NavegadorState extends State<pantallaPrincipalAdmin> {
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
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 114, 114, 114),
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
              icon: Icon(Icons.calendar_month),
              label: 'Usuarios y Citas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Buscar Cita',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.numbers),
              label: 'Buscar Codigo\n       de Cita',
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

class Screen1 extends StatefulWidget {
  final String usuario;

  const Screen1({super.key, required this.usuario});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('usuarios').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final usuarios =
                    snapshot.data!.docs.where((doc) {
                      final data = doc.data()! as Map<String, dynamic>;
                      final nombre =
                          (data['nombre'] ?? '').toString().toLowerCase();
                      return nombre.contains(searchText);
                    }).toList();

                if (usuarios.isEmpty) {
                  return const Center(
                    child: Text("No hay usuarios que coincidan."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final userDoc = usuarios[index];
                    final data = userDoc.data()! as Map<String, dynamic>;

                    final nombre = data['nombre'] ?? 'Sin nombre';
                    final apellido = data['apellido'] ?? '';
                    final telefono = data['telefono'] ?? 'Sin teléfono';
                    final email = data['email'] ?? 'Sin email';
                    final username = data['usuario'] ?? 'Sin usuario';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          '$nombre $apellido',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Teléfono: $telefono\nUsuario: $username',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => UsuarioCitasScreen(
                                    usuario: data['usuario'],
                                    usuarioId: userDoc.id,
                                    usuarioEmail: email,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UsuarioCitasScreen extends StatelessWidget {
  final String usuario;
  final String usuarioId;
  final String usuarioEmail;

  const UsuarioCitasScreen({
    super.key,
    required this.usuario,
    required this.usuarioId,
    required this.usuarioEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      appBar: AppBar(title: Text("Citas de $usuario")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
    .collection('agregar')
    .where('usuario', isEqualTo: usuario)
    .orderBy('fecha', descending: true)
    .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final citas = snapshot.data!.docs;

          if (citas.isEmpty) {
            return const Center(child: Text("Este usuario no tiene citas."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final data = cita.data()! as Map<String, dynamic>;

              final fechaTimestamp = data['fecha'] as Timestamp?;
              final fecha =
                  fechaTimestamp != null
                      ? DateFormat('dd/MM/yyyy').format(fechaTimestamp.toDate())
                      : 'Sin fecha';
              final horario = data['horario'] ?? 'Sin horario';
              final especialidad = data['servicio'] ?? 'Sin especialidad';

              final ahora = DateTime.now();
              final fechaCita = fechaTimestamp?.toDate();
              final yaPaso = fechaCita != null && fechaCita.isBefore(ahora);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                color: yaPaso ? Colors.red[100] : Colors.green[100],
                child: ListTile(
                  leading: Icon(
                    yaPaso ? Icons.history : Icons.schedule,
                    color: yaPaso ? Colors.red : Colors.green,
                  ),
                  title: Text("Horario: $horario"),
                  subtitle: Text("Fecha: $fecha\nEspecialidad: $especialidad"),
                  trailing: const Icon(Icons.event_note),
                ),
              );
            },
          );
        },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            'Solicitudes de Cancelación',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: _buildCancelaciones()),
          const Divider(),
          const Text(
            'Solicitudes de Modificación',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: _buildModificaciones()),
        ],
      ),
    );
  }

  Widget _buildCancelaciones() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('cancelaciones_pendientes')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cancelaciones = snapshot.data!.docs;

        if (cancelaciones.isEmpty) {
          return const Center(
            child: Text("No hay solicitudes de cancelación."),
          );
        }

        return ListView.builder(
          itemCount: cancelaciones.length,
          itemBuilder: (context, index) {
            final doc = cancelaciones[index];
            final data = doc.data() as Map<String, dynamic>;
            final fecha =
                data['fecha'] != null && data['fecha'] is Timestamp
                    ? DateFormat(
                      'dd/MM/yyyy',
                    ).format((data['fecha'] as Timestamp).toDate())
                    : 'Sin fecha';

            return Card(
              margin: const EdgeInsets.all(8),
              color: Colors.amber[100],
              child: ListTile(
                title: const Text("Solicitud de cancelación"),
                subtitle: Text(
                  "Usuario: ${data['usuario']}\n"
                  "Motivo: ${data['motivo']}\n"
                  "Fecha: $fecha\n"
                  "Horario: ${data['horario'] ?? 'N/A'}\n"
                  "Servicio: ${data['servicio'] ?? 'N/A'}",
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        try {
                          final citaId = data['idCita'];

                          await FirebaseFirestore.instance
                              .collection('agregar')
                              .doc(citaId)
                              .delete();

                          await FirebaseFirestore.instance
                              .collection('cancelaciones_pendientes')
                              .doc(doc.id)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Cita cancelada.")),
                          );
                        } catch (e) {
                          print('Error al cancelar cita: $e');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('cancelaciones_pendientes')
                            .doc(doc.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cancelación rechazada"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModificaciones() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('solicitudes_modificacion')
              .where('estado', isEqualTo: 'pendiente')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final modificaciones = snapshot.data!.docs;

        if (modificaciones.isEmpty) {
          return const Center(
            child: Text("No hay solicitudes de modificación."),
          );
        }

        return ListView.builder(
          itemCount: modificaciones.length,
          itemBuilder: (context, index) {
            final doc = modificaciones[index];
            final data = doc.data() as Map<String, dynamic>;

            final nuevaFecha =
                data['nuevaFecha'] != null && data['nuevaFecha'] is Timestamp
                    ? DateFormat(
                      'dd/MM/yyyy',
                    ).format((data['nuevaFecha'] as Timestamp).toDate())
                    : 'Sin fecha';

            return Card(
              margin: const EdgeInsets.all(8),
              color: Colors.lightBlue[50],
              child: ListTile(
                title: const Text("Solicitud de modificación"),
                subtitle: Text(
                  "Usuario: ${data['usuario']}\n"
                  "Nuevo servicio: ${data['nuevoServicio']}\n"
                  "Nuevo horario: ${data['nuevoHorario']}\n"
                  "Nueva fecha: $nuevaFecha",
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        try {
                          final citaId = data['citaId'];

                          await FirebaseFirestore.instance
                              .collection('agregar')
                              .doc(citaId)
                              .update({
                                'fecha': data['nuevaFecha'],
                                'horario': data['nuevoHorario'],
                                'servicio': data['nuevoServicio'],
                              });

                          await FirebaseFirestore.instance
                              .collection('solicitudes_modificacion')
                              .doc(doc.id)
                              .update({'estado': 'aceptado'});

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Modificación aplicada"),
                            ),
                          );
                        } catch (e) {
                          print('Error al modificar cita: $e');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('solicitudes_modificacion')
                            .doc(doc.id)
                            .update({'estado': 'rechazado'});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Modificación rechazada"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Screen3 extends StatefulWidget {
  const Screen3({super.key, required String usuario});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  DateTime? fechaSeleccionada;
  List<Map<String, dynamic>> citasEncontradas = [];
  String? error;

  void _mostrarSelectorFecha() async {
    final now = DateTime.now();
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      locale: const Locale('es', 'ES'),
    );

    if (seleccionada != null) {
      setState(() {
        fechaSeleccionada = seleccionada;
      });
      buscarCitasPorFecha(seleccionada);
    }
  }

  void buscarCitasPorFecha(DateTime fecha) async {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day, 0, 0, 0);
    final fin = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('agregar')
              .where(
                'fecha',
                isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
              )
              .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fin))
              .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          citasEncontradas = [];
          error = 'No se encontraron citas para esta fecha.';
        });
      } else {
        setState(() {
          citasEncontradas =
              snapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
          error = null;
        });
      }
    } catch (e) {
      setState(() {
        citasEncontradas = [];
        error = 'Ocurrió un error al buscar.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaStr =
        fechaSeleccionada != null
            ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)
            : 'Selecciona una fecha';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      appBar: AppBar(title: const Text("Buscar cita por fecha")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _mostrarSelectorFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(fechaStr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            if (citasEncontradas.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: citasEncontradas.length,
                  itemBuilder: (context, index) {
                    final cita = citasEncontradas[index];
                    final fecha = (cita['fecha'] as Timestamp).toDate();
                    final horario = cita['horario'] ?? 'N/A';
                    final servicio = cita['servicio'] ?? 'N/A';
                    final usuario = cita['usuario'] ?? 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: Colors.grey[200],
                      child: ListTile(
                        title: Text("Servicio: $servicio"),
                        subtitle: Text(
                          "Usuario: $usuario\n"
                          "Fecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\n"
                          "Horario: $horario",
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Screen4 extends StatefulWidget {
  const Screen4({super.key, required String usuario});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  final _codigoController = TextEditingController();
  Map<String, dynamic>? citaEncontrada;
  String? error;

  void buscarCita() async {
    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty) {
      setState(() {
        error = 'Debes ingresar un código de cita.';
        citaEncontrada = null;
      });
      return;
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('agregar')
              .where('codigo', isEqualTo: codigo)
              .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          error = 'No se encontró ninguna cita con ese código.';
          citaEncontrada = null;
        });
      } else {
        setState(() {
          error = null;
          citaEncontrada = snapshot.docs.first.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Ocurrió un error al buscar.';
        citaEncontrada = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      appBar: AppBar(title: const Text("Buscar cita por código")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Código de cita',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: buscarCita,
              icon: const Icon(Icons.search),
              label: const Text("Buscar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            if (citaEncontrada != null)
              Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.only(top: 12),
                child: ListTile(
                  title: Text(
                    "Servicio: ${citaEncontrada!['servicio'] ?? 'N/A'}",
                  ),
                  subtitle: Text(
                    "Fecha: ${DateFormat('dd/MM/yyyy').format((citaEncontrada!['fecha'] as Timestamp).toDate())}\n"
                    "Horario: ${citaEncontrada!['horario'] ?? 'N/A'}\n"
                    "Usuario: ${citaEncontrada!['usuario'] ?? 'N/A'}",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
