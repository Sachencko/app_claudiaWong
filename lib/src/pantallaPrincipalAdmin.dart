import 'dart:io';
import 'dart:ui';
import 'package:claudia_wong_app/src/login.dart';
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
    const Screen2(),
    const Screen3(),
    const Screen4(),
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
          padding: const EdgeInsets.only(top: 25), // espacio para status bar
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Text('Admin: ${usuario}', 

        style: TextStyle(
          color: Colors.green,
          fontSize: 19,
          fontWeight: FontWeight.w500,
        )),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pantalla 2 (Eliminar)", style: TextStyle(fontSize: 30)),
    );
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pantalla 3 (Modificar)", style: TextStyle(fontSize: 30)),
    );
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

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
