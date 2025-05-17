import 'dart:ui';
import 'package:claudia_wong_app/src/pantallaPrincipal.dart';
import 'package:claudia_wong_app/src/pantallaPrincipalAdmin.dart';
import 'package:claudia_wong_app/src/registro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final double topPadding = _selectedRole == 'Usuario' ? 180 : 115;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Container(
            padding: EdgeInsets.all(50),
            child: Image.asset("assets/claudiaLogin.png"),
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
                      cursorColor: Color.fromARGB(255, 248, 200, 40),
                      controller: usuarioController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        border: OutlineInputBorder(
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
                      cursorColor: Color.fromARGB(255, 248, 200, 40),
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        border: OutlineInputBorder(
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
                      cursorColor: Color.fromARGB(255, 248, 200, 40),
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
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
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        border: const OutlineInputBorder(
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
                        items: ['Usuario', 'Cuenta de administrador']
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      role,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
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
                              backgroundColor: Colors.grey,
                              content: Text(
                                'Por favor completa todos los campos',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          if (_selectedRole == 'Cuenta de administrador') {
                            // Busca solo en colección 'administradores'
                            QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
                                .collection('administrador')
                                .where('usuario', isEqualTo: usuario)
                                .where('correo', isEqualTo: correo)
                                .where('contraseña', isEqualTo: pass)
                                .get();

                            if (adminSnapshot.docs.isNotEmpty) {
                              // Si el login es válido para administrador, navega a la pantalla de usuario normal
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pantallaPrincipalAdmin(usuario: usuario),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Administrador no registrado',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Para usuarios normales, busca en colección 'usuario'
                            QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                                .collection('usuario')
                                .where('usuario', isEqualTo: usuario)
                                .where('correo', isEqualTo: correo)
                                .where('contraseña', isEqualTo: pass)
                                .get();

                            if (userSnapshot.docs.isNotEmpty) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pantallaPrincipal(usuario: usuario),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Usuario no registrado',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ERROR: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 248, 200, 40),
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
                            ),
                          );
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
