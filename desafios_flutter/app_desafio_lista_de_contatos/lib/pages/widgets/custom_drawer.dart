import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lista_de_contatos/pages/perfil/perfil_page.dart';
import 'package:lista_de_contatos/pages/repository/contato_repository.dart';
import 'package:lista_de_contatos/pages/splash_screen/splash_creen_login.dart';

class CustonDrawer extends StatefulWidget {
  const CustonDrawer({super.key});

  @override
  State<CustonDrawer> createState() => _CustonDrawerState();
}
class _CustonDrawerState extends State<CustonDrawer> {
  // Criando uma lista da class Results.
  List<Results> results = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (BuildContext bc) {
                    return Wrap(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: const Text("Camera"),
                          leading: const Icon(Icons.camera_alt),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: const Text("Galeria"),
                          leading: const Icon(Icons.insert_photo),
                        )
                      ],
                    );
                  },
                );
              },
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.orange),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: results.isNotEmpty
                      ? FileImage(File(results[0].pathImg!))
                      : null,
                  child: null,
                ),
                accountName: const Text("Paulo Henrique"),
                accountEmail: const Text("phjustino@gmail.com"),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.image, color: Colors.orange, size: 25),
                    SizedBox(width: 15,),
                    Text("Adicionar Foto de perfil"),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.fileAlt, color: Colors.orange, size: 25),
                    SizedBox(width: 15,),
                    Text("Termos de uso e privacidade"),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (BuildContext bc) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: const Column(
                          children: [
                            Text(
                              "Termos de uso e privacidade",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Do mesmo modo, o entendimento das metas propostas prepara-nos para enfrentar situações atípicas decorrentes do sistema de formação de quadros que corresponde às necessidades. Todas estas questões, devidamente ponderadas, levantam dúvidas sobre se a consolidação das estruturas acarreta um processo de reformulação e modernização dos conhecimentos estratégicos para atingir a excelência. Assim mesmo, a revolução dos costumes deve passar por modificações independentemente dos índices pretendidos. Não obstante, a percepção das dificuldades apresenta tendências no sentido de aprovar a manutenção do retorno esperado a longo prazo.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.cog, color: Colors.orange, size: 25),
                    SizedBox(width: 15,),
                    Text("Configurações"),
                  ],
                ),
              ),
              onTap: () {},
            ),
            const Divider(),
            const SizedBox(height: 10),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.orange, size: 25),
                    SizedBox(width: 15,),
                    Text("Sair"),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext bc) {
                    return AlertDialog(
                      alignment: Alignment.centerLeft,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text(
                        "Meu App",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Wrap(
                        children: [
                          Text("Voce sairá do aplicativo!"),
                          Text("Deseja realmente sair do aplicativo?"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Não"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreenPage(),
                              ),
                            );
                          },
                          child: const Text("Sim"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
