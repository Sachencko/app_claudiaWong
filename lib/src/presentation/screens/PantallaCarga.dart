/*

 ____   _    _   _ _____  _    _     _        _      ____  _____ 
|  _ \ / \  | \ | |_   _|/ \  | |   | |      / \    |  _ \| ____|
| |_) / _ \ |  \| | | | / _ \ | |   | |     / _ \   | | | |  _|  
|  __/ ___ \| |\  | | |/ ___ \| |___| |___ / ___ \  | |_| | |___ 
|_|_/_/   \_\_|_\_| |_/_/_  \_\_____|_____/_/___\_\ |____/|_____|
 / ___|  / \  |  _ \ / ___|  / \    |  _ \| ____|                
| |     / _ \ | |_) | |  _  / _ \   | | | |  _|                  
| |___ / ___ \|  _ <| |_| |/ ___ \  | |_| | |___                 
 \____/_/_ _\_\_|_\_\\____/_/   \_\ |____/|_____|                
|_ _| \ | |_ _/ ___|_ _/ _ \                                     
 | ||  \| || | |    | | | | |                                    
 | || |\  || | |___ | | |_| |                                    
|___|_| \_|___\____|___\___/                                     

*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class PantallaCarga extends StatefulWidget {
  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      //TEMPORIZADOR para que navegue al login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
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
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 201, 182, 76),
              ),
              strokeWidth: 3,
            ),

            SizedBox(height: 20),

            Text(
              'Espere un momento...',
              style: TextStyle(
                color: const Color.fromARGB(255, 199, 166, 68),
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
