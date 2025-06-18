import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // importa tu pantalla de login aquí

class PantallaCarga extends StatefulWidget {
  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {

  @override
  void initState() {
    super.initState();

    // Espera 3 segundos y luego navega a login
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/claudiaLogin2.png',
              width: 300,
              height: 200,
              fit: BoxFit.contain,
            ),



            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 201, 182, 76)), // dorado
              strokeWidth: 3,
            ),

            SizedBox(height: 20),

            Text(
              'Espere un momento...',
              style: TextStyle(
                color: const Color.fromARGB(255, 199, 166, 68), // dorado
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
