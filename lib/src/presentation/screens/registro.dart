/*

 ____  _____ ____ ___ ____ _____ ____   ___  
|  _ \| ____/ ___|_ _/ ___|_   _|  _ \ / _ \ 
| |_) |  _|| |  _ | |\___ \ | | | |_) | | | |
|  _ <| |__| |_| || | ___) || | |  _ <| |_| |
|_|_\_\_____\____|___|____/_|_|_|_|_\_\\___/ 
/ ___| / ___|  _ \| ____| ____| \ | |        
\___ \| |   | |_) |  _| |  _| |  \| |        
 ___) | |___|  _ <| |___| |___| |\  |        
|____/ \____|_| \_\_____|_____|_| \_|        

*/

import 'dart:ui';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registro extends StatefulWidget {
  Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  final telController = TextEditingController();
  final FocusNode nombreFocus = FocusNode();
  bool _mostrarContrasena = false;

  void reiniciar() {
    if (nombreController.text.isEmpty &&
        apellidoController.text.isEmpty &&
        usuarioController.text.isEmpty &&
        correoController.text.isEmpty &&
        passController.text.isEmpty &&
        telController.text.isEmpty) {
      _showSnackBar("Los campos ya están vacíos", color: Colors.grey);
      return;
    }

    nombreController.clear();
    apellidoController.clear();
    usuarioController.clear();
    correoController.clear();
    passController.clear();
    telController.clear();

    FocusScope.of(context).requestFocus(nombreFocus);

    _showSnackBar("Campos limpiados", color: Color.fromARGB(255, 26, 219, 19));
  }

  void _showSnackBar(String mensaje, {Color color = Colors.grey}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(fontSize: 18)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    usuarioController.dispose();
    correoController.dispose();
    passController.dispose();
    telController.dispose();
    nombreFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/loginBackground.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 192, 5, 5),
                size: 30,
              ),
              onPressed: reiniciar,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    nombreController,
                    "Nombre",
                    TextInputType.name,
                    nombreFocus,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    apellidoController,
                    "Apellido",
                    TextInputType.name,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    usuarioController,
                    "Usuario",
                    TextInputType.name,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    correoController,
                    "Correo",
                    TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    passController,
                    "Contraseña",
                    TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    telController,
                    "Telefono",
                    TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 315,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String nombre = nombreController.text.trim();
                        String apellido = apellidoController.text.trim();
                        String usuario = usuarioController.text.trim();
                        String correo = correoController.text.trim();
                        String pass = passController.text.trim();
                        String telefono = telController.text.trim();

                        final validName = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$');
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                        if ([
                          nombre,
                          apellido,
                          usuario,
                          correo,
                          pass,
                          telefono,
                        ].any((e) => e.isEmpty)) {
                          _showSnackBar(
                            "Todos los campos deben estar completos",
                          );
                          return;
                        }

                        if (!validName.hasMatch(nombre)) {
                          _showSnackBar(
                            "El nombre solo puede contener letras y espacios",
                          );
                          return;
                        }

                        if (!validName.hasMatch(apellido)) {
                          _showSnackBar(
                            "El apellido solo puede contener letras y espacios",
                          );
                          return;
                        }

                        if (!emailRegex.hasMatch(correo)) {
                          _showSnackBar("El correo no es válido");
                          return;
                        }

                        if (!RegExp(r'^\d{9}$').hasMatch(telefono)) {
                          _showSnackBar(
                            "El teléfono debe tener exactamente 9 dígitos numéricos",
                          );
                          return;
                        }

                        try {
                          CollectionReference usuariosRef = FirebaseFirestore
                              .instance
                              .collection('usuarios');

                          // Verifica si usuario ya existe
                          bool usuarioExiste =
                              (await usuariosRef
                                      .where('usuario', isEqualTo: usuario)
                                      .get())
                                  .docs
                                  .isNotEmpty;
                          if (usuarioExiste) {
                            _showSnackBar(
                              "Este nombre de usuario ya está en uso",
                            );
                            return;
                          }

                          // Verifica si correo ya existe en Firestore
                          bool correoExiste =
                              (await usuariosRef
                                      .where('correo', isEqualTo: correo)
                                      .get())
                                  .docs
                                  .isNotEmpty;
                          if (correoExiste) {
                            _showSnackBar(
                              "Este correo ya está registrado en la base de datos",
                            );
                            return;
                          }

                          // Crear cuenta en Firebase Auth
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                email: correo,
                                password: pass,
                              );

                          // Guardar datos adicionales
                          await usuariosRef.doc(userCredential.user!.uid).set({
                            'nombre': nombre,
                            'apellido': apellido,
                            'usuario': usuario,
                            'correo': correo,
                            'telefono': telefono,
                            'rol': 'usuario',
                            'creadoEn': Timestamp.now(),
                          });

                          _showSnackBar(
                            "Usuario registrado con éxito",
                            color: Colors.green,
                          );

                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          String errorMensaje;
                          switch (e.code) {
                            case 'email-already-in-use':
                              errorMensaje = 'Este correo ya está registrado.';
                              break;
                            case 'invalid-email':
                              errorMensaje = 'El correo no es válido.';
                              break;
                            case 'operation-not-allowed':
                              errorMensaje = 'El registro no está habilitado.';
                              break;
                            case 'weak-password':
                              errorMensaje =
                                  'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
                              break;
                            default:
                              errorMensaje =
                                  'Error al registrar usuario. Inténtalo de nuevo.';
                          }
                          _showSnackBar(errorMensaje, color: Colors.red);
                        } catch (e) {
                          _showSnackBar(
                            "Ocurrió un error inesperado.",
                            color: Colors.red,
                          );
                        }
                      },
                      child: const Text(
                        'Registrar datos',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 88, 72, 175),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType inputType, [
    FocusNode? focusNode,
  ]) {
    bool esContrasena = label == "Contraseña";

    return Container(
      width: 315,
      child: TextField(
        cursorColor: const Color.fromARGB(255, 248, 200, 40),
        controller: controller,
        keyboardType: inputType,
        focusNode: focusNode,
        obscureText: esContrasena ? !_mostrarContrasena : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(50),
              right: Radius.circular(50),
            ),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(50),
              right: Radius.circular(50),
            ),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
          contentPadding: const EdgeInsets.only(left: 25),
          suffixIcon:
              esContrasena
                  ? IconButton(
                    icon: Icon(
                      _mostrarContrasena
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarContrasena = !_mostrarContrasena;
                      });
                    },
                  )
                  : null,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
