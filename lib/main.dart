import 'package:claudia_wong_app/src/presentation/screens/PantallaCarga.dart';
import 'package:claudia_wong_app/src/presentation/screens/login.dart';
import 'package:claudia_wong_app/src/presentation/screens/pantallaPrincipal.dart';
import 'package:claudia_wong_app/src/presentation/screens/pantallaPrincipalAdmin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:claudia_wong_app/src/firebase/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Claudia Wong',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', ''), Locale('en', '')],

      home: PantallaCarga()
    );
  }
}
