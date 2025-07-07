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

import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:claudia_wong_app/src/widgets/agregar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
      CitasProgramadasScreen(usuario: widget.usuario),
      Screen1(usuario: widget.usuario),
      Screen2(usuario: widget.usuario),
      Screen3(usuario: widget.usuario),
      Screen4(usuario: widget.usuario),
      ReporteFinancieroScreen(), //5
      ReporteSemanalScreen(), //6
      ReporteMensualScreen(),
    ]);
  }

  void _onSelectItem(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.of(context).pop();
    });
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
                alignment: Alignment.centerLeft,
                child: Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                ),
              ),
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
                            content: const Text(
                              "¿Seguro deseas cerrar sesión?",
                            ),
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
                                child: const Text(
                                  "Sí",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: const Icon(Icons.exit_to_app),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 114, 114, 114),
                ),
                child: Center(child: Image.asset("assets/claudiaLogin.png")),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.white),
                title: const Text(
                  'Citas Programadas',
                  style: TextStyle(color: Colors.white),
                ),
                selected: _currentIndex == 0,
                onTap: () => _onSelectItem(0),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text(
                  'Notificaciones',
                  style: TextStyle(color: Colors.white),
                ),
                selected: _currentIndex == 2,
                onTap: () => _onSelectItem(2),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  unselectedWidgetColor: Colors.white,
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: Colors.white),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    unselectedWidgetColor: Colors.white,
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: Colors.white),
                  ),
                  child: ExpansionTile(
                    leading: const Icon(Icons.search, color: Colors.white),
                    title: const Text(
                      'Consultas',
                      style: TextStyle(color: Colors.white),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 30),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      ListTile(
                        title: const Text(
                          'Usuarios y sus citas',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: _currentIndex == 1,
                        onTap: () => _onSelectItem(1),
                      ),
                      ListTile(
                        title: const Text(
                          'Buscar cita por fecha',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: _currentIndex == 3,
                        onTap: () => _onSelectItem(3),
                      ),
                      ListTile(
                        title: const Text(
                          'Buscar cita por codigo',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: _currentIndex == 4,
                        onTap: () => _onSelectItem(4),
                      ),
                    ],
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  unselectedWidgetColor: Colors.white,
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: Colors.white),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    unselectedWidgetColor: Colors.white,
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: Colors.white),
                  ),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.monetization_on,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Reportes',
                      style: TextStyle(color: Colors.white),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 30),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      ListTile(
                        title: const Text(
                          'Reporte Financiero',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _onSelectItem(5),
                      ),
                      ListTile(
                        title: const Text(
                          'Reporte Semanal',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _onSelectItem(6),
                      ),
                      ListTile(
                        title: const Text(
                          'Reporte Mensual',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _onSelectItem(7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
    );
  }
}

class ReporteFinancieroScreen extends StatefulWidget {
  const ReporteFinancieroScreen({super.key});

  @override
  State<ReporteFinancieroScreen> createState() =>
      _ReporteFinancieroScreenState();
}

class _ReporteFinancieroScreenState extends State<ReporteFinancieroScreen> {
  int totalIngresos = 0;
  bool cargando = true;
  Map<String, int> citasPorUsuario = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('agregar').get();

    int total = 0;
    final Map<String, int> conteoUsuarios = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final monto = data['total'];
      if (monto is int) {
        total += monto;
      }

      final usuario = data['usuario'] ?? 'Desconocido';
      conteoUsuarios[usuario] = (conteoUsuarios[usuario] ?? 0) + 1;
    }

    setState(() {
      totalIngresos = total;
      citasPorUsuario = conteoUsuarios;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body:
          cargando
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 50,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Total de ingresos acumulados:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'S/$totalIngresos',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Cantidad de citas por usuario:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...citasPorUsuario.entries.map(
                    (entry) => Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.black),
                        title: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text('${entry.value} citas'),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class ReporteSemanalScreen extends StatefulWidget {
  const ReporteSemanalScreen({super.key});

  @override
  State<ReporteSemanalScreen> createState() => _ReporteSemanalScreenState();
}

class _ReporteSemanalScreenState extends State<ReporteSemanalScreen> {
  int totalCitas = 0;
  num totalSoles = 0;
  Map<String, int> citasPorUsuario = {};
  bool cargando = true;

  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    contarCitasSemana();
  }

  void contarCitasSemana() {
    final now = DateTime.now();
    final lunes = now.subtract(Duration(days: now.weekday - 1));
    final domingo = lunes.add(const Duration(days: 6));

    _subscription = FirebaseFirestore.instance
        .collection('agregar')
        .where(
          'fecha',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime(lunes.year, lunes.month, lunes.day),
          ),
        )
        .where(
          'fecha',
          isLessThanOrEqualTo: Timestamp.fromDate(
            DateTime(domingo.year, domingo.month, domingo.day, 23, 59, 59),
          ),
        )
        .snapshots()
        .listen((snapshot) {
          int total = 0;
          num soles = 0;
          Map<String, int> conteo = {};

          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final usuario = data['usuario'] ?? 'Desconocido';
            final monto = (data['total'] ?? 0).toInt();

            total++;
            soles += monto;
            conteo[usuario] = (conteo[usuario] ?? 0) + 1;
          }

          setState(() {
            totalCitas = total;
            totalSoles = soles;
            citasPorUsuario = conteo;
            cargando = false;
          });
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body:
          cargando
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ), //MARGEN 10
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 50,
                          color: Colors.lightBlue,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Reporte de citas de la semana",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$totalCitas",
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Total de citas acumuladas esta semana",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ingresos semanales: S/${totalSoles.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Citas por usuario esta semana:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...citasPorUsuario.entries.map((entry) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(entry.key),
                            trailing: Text("${entry.value} citas"),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class ReporteMensualScreen extends StatefulWidget {
  const ReporteMensualScreen({super.key});

  @override
  State<ReporteMensualScreen> createState() => _ReporteMensualScreenState();
}

class _ReporteMensualScreenState extends State<ReporteMensualScreen> {
  int totalCitas = 0;
  num totalSoles = 0;
  Map<String, int> citasPorUsuario = {};
  bool cargando = true;

  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    contarCitasMes();
  }

  void contarCitasMes() {
    final now = DateTime.now();
    final primerDia = DateTime(now.year, now.month, 1);
    final ultimoDia = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    _subscription = FirebaseFirestore.instance
        .collection('agregar')
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(primerDia))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(ultimoDia))
        .snapshots()
        .listen((snapshot) {
          int total = 0;
          num soles = 0;
          Map<String, int> conteo = {};

          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final usuario = data['usuario'] ?? 'Desconocido';
            final monto = data['total'] ?? 0;

            total++;
            soles += monto;
            conteo[usuario] = (conteo[usuario] ?? 0) + 1;
          }

          setState(() {
            totalCitas = total;
            totalSoles = soles;
            citasPorUsuario = conteo;
            cargando = false;
          });
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body:
          cargando
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 50,
                              color: Color.fromARGB(255, 211, 171, 39),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Reporte de citas del mes",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$totalCitas",
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 211, 171, 39),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Total de citas acumuladas hasta hoy",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Ingresos mensuales: S/${totalSoles.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Citas por usuario este mes:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...citasPorUsuario.entries.map((entry) {
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(entry.key),
                                trailing: Text("${entry.value} citas"),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class CitasProgramadasScreen extends StatelessWidget {
  final String usuario;

  const CitasProgramadasScreen({Key? key, required this.usuario})
    : super(key: key);

  Timestamp get startOfDay {
    final now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day, 0, 0, 0));
  }

  Timestamp get endOfDay {
    final now = DateTime.now();
    return Timestamp.fromDate(
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Stream<int> totalNotificacionesStream() {
    final streamCancelaciones = FirebaseFirestore.instance
        .collection('cancelaciones_pendientes')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    final streamModificaciones = FirebaseFirestore.instance
        .collection('solicitudes_modificacion')
        .where('estado', isEqualTo: 'pendiente')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    return Rx.combineLatest2<int, int, int>(
      streamCancelaciones,
      streamModificaciones,
      (countCancelaciones, countModificaciones) =>
          countCancelaciones + countModificaciones,
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
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('agregar')
                      .where('fecha', isGreaterThanOrEqualTo: startOfDay)
                      .where('fecha', isLessThanOrEqualTo: endOfDay)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final citasHoyCount = snapshot.data!.docs.length;

                return Text(
                  "Bienvenido Admin.\n\nHoy tiene: \n$citasHoyCount citas.",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),

            StreamBuilder<int>(
              stream: totalNotificacionesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final total = snapshot.data!;
                return Text(
                  "$total notificaciones pendientes.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),

            const SizedBox(height: 30),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('agregar')
                        .where('fecha', isGreaterThanOrEqualTo: startOfDay)
                        .where('fecha', isLessThanOrEqualTo: endOfDay)
                        .orderBy('fecha')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final citasDocs = snapshot.data!.docs;

                  if (citasDocs.isEmpty) {
                    return const Center(
                      child: Text("No hay citas programadas para hoy."),
                    );
                  }

                  return ListView.builder(
                    itemCount: citasDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          citasDocs[index].data()! as Map<String, dynamic>;
                      final fechaTimestamp = data['fecha'] as Timestamp?;
                      final fechaStr =
                          fechaTimestamp != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(fechaTimestamp.toDate())
                              : 'Sin fecha';
                      final horario = data['horario'] ?? 'Sin horario';
                      final servicio = data['servicio'] ?? 'Sin servicio';
                      final usuario = data['usuario'] ?? 'Desconocido';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        color: Colors.white,
                        child: ListTile(
                          leading: const Icon(
                            Icons.event_available,
                            color: Colors.green,
                          ),
                          title: Text("Servicio: $servicio"),
                          subtitle: Text(
                            "Usuario: $usuario\nFecha: $fechaStr\nHorario: $horario",
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
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black, width: 2),
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
        stream:
            FirebaseFirestore.instance
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

  void _mostrarSelectorFecha(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2026, 12, 31),
    );
    if (seleccionada != null) {
      setState(() {
        fechaSeleccionada = seleccionada;
      });

      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('agregar')
              .where(
                'fecha',
                isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime(
                    seleccionada.year,
                    seleccionada.month,
                    seleccionada.day,
                  ),
                ),
              )
              .where(
                'fecha',
                isLessThan: Timestamp.fromDate(
                  DateTime(
                    seleccionada.year,
                    seleccionada.month,
                    seleccionada.day + 1,
                  ),
                ),
              )
              .get();

      final citas =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

      setState(() {
        citasEncontradas = citas;
        error = citas.isEmpty ? "No hay citas en esa fecha." : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Buscar por fecha",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              label: const Text(
                "Seleccionar fecha",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 219, 175, 41),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _mostrarSelectorFecha(context),
            ),
            if (fechaSeleccionada != null) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Citas para: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child:
                  citasEncontradas.isEmpty
                      ? Center(
                        child: Text(
                          fechaSeleccionada == null
                              ? "Selecciona una fecha para ver las citas."
                              : "No se encontraron citas para esta fecha.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.builder(
                        itemCount: citasEncontradas.length,
                        itemBuilder: (context, index) {
                          final cita = citasEncontradas[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              title: Text(
                                "Usuario: ${cita['usuario'] ?? 'Desconocido'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Horario: ${cita['horario'] ?? 'N/A'}\nServicio: ${cita['servicio'] ?? 'N/A'}",
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                tooltip: "Eliminar cita",
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text(
                                            "Confirmar eliminación",
                                          ),
                                          content: const Text(
                                            "¿Deseas eliminar esta cita?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text("Cancelar"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text(
                                                "Eliminar",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (confirm == true) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('agregar')
                                          .doc(cita['id'])
                                          .delete();
                                      setState(() {
                                        citasEncontradas.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Cita eliminada."),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Error al eliminar: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
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
  const Screen4({super.key, required this.usuario});
  final String usuario;

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  final TextEditingController _codigoController = TextEditingController();
  Map<String, dynamic>? citaEncontrada;
  String? error;
  bool cargando = false;

  Future<void> buscarCita() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      setState(() {
        error = 'Por favor ingresa un código de cita.';
        citaEncontrada = null;
      });
      return;
    }

    setState(() {
      cargando = true;
      error = null;
      citaEncontrada = null;
    });

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
          citaEncontrada = snapshot.docs.first.data() as Map<String, dynamic>;
          error = null;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al buscar la cita: $e';
        citaEncontrada = null;
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 215, 186),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codigoController,
              decoration: InputDecoration(
                labelText: 'Código de cita',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.numbers),
                filled: true,
                fillColor: Colors.white,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => buscarCita(),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search, color: Colors.black),
                label: const Text(
                  'Buscar',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 175, 41),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: cargando ? null : buscarCita,
              ),
            ),

            const SizedBox(height: 20),
            if (cargando)
              const CircularProgressIndicator()
            else if (error != null)
              Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            else if (citaEncontrada != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.grey[200],
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListTile(
                  title: Text(
                    'Servicio: ${citaEncontrada!['servicio'] ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format((citaEncontrada!['fecha'] as Timestamp).toDate())}\n'
                    'Horario: ${citaEncontrada!['horario'] ?? 'N/A'}\n'
                    'Usuario: ${citaEncontrada!['usuario'] ?? 'N/A'}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
