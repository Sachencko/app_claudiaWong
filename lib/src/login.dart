import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:claudia_wong_app/src/pantallaPrincipal.dart';
import 'package:claudia_wong_app/src/pantallaPrincipalAdmin.dart';
import 'package:claudia_wong_app/src/registro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  String _selectedRole = 'Usuario';
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> loginUser() async {
    String correo = correoController.text.trim();
    String pass = passController.text.trim();

    if (correo.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    try {
      // Autenticación con Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: correo, password: pass);
      String uid = userCredential.user!.uid;

      // Verificar rol en Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        throw 'No se encontró información del usuario en Firestore.';
      }

      String rol = userDoc['rol'];
      String usuario = userDoc['usuario'];

      if (_selectedRole == 'Cuenta de administrador' && rol != 'admin') {
        throw 'No tienes permisos de administrador.';
      }

      if (_selectedRole == 'Usuario' && rol != 'usuario') {
        throw 'No tienes permisos de usuario.';
      }

      if (rol == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => pantallaPrincipalAdmin(usuario: usuario),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => pantallaPrincipal(usuario: usuario),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = _selectedRole == 'Usuario' ? 180 : 115;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset("assets/loginBackground.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          Container(
            alignment: const Alignment(0, -1.13),
            padding: const EdgeInsets.all(70),
            child: Image.asset("assets/claudiaLogin.png"),
          ),
          Container(
            alignment: const Alignment(0, -0.45),
            padding: const EdgeInsets.all(10),
            child: Image.asset("assets/claudiaLogin2.png"),
          ),
          Align(
            alignment: const Alignment(0, 0.6),
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email
                  Container(
                    width: 315,
                    child: TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        labelText: "Correo",
                        labelStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.only(left: 25),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Contraseña
                  Container(
                    width: 315,
                    child: TextField(
                      controller: passController,
                      obscureText: _obscureText,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        labelText: "Contraseña",
                        labelStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.only(left: 25),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Rol
                  Container(
                    width: 315,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(132, 90, 90, 90),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        dropdownColor: const Color(0xFF424242),
                        items: ['Usuario', 'Cuenta de administrador']
                            .map((role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(role, style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Divider
                  Container(
                    width: 315,
                    child: const Divider(color: Colors.white70, thickness: 1),
                  ),
                  const SizedBox(height: 30),

                  // Botón Ingresar
                  SizedBox(
                    width: 315,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "Ingresar",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Botón Registrarse
                  SizedBox(
                    width: 315,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedRole == 'Usuario'
                          ? () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Registro()),
                              )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Colors.white.withOpacity(_selectedRole == 'Usuario' ? 1.0 : 0.5),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
