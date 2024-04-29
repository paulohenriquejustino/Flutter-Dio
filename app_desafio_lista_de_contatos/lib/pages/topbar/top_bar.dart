// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:lista_de_contatos/pages/repository/contato_repository.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key});
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  // Criando uma lista da class Results.
  List<Results> results = [];
  // Criando um initState para buscar a lista de contatos, ao iniciar o app.
  @override
  void initState() {
    super.initState();
    // Chamar a função que vai buscar a lista de contatos, e utilizando o then para tratar a resposta.
    listandoOsContatos().then((map) {
      setState(() {
        // Atualizando a lista de contatos que está no results em um map.
        results = map;
      });
      print(results.length);
      setState(() {});
    }).catchError((error) {
      print('Erro ao carregar lista de contatos: $error');
    });
  }
  // Criando um método listandoOsContatos para buscar a lista de contatos do Back4App.
  Future<List<Results>> listandoOsContatos() async {
    // Criando um try catch para capturar os erros.
    try {
      // O reponse vai receber uma requisição http.get que vai consumir a API.
      final response = await http.get(
        Uri.parse('https://parseapi.back4app.com/classes/ListaDeContatos'),
        // Passando os headers da API(que contém o ID e a chave da API que fornece a autenticação).
        headers: {
          'X-Parse-Application-Id': 'hy996Eg8x3VvMBEFZ8mLeXzt6wzi8ms4OpwK8VrH',
          'X-Parse-REST-API-Key': 'JWbmK2x70fGGBeEe1vpraKWBwEPThEZtmtSwjK3U',
        },
      );
      // Se o status code for 200, vai retornar os dados da API, caso o status code for diferente de 200, vai retornar uma mensagem de erro.
      if (response.statusCode == 200) {
        // Utilizando decode para decodificar o json.
        var decodedJson = jsonDecode(response.body);
        // Criando uma lista de contatos.
        List<Results> contatos = [];
        // Adicionando os dados da API na lista de contatos.
        decodedJson['results'].forEach((element) => contatos.add(Results.fromJson(element)));
        setState(() {
        });
        return contatos;
      } else {
        throw Exception('Erro ao consumir API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao consumir API: $e');
    }
  }
  // Criando um método delet para deletar o contato do Back4App.
  Future<void> deleteContato(String objectId) async {
    try {
      // O reponse vai receber uma requisição http.delete que vai consumir a API.
      final response = await http.delete(
        Uri.parse('https://parseapi.back4app.com/classes/ListaDeContatos/$objectId'),
        // Passando os headers da API(que contém o ID e a chave da API que fornece a autenticação).
        headers: {
          'X-Parse-Application-Id': 'hy996Eg8x3VvMBEFZ8mLeXzt6wzi8ms4OpwK8VrH',
          'X-Parse-REST-API-Key': 'JWbmK2x70fGGBeEe1vpraKWBwEPThEZtmtSwjK3U',
        },
      );
      // Se o status code for 200, vai retornar os dados da API, caso o status code for diferente de 200, vai retornar uma mensagem de erro.
      if (response.statusCode == 200) {
        print('Contato deletado com sucesso!');
        setState(() {});
      } else {
        throw Exception('Erro ao deletar o contato. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao deletar o contato: $e');
    }
  }
  // Declarando uma variável do tipo XFile para armazenar a imagem selecionada.
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.orange,
          height: 50,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), 
                topLeft: Radius.circular(40)
              ),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height - 200,
            child:  Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 40,
                    right: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: results.length,
                      itemBuilder: 
                      (BuildContext context, int index) {
                        return  CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: results[index].pathImg != null ? FileImage(File(results[index].pathImg!)) : null
                          ),
                        );
                      }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const  EdgeInsets.only(top: 110, right: 0, bottom: 10, left: 20),
          child: Container(
            color: Colors.white70,
            height: MediaQuery.of(context).size.height - 240,
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0,),
                      child: Container(
                        child:   CircleAvatar(
                          radius: 30,
                          backgroundImage: results[index].pathImg != null ? FileImage(File(results[index].pathImg!)) : null
                          // Inserir as fotos dos contatos.
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Adicionar aqui o nome do contato.
                          Text(
                            results[index].nome ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          // Adicionar aqui o numero do contato.
                          Text(
                            results[index].contato?? "",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[                                                                                                                                                                                                                                                                                                                                                                                                            
                          IconButton(
                            // Ao Clicar no icone, vai deletar a pessoa salva
                            onPressed: () {
                              deleteContato(results[index].objectId!);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                            ),
                          ),
                        ]
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ]
    );
  }
}
