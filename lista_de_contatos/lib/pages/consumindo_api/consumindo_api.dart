// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lista_de_contatos/pages/repository/contato_repository.dart';

class ContatoApiPage extends StatefulWidget {
  const ContatoApiPage({super.key});
  
  @override
  State<ContatoApiPage> createState() => _ContatoApiPageState();
}

class _ContatoApiPageState extends State<ContatoApiPage> {
  List<Results> results = [];

  @override
  void initState() {
    super.initState();
    fetchContatoList().then((map) {
      setState(() {
        results = map;
      });
      print(results.length);
    }).catchError((error) {
      print('Erro ao carregar lista de contatos: $error');
    });
  }

  Future<List<Results>> fetchContatoList() async {
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
      return contatos;
    } else {
      throw Exception('Erro ao consumir API. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro ao consumir API: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blue,
                height: 80,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(results[index].nome ?? ""),
              ),
            );
          },
        )
      )
    );
  }
}
