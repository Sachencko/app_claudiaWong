import 'dart:ui';
import 'package:claudia_wong_app/src/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      resizeToAvoidBottomInset: false,
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
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nombreController, "Nombre", TextInputType.name),
                  const SizedBox(height: 30),
                  _buildTextField(apellidoController, "Apellido", TextInputType.name),
                  const SizedBox(height: 30),
                  _buildTextField(usuarioController, "Usuario", TextInputType.name),
                  const SizedBox(height: 30),
                  _buildTextField(correoController, "Correo", TextInputType.emailAddress),
                  const SizedBox(height: 30),
                  _buildTextField(passController, "Contraseña", TextInputType.visiblePassword),
                  const SizedBox(height: 30),
                  _buildTextField(telController, "Telefono", TextInputType.phone),
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

                        if (nombre.isEmpty ||
                            apellido.isEmpty ||
                            usuario.isEmpty ||
                            correo.isEmpty ||
                            pass.isEmpty ||
                            telefono.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Todos los campos deben estar completos", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        // Validar que nombre y apellido no tengan números
                        if (RegExp(r'[0-9]').hasMatch(nombre)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("El nombre no puede contener números", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        if (RegExp(r'[0-9]').hasMatch(apellido)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("El apellido no puede contener números", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        // Validar correo con @ y un dominio (.com, .net, etc)
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(correo)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("El correo no es correcto", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        // Validar teléfono: solo números y exactamente 9 dígitos
                        if (!RegExp(r'^[0-9]{9}$').hasMatch(telefono)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("El teléfono debe tener 9 dígitos numéricos", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        try {
                          CollectionReference collRef = FirebaseFirestore.instance.collection('usuario');

                          QuerySnapshot querySnapshot = await collRef.where('usuario', isEqualTo: usuario).get();

                          if (querySnapshot.docs.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Este usuario ya existe", style: TextStyle(fontSize: 18)),
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
                              content: Text("Usuario registrado con éxito", style: TextStyle(fontSize: 18)),
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
                              content: Text("Ocurrió un error al registrar.", style: TextStyle(fontSize: 18)),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text('Registrar datos', style: TextStyle(color: Colors.white, fontSize: 18)),
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

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return Container(
      width: 315,
      child: TextField(
        cursorColor: const Color.fromARGB(255, 248, 200, 40),
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(50),
              right: Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(50),
              right: Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          contentPadding: const EdgeInsets.only(left: 25),
          suffixIcon: const Padding(padding: EdgeInsets.only(right: 10)),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
