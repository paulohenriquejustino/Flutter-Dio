// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
// Criando um as para importar o pacote http.
import 'package:http/http.dart' as http;
import 'package:trilhaapp/repository/back4app/cep_repository_back4app.dart';
import 'package:trilhaapp/repository/model/cep_model_back4app.dart';

class CepPageBack4App extends StatefulWidget {
  const CepPageBack4App({Key? key}) : super(key: key);

  @override
  State<CepPageBack4App> createState() => _CepPageBack4AppState();
}

class _CepPageBack4AppState extends State<CepPageBack4App> {
  // Criando um controlador para o campo de entrada de CEP
  TextEditingController cepController = TextEditingController();
  // Declarando variáveis iniciais com valor vazio.
  String cep = '';
  String logradouro = '';
  String complemento = '';
  String bairro = '';
  String localidade = '';
  String uf = '';
  String ddd = '';
  String errorMessage = '';
  List<CepBack4AppModel> cepList = [];
  String? cepObjectId;
  // Criando um initState que serve para chamar o método assíncrono para buscar a lista de CEPs.
  @override
  void initState() {
    super.initState();
    fetchCepList();
  }
  // Criando um future que aguarda o retorno do método assíncrono para buscar a lista de CEPs.
  Future<void> fetchCepList() async {
    // Criando um try catch para capturar os erros.
    try {
      // Chama o método listar() do CepBack4AppRepository para buscar os CEPs
      List<CepBack4AppModel>? fetchedCepList = await CepBack4AppRepository().listar();
      setState(() {
        // Atualiza a lista de CEPs com os resultados obtidos
        cepList = fetchedCepList ?? [];
      });
    } catch (e) {
      // Em caso de erro, exibe uma mensagem de erro no console
      print("Erro ao buscar lista de CEPs: $e");
    }
  }
  // Criando um future que aguarda o retorno do método assíncrono para buscar informações do CEP através da API ViaCEP
  Future<void> fetchCepInfo(String value) async {
    // atualiza o valor do CEP.
    setState(() {
      cep = value;
    });
    // Verifica se o CEP possui pelo menos 8 diágitos
    if (cep.length >= 8) {
      // Criando um try catch para capturar os possiveis erros.
      try {
        // Chama o método obterCep do CepBack4AppRepository para buscar as informações do CEP.
        var response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
        // se resposta for 200, decodifica a resposta JSON.
        if (response.statusCode == 200) {
          var responseJson = jsonDecode(response.body);
          // Atualiza as variáveis com as informações retornadas
          setState(() {
            logradouro = responseJson['logradouro'] ?? '';
            complemento = responseJson['complemento'] ?? 'Não informado';
            bairro = responseJson['bairro'] ?? '';
            localidade = responseJson['localidade'] ?? '';
            uf = responseJson['uf'] ?? '';
            ddd = responseJson['ddd'] ?? '';
            errorMessage = '';
            if (complemento == '') {
              complemento = 'Não informado';
            }
          });
        } 
        // caso o CEP seja inválido, exibe uma mensagem de erro.
        else {
          setState(() {
            errorMessage = 'CEP não encontrado';
            logradouro = '';
            complemento = '';
            bairro = '';
            localidade = '';
            uf = '';
            ddd = '';
          });
        }
      } 
      // caso o CEP seja inválido, exibe uma mensagem de erro.
      catch (e) {
        setState(() {
          errorMessage = 'Erro ao buscar CEP';
          logradouro = '';
          complemento = '';
          bairro = '';
          localidade = '';
          uf = '';
          ddd = '';
        });
      }
    }
  }
  // Criando um future que aguarda o retorno do método assíncrono para buscar o ID do CEP e armazenar
  Future<void> buscarIdPorCepEArmazenar(String cep) async {
    try {
      // Chama o método para buscar o ID pelo CEP
      String? id = await CepBack4AppRepository().buscarIdPorCep(cep);
      // se o id for diferente de nulo, atribui-o a uma variável
      if (id != null) {
        // Se o ID foi encontrado, atribui-o a uma variável
        setState(() {
          cepObjectId = id;
        });
        print('ID do CEP encontrado: $cepObjectId');
      } else {
        // Se o ID não foi encontrado, exiba uma mensagem de erro
        print('ID do CEP não encontrado');
      }
    } catch (e) {
      // Em caso de erro, capture a exceção e exiba uma mensagem de erro
      print("Erro ao buscar ID por CEP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Busca CEP'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          // Criando um widget SingleChildScrollView para permitir a rolagem da tela.
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  TextField(
                    controller: cepController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Pesquisar CEP',
                      labelStyle: TextStyle(fontSize: 20),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      helperStyle: TextStyle(fontSize: 18),
                      helperMaxLines: 1,
                      hintText: '00000-000',
                    ),
                    // Definindo o tipo de teclado para apenas números.
                    keyboardType: TextInputType.number,
                    keyboardAppearance: Brightness.dark,
                    strutStyle: StrutStyle.fromTextStyle(
                      const TextStyle(fontSize: 18),
                    ),
                    // Definindo um tratamento de evento para capturar o valor do CEP digitado.
                    onChanged: (value) => fetchCepInfo(value.replaceAll(RegExp(r'[^0-9]'), '')),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Criando um botão para enviar o CEP para o Back4App.
                    onPressed: () async {
                      // cepModel recebe os dados do CEP.
                      var cepModel = CepBack4AppModel(
                        cep: cep,
                        logradouro: logradouro,
                        complemento: complemento,
                        bairro: bairro,
                        localidade: localidade,
                        uf: uf,
                        ddd: ddd,
                        objectId: '',
                      );
                      // Chama a função para criar o CEP no Back4App
                      await CepBack4AppRepository().criar(cepModel);
                      // Exibe uma mensagem de sucesso.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("CEP criado no Back4App"),
                        ),
                      );
                    },
                    child: const Text(
                      'Enviar CEP para o Back4App',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  // Definindo um botão para excluir o CEP do Back4App.
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Ao clicar, chama a função para buscar o ID pelo CEP e excluir o CEP do Back4App.
                    onPressed: () async {
                      // Chama a função para buscar o ID pelo CEP
                      await buscarIdPorCepEArmazenar(cep);
                      // se cepObjectId for diferente de nulo, chama a função para excluir o CEP do Back4App
                      if (cepObjectId != null) {
                        // Chama a função para excluir o CEP do Back4App
                        await CepBack4AppRepository().excluir(cepObjectId!);
                        // Exibe uma mensagem de sucesso.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("CEP excluído do Back4App"),
                          ),
                        );
                      } else {
                        // Se for nulo, exibe uma mensagem de erro.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("ID do CEP não encontrado"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Excluir CEP do Back4App',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 17),
                      textAlign: TextAlign.start,
                    ),
                  // Criando um botao para atualizar a lista de CEPs
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Ao clicar, chama a função para buscar a lista de CEPs
                    onPressed: () async {
                      await fetchCepList();
                      // Exibe uma mensagem de sucesso.
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lista de CEPs atualizada"),
                        ),
                      );
                    },
                    child: const Text(
                      'Atualizar Lista de CEPs',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Criando a lista de CEPs
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: cepList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Colors.black, 
                            width: 2,
                            ),
                        ),
                        color: Colors.red,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          leading: const Icon(Icons.location_on),
                          textColor: Colors.black,
                          titleTextStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          tileColor: Colors.grey.shade500,
                          subtitleTextStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          title: Text('CEP: ${cepList[index].cep}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Endereço: ${cepList[index].logradouro}'),
                              Text('Bairro: ${cepList[index].bairro}'),
                              Text('Cidade: ${cepList[index].localidade}'),
                              Text('UF: ${cepList[index].uf}'),
                              Text('DDD: ${cepList[index].ddd} '),
                              Text('CEP: ${cepList[index].cep}'),
                              Text('Complemento: ${cepList[index].complemento}'),
                              Text('ObjetoID: ${cepList[index].objectId}'),
                            ],
                          ),
                          // Ao pressionar o botao, chama a função para excluir o CEP do Back4App.
                          onLongPress: () async {
                            // se o objetoID do CEP for diferente de vazio, chama a função para excluir o CEP do Back4App.
                            if (cepList[index].objectId != '') {
                              await CepBack4AppRepository().excluir(cepList[index].objectId);
                            }
                            // Exibe uma mensagem de sucesso.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('CEP excluído com sucesso!')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
