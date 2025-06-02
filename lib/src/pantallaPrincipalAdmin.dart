import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:claudia_wong_app/src/login.dart';
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
      appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: 
          const BoxDecoration(color: 
          Color.fromARGB(255, 114, 114, 114),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 0.0),
              blurRadius: 4.0, 
            )
          ]
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
                  onPressed: (){
                    showDialog(context: context, builder:(context) => AlertDialog(
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 214, 29, 16)),
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
                          }, 
                          child: Text("Si", style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255))),
                          ),
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }, 
                          child: Text("No", style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255))),
                          ),

                      ],
                      content: Text("¿Seguro deseas cerrar sesion?", style: TextStyle(fontSize: 18),),
                      

                    )
                    );
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                    print('SESION SALIDA');

              }, 
              icon: Icon(Icons.exit_to_app)))

            ],


          )
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
      appBar: AppBar(title: const Text("Usuarios registrados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final usuarios = snapshot.data!.docs;

          if (usuarios.isEmpty) {
            return const Center(child: Text("No hay usuarios registrados."));
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

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  title: Text('$nombre $apellido', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Teléfono: $telefono\nEmail: $email'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UsuarioCitasScreen(
                          usuario: usuario,
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
    );
  }
}


class UsuarioCitasScreen extends StatelessWidget {
  final String usuario;
  final String usuarioId;
  final String usuarioEmail;

  const UsuarioCitasScreen({super.key, required this.usuario, required this.usuarioId, required this.usuarioEmail });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Citas de $usuario")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agregar')
            .where('usuario', isEqualTo: usuarioEmail)  // <-- Aquí uso usuarioEmail
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

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
              final fecha = data['fecha'] is Timestamp
                  ? DateFormat('dd/MM/yyyy').format((data['fecha'] as Timestamp).toDate())
                  : data['fecha'] ?? 'Sin fecha';
              final horario = data['horario'] ?? 'Sin horario';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  title: Text("Horario: $horario"),
                  subtitle: Text("Fecha: $fecha"),
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

class Screen2 extends StatelessWidget {
  const Screen2({super.key, required String usuario});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pantalla 2 (Eliminar)", style: TextStyle(fontSize: 30)),
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
    return Center(
      child: Text(
        "Pantalla 4 (Notificaciones)",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
