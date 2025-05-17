import 'dart:ui';
import 'package:claudia_wong_app/src/login.dart';
import 'package:claudia_wong_app/src/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class Registro extends StatelessWidget {
  Registro({super.key});
  int n = 0;
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  final telController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/loginBackground.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            top: 40, // puedes ajustar según lo que necesites
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
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 315,
                    child: TextField(
                      controller: nombreController, //CONTROLADOR
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Nombre",
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
                      controller: apellidoController, //CONTROLADOR
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Apellido",
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
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: usuarioController, //CONTROLADOR
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Usuario",
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
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: correoController, //CONTROLADOR
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Correo",
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
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: passController, //CONTROLADOR
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Contraseña",
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
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 315,
                    child: TextField(
                      controller: telController, //CONTROLADOR
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: "Telefono",
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
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
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

                        //CAMPOS VACIOS
                        if (nombre.isEmpty &&
                            apellido.isEmpty &&
                            usuario.isEmpty &&
                            correo.isEmpty &&
                            pass.isEmpty &&
                            telefono.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Debe llenar todos los campos."),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        if (nombre.isEmpty ||
                            apellido.isEmpty ||
                            usuario.isEmpty ||
                            correo.isEmpty ||
                            pass.isEmpty ||
                            telefono.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Todos los campos deben estar completos.",
                              ),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        //NUMEROS
                        if (!RegExp(r'^[0-9]+$').hasMatch(telefono)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "El campo teléfono solo debe contener números.",
                              ),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        //@
                        if (!correo.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ingrese un correo válido con '@'.",
                              ),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        try {
                          CollectionReference collRef = FirebaseFirestore
                              .instance
                              .collection('usuario');

                          // Verificar si ya existe un usuario con ese nombre
                          QuerySnapshot querySnapshot =
                              await collRef
                                  .where('usuario', isEqualTo: usuario)
                                  .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Este usuario ya existe."),
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                          await collRef.add({
                            'apellido': apellido,
                            'contraseña': pass,
                            'correo': correo,
                            'nombre': nombre,
                            'telefono': telefono,
                            'usuario': usuario,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Usuario registrado con éxito"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );

                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ocurrió un error al registrar."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },

                      child: const Text('Registro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 66, 66),
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
}
