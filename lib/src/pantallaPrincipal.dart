import 'dart:ui';
import 'package:claudia_wong_app/src/login.dart';
import 'package:claudia_wong_app/src/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class pantallaPrincipal extends StatefulWidget {
  const pantallaPrincipal({super.key});

  @override
  _NavegadorState createState() => _NavegadorState();
}

class _NavegadorState extends State<pantallaPrincipal> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Screen1(),
    const Screen2(),
    const Screen3(),
    const Screen4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          padding: const EdgeInsets.only(top: 25), // espacio para status bar
          alignment: Alignment.center,
          child: const Text(
            'Pantalla Principal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pantalla 1 (Citas)", style: TextStyle(fontSize: 30)),
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
