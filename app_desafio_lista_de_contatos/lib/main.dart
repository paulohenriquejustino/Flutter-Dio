import 'package:flutter/material.dart';
import 'package:lista_de_contatos/pages/splash_screen/splash_creen_login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreenPage(),
    );
  }
}
