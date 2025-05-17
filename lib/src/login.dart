import 'dart:ui';
import 'package:claudia_wong_app/src/main.dart';
import 'package:claudia_wong_app/src/pantallaPrincipal.dart';
import 'package:claudia_wong_app/src/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  String _selectedRole = 'Usuario';
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = _selectedRole == 'Usuario' ? 180 : 220;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/loginBackground.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 315,
                    child: TextField(
                      controller: usuarioController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Escribir usuario",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        contentPadding: EdgeInsets.only(left: 25),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Escribir correo",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        contentPadding: EdgeInsets.only(left: 25),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Escribe contraseña",
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        contentPadding: const EdgeInsets.only(left: 25),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(132, 90, 90, 90),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        dropdownColor: const Color(0xFF424242),
                        items:
                            ['Usuario', 'Admin']
                                .map(
                                  (role) => DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
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
                  Container(
                    width: 315,
                    child: Divider(color: Colors.white70, thickness: 1),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 315,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String usuario = usuarioController.text.trim();
                        String correo = correoController.text.trim();
                        String pass = passController.text.trim();

                        if (usuario.isEmpty || correo.isEmpty || pass.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor complpeta todos los campos'
                              ),
                            ),
                          );
                          return;
                        }
                        try {
                          QuerySnapshot snapshot =
                              await FirebaseFirestore.instance
                                  .collection('usuario')
                                  .where('usuario', isEqualTo: usuario)
                                  .where('correo', isEqualTo: correo)
                                  .where('contraseña', isEqualTo: pass)
                                  .get();

                          if (snapshot.docs.isNotEmpty) {
                            // Usuario válido, ir a pantalla principal
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => pantallaPrincipal(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Datos incorrectos o usuario no registrado',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('ERROR')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 240, 211, 51),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Ingresar",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  if (_selectedRole == 'Usuario') ...[
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 315,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registro(),
                            ), //AL MOMENTO DE LOGEARSE
                          );
                          //ESCRIBEEEEEEEEEEEEEEEEEEEEEE
                          // Acción de registro
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Registrarse",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
