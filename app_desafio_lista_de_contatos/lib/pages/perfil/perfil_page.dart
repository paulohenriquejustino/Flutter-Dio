// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  XFile? image;
  TextEditingController nomeController = TextEditingController();
  TextEditingController numeroController = TextEditingController();

  Future<void> sendNameAndNumberToBack4App(String nome, String numero, String? imagePath) async {
    final response = await http.post(
      Uri.parse('https://parseapi.back4app.com/classes/ListaDeContatos'),
      headers: {
        'X-Parse-Application-Id': 'hy996Eg8x3VvMBEFZ8mLeXzt6wzi8ms4OpwK8VrH',
        'X-Parse-REST-API-Key': 'JWbmK2x70fGGBeEe1vpraKWBwEPThEZtmtSwjK3U',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome': nome,
        'numero': numero,
        'path_img': imagePath,
      }),
    );
    if (response.statusCode == 201) {
      print('Contato criado com sucesso!');
      setState(() {    
      });
    } else {
      print('Erro ao criar contato. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 0,
          title: const Text("Perfil",
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 100,
                  // COloca no background a foto tirada pelo usuario.
                  backgroundImage:  image != null ? FileImage(File(image!.path)) : null,
                  child: TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        image = pickedImage;
                      });
                    },
                    child: const Text(
                      'Selecione uma imagem',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.name,
                    keyboardAppearance: Brightness.dark,
                    maxLength: 40,
                    controller: nomeController,
                    decoration: InputDecoration(
                      hintText: 'Digite primeiro nome:',
                      labelText: 'Nome',
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    // Definindo a quantidade de números que o usuario pode digitar.
                    maxLength: 11,
                    // Forçando o teclado número ir até 11 digitos.
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.number,
                    keyboardAppearance: Brightness.dark,
                    controller: numeroController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu número:',
                      labelText: 'Número',
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (nomeController.text.isNotEmpty && numeroController.text.isNotEmpty) {
                      sendNameAndNumberToBack4App(nomeController.text, numeroController.text, image?.path);
                      setState(() {});
                      Navigator.pop(context);
                    } else {
                      print('Por favor, preencha todos os campos.');
                    }
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.save,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'SALVAR O CONTATO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.orange, width: 2.5),
                    ),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
