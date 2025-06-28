/*
 ____   _    _   _ _____  _    _     _        _    
|  _ \ / \  | \ | |_   _|/ \  | |   | |      / \   
| |_) / _ \ |  \| | | | / _ \ | |   | |     / _ \  
|  __/ ___ \| |\  | | |/ ___ \| |___| |___ / ___ \ 
|_|_/_/___\_\_|_\_| |_/_/___\_\_____|_____/_/_  \_\
|  _ \|  _ \|_ _| \ | |/ ___|_ _|  _ \ / \  | |    
| |_) | |_) || ||  \| | |    | || |_) / _ \ | |    
|  __/|  _ < | || |\  | |___ | ||  __/ ___ \| |___ 
|_|   |_| \_\___|_| \_|\____|___|_| /_/   \_\_____|

*/

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:claudia_wong_app/src/widgets/agregar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Screen5(usuario: widget.usuario),
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
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
              label: 'Encuentranos',
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
                      color:  Color.fromARGB(150, 0, 0, 0),
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
                //as
                color: Color.fromARGB(255, 0, 0, 0),
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
              stream:
                  FirebaseFirestore.instance
                      .collection('agregar')
                      .where('usuario', isEqualTo: usuario)
                      //.where('estado', isEqualTo: 'activa')
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

                   return Container(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color :Colors.black.withOpacity(0.4),
        blurRadius: 5,
        spreadRadius: 0,
        offset: Offset(4, 4),//DIRECCION SOMBRA x y
      ),
    ],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bakgroundBelleza.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icono, color: color),
        title: Text(
          "Servicio: $servicio",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          fecha != null
              ? "Fecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario"
              : "Horario: $horario",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        trailing: Text(
          textoEstado,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 15,
          ),
        ),
        isThreeLine: true,
      ),
    ),
  ),
);


                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Agregar(usuario: usuario)),
          );
        },
        backgroundColor: const Color.fromARGB(255, 219, 172, 31),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          "Añadir Cita",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
    final query =
        await FirebaseFirestore.instance
            .collection("agregar")
            .where('usuario', isEqualTo: widget.usuario)
            .orderBy('fecha', descending: true)
            .get();

    setState(() {
      citas = query.docs;
    });
  }

  void cancelarCitaConfirmada() async {
    String motivo = "";

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("¿Seguro deseas cancelar la cita?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Motivo:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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

                  final citaData =
                      citaSeleccionada!.data() as Map<String, dynamic>;

                  await FirebaseFirestore.instance
                      .collection("cancelaciones_pendientes")
                      .add({
                        "idCita": citaSeleccionada!.id,
                        "usuario": citaSeleccionada!['usuario'],
                        "servicio": citaSeleccionada!['servicio'],
                        "fecha": citaSeleccionada!['fecha'],
                        "horario": citaSeleccionada!['horario'],
                        "motivo": motivo,
                        "estado": "pendiente",
                        "solicitadoEl": Timestamp.now(),
                      });

                  await FirebaseFirestore.instance
                      .collection("agregar")
                      .doc(citaSeleccionada!.id);

                  setState(() {
                    citas.remove(citaSeleccionada);
                    citaSeleccionada = null;
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Se envió notificación al administrador"),
                    ),
                  );

                  setState(() {
                    citaSeleccionada = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 172, 31),
                ),
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

    return Container(
  margin: const EdgeInsets.symmetric(vertical: 8),
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 5,
        spreadRadius: 0,
        offset: const Offset(5, 4),
        
      ),
    ],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/backgroundChico.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Checkbox(
          focusColor: Colors.black,
          fillColor: WidgetStatePropertyAll(Colors.black),
          checkColor: const Color.fromARGB(255, 219, 172, 31),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Fecha : ${fecha != null ? DateFormat('dd/MM/yyyy').format(fecha) : 'No disponible'}\n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Hora programada: $horario\n",
                style: const TextStyle(
                 fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Servicio : $servicio\n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
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
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
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
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
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
                    itemBuilder: (context, index) => buildCitaItem(docs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: citaSeleccionada == null ? null : cancelarCitaConfirmada,
        backgroundColor: const Color.fromARGB(255, 224, 20, 20),
        icon: const Icon(Icons.cancel, color: Colors.black),
        label: const Text(
          "Cancelar Cita",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final citas = snapshot.data!.docs;

          if (citas.isEmpty) {
            return const Center(child: Text("No tienes citas."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final data = cita.data() as Map<String, dynamic>;

              String fechaStr = 'Sin fecha';
              if (data['fecha'] != null && data['fecha'] is Timestamp) {
                final Timestamp ts = data['fecha'];
                fechaStr = DateFormat('dd/MM/yyyy').format(ts.toDate());
              }

              String servicioActual = 'No seleccionado';
              if (data['servicio'] is String) {
                servicioActual = data['servicio'];
              } else if (data['servicio'] is List) {
                List<dynamic> serviciosLista = data['servicio'];
                servicioActual = serviciosLista.join('\n- ');
              }

              String horarioActual = data['horario'] ?? 'No seleccionado';

              return Card(
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  elevation: 6,
  child: Container(
    decoration: BoxDecoration(
      image: const DecorationImage(
        image: AssetImage('assets/spa.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black54,
          BlendMode.darken,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Fecha : $fechaStr\n",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "Horario : $horarioActual\n",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "Servicios:\n- $servicioActual\n",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18,
              ),
            ),
          ],
        ),
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.edit, color: Colors.amber),
      onTap: () => _mostrarDialogoModificacion(context, cita.id, data),
    ),
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
  // Define serviciosPorCategoria dentro de la función o como variable global para evitar error "undefined"
  final Map<String, List<Map<String, dynamic>>> serviciosPorCategoria = {
    "TRATAMIENTOS FACIALES": [
      {"nombre": "Limpieza facial profunda"},
      {"nombre": "Limpieza facial basica"},
    ],
    "ESTÉTICA FACIAL": [
      {"nombre": "Depilación de rostro (con cera)"},
      {"nombre": "Visagismo de cejas y depilacion con cera"},
      {"nombre": "Lifting de pestañas"},
      {"nombre": "Laminado de cejas"},
    ],
    "MANICURE": [
      {"nombre": "Esmaltado gel"},
      {"nombre": "Esmaltado semipermanente"},
      {"nombre": "Uñas poligel"},
      {"nombre": "Uñas acrílicas"},
      {"nombre": "Capping con acrilico"},
      {"nombre": "Cromados y relieves"},
      {"nombre": "Manicure francesa"},
      {"nombre": "Efecto ojo de gato"},
      {"nombre": "Efecto espejo"},
      {"nombre": "Tecnica baby boomer"},
      {"nombre": "Tecnica rubber"},
      {"nombre": "Diseño tribal"},
    ],
    "MASAJES": [
      {"nombre": "Masaje relajante y Aromaterapia"},
      {"nombre": "Masoterapia... 1hr"},
      {"nombre": "Masoterapia... 2hr"},
    ],
  };

  DateTime selectedDate = DateTime.now();
  if (data['fecha'] != null && data['fecha'] is Timestamp) {
    selectedDate = (data['fecha'] as Timestamp).toDate();
  }

  // Si tienes un array de servicios global, úsalo para el fallback
  final List<String> servicios = serviciosPorCategoria.values
      .expand((categoria) => categoria.map((s) => s['nombre'] as String))
      .toList();

  String servicioSeleccionado = data['servicio'] is String
      ? data['servicio']
      : (data['servicio'] is List && data['servicio'].isNotEmpty
          ? data['servicio'][0]
          : servicios.first);

  final List<String> horarios = ['08:00', '09:00', '10:00', '11:00']; // Ejemplo
  String horarioSeleccionado = data['horario'] ?? horarios.first;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Modificar cita',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fecha
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: const Text(
                        "Fecha",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: const TextStyle(fontSize: 16),
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

                  // Servicio
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (var categoria in serviciosPorCategoria.values)
                                for (var servicio in categoria)
                                  ChoiceChip(
                                    label: Text(servicio['nombre']),
                                    selected:
                                        servicioSeleccionado == servicio['nombre'],
                                    selectedColor: const Color(0xFFFFD700),
                                    backgroundColor: Colors.grey.shade200,
                                    labelStyle: TextStyle(
                                      color: servicioSeleccionado ==
                                              servicio['nombre']
                                          ? Colors.black
                                          : Colors.black87,
                                    ),
                                    onSelected: (_) {
                                      setStateDialog(() {
                                        servicioSeleccionado = servicio['nombre'];
                                      });
                                    },
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Horario
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: horarios.map((horario) {
                              final isSelected = horarioSeleccionado == horario;
                              return ChoiceChip(
                                label: Text(horario),
                                selected: isSelected,
                                selectedColor: const Color(0xFFFFD700),
                                backgroundColor: Colors.grey.shade200,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.black : Colors.black87,
                                ),
                                onSelected: (_) {
                                  setStateDialog(() {
                                    horarioSeleccionado = horario;
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
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                ),
                child: const Text('Enviar solicitud'),
                onPressed: () async {
                try {
                  bool cambioEnFecha =
                      data['fecha'] is Timestamp &&
                      (data['fecha'] as Timestamp).toDate() != selectedDate;
                  bool cambioEnHorario =
                      data['horario'] != horarioSeleccionado;
                  bool cambioEnServicio =
                      data['servicio'] != servicioSeleccionado;

                  if (!cambioEnFecha &&
                      !cambioEnHorario &&
                      !cambioEnServicio) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No has realizado ningún cambio.'),
                      ),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('solicitudes_modificacion')
                      .add({
                        'citaId': citaId,
                        'usuario': widget.usuario,
                        'nuevaFecha': Timestamp.fromDate(selectedDate),
                        'nuevoHorario': horarioSeleccionado,
                        'nuevoServicio': servicioSeleccionado,
                        'estado': 'pendiente',
                        'creado': Timestamp.now(),
                      });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Solicitud enviada al administrador.'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al enviar solicitud: $e'),
                    ),
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
                  estadoPendiente ? Icons.notifications : Icons.cancel;
              final color = estadoPendiente ? Colors.blue : Colors.red;
              final textoEstado = estadoPendiente ? 'Próxima' : 'Pasada';

              final codigo = data['codigo'] ?? 'Sin código';
              final servicio = data['servicio'] ?? 'Sin servicio';
              final horario = data['horario'] ?? 'Sin horario';

              return Card(
                color: const Color.fromARGB(120, 0, 0, 0),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: Icon(icono, color: color),
                  title: Text(
                    "Código: $codigo",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    "Servicio: $servicio\nFecha: ${DateFormat('dd/MM/yyyy').format(fecha)}\nHorario: $horario",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      textoEstado,
      style: TextStyle(
        color: estadoPendiente ? Colors.blue : Colors.red, // aquí la corrección
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
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



class Screen5 extends StatelessWidget {
  const Screen5({super.key, required this.usuario});
  final String usuario;

  // Función para abrir Google Maps con coordenadas
  void _abrirEnGoogleMaps(BuildContext context, LatLng target) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${target.latitude},${target.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng target = LatLng(-13.418937843522185, -76.13454396816157);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Column(
        children: [
          // Mapa
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                  options: MapOptions(
                    center: target,
                    zoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: target,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón dorado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () => _abrirEnGoogleMaps(context, target),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(211, 255, 198, 43), 
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.map, color: Color.fromARGB(255, 0, 0, 0)),
                label: const Text(
                  "Abrir en Google Maps",
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

