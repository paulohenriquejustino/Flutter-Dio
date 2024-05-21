// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lista_de_contatos/pages/repository/contato_repository.dart';
import 'package:lista_de_contatos/pages/topbar/top_bar.dart';
import 'package:lista_de_contatos/pages/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

List<Results> results = []; // Lista para armazenar os resultados da API.

class _HomePageState extends State<HomePage> {
  // Método para atualizar a lista de contatos.
  Future<void> atualizarListaContatos() async {
    try {
      final response = await http.get(
        Uri.parse('https://parseapi.back4app.com/classes/ListaDeContatos'),
        headers: {
          'X-Parse-Application-Id': 'hy996Eg8x3VvMBEFZ8mLeXzt6wzi8ms4OpwK8VrH',
          'X-Parse-REST-API-Key': 'JWbmK2x70fGGBeEe1vpraKWBwEPThEZtmtSwjK3U',
        },
      );
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        List<Results> contatos = [];
        decodedJson['results'].forEach((element) => contatos.add(Results.fromJson(element)));
        setState(() {
          results = contatos; // Atualiza a lista de resultados.
          print(results.length); // Imprime o tamanho da lista para fins de depuração.
        });
      } else {
        throw Exception('Erro ao consumir API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao consumir API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustonDrawer(), // Drawer personalizado.
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 20,
          title: const Text(
            "Lista de Contatos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    // Ao pressionar, atualiza a lista de contatos e exibe um Snackbar.
                    atualizarListaContatos().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Lista de contatos atualizada!",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  );
                  if (mounted) {
                    setState(() {});
                  }
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.syncAlt,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: const Column(
          children: <Widget>[
            TopBar(), // Widget da barra superior.
          ],
        ),
      ),
    );
  }
}
