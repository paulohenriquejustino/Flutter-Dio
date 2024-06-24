// ignore_for_file: avoid_print, unused_local_variable
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:trilhaapp/repository/model/cep_model_back4app.dart';
import 'package:http/http.dart' as http;

// Criando uma classe para representar o repositório de CEP.
class CepBack4AppRepository {
  // Criando um Dio.
  final _dio = Dio();
  // Configuração inicial do repositório
  CepBack4AppRepository() {
    // Configura o cabeçalho de autenticação
    _dio.options.headers["X-Parse-Application-Id"] = "YqRLMhneDskMCz6UzXfNtxYtIPLHCBGOGf9GjCM5";
    _dio.options.headers["X-Parse-REST-API-Key"] = "F6NMPTxMyEbXOCDqLXdvO67K89J3nYePEoFBegu6";
    _dio.options.headers["Content-Type"] = "application/json";
    // Configura o URL base do Back4App.
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    // Adiciona um interceptor para logs de requisições
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }
  // Método para obter detalhes do CEP a partir de um serviço externo
  Future<CepBack4AppModel?> obterCep(String cep) async {
    // Realiza uma requisição HTTP para obter detalhes do CEP
    var response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    // Decodifica a resposta JSON
    var json = jsonDecode(response.body);
    // Cria um modelo de CEP a partir dos dados decodificados
    var cepModel = CepBack4AppModel.fromJson(json);
    // Verifica se o CEP já existe no Back4App
    var existingCep = await _consultarCepNoBack4App(cepModel.toString());
    // Se existir, retorna o CEP existente, caso contrário, retorna o CEP obtido da requisição
    if (existingCep != null) {
      return existingCep;
    } else {
      return cepModel;
    }
  }
  // Método para consultar se um CEP já existe no Back4App
  Future<CepBack4AppModel?> _consultarCepNoBack4App(String cep) async {
    try {
      // Realiza uma requisição GET para buscar o CEP no Back4App
      var response = await _dio.get("/Cep?where={\"cep\":\"$cep\"}");
      // Verifica se a resposta foi bem-sucedida e se há resultados
      if (response.statusCode == 200 && response.data["results"].length > 0) {
        // Retorna o primeiro resultado encontrado como um modelo de CEP
        return CepBack4AppModel.fromJson(response.data["results"][0]);
      } else {
        // Retorna nulo caso nenhum resultado seja encontrado
        return null;
      }
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna nulo
      print("Erro ao consultar CEP no Back4App: $e");
      return null;
    }
  }
  // Método para criar um novo registro de CEP no Back4App
  Future<String?> criar(CepBack4AppModel cepBack4AppModel) async {
    try {
      // Realiza uma requisição POST para criar o CEP no Back4App
      var response = await _dio.post("/Cep", data: cepBack4AppModel.toJson());
      // Se o status da requisição for 201 (criado), retorna o ID do CEP criado, caso contrário o status da requisição.
      if (response.statusCode == 201) {
        return response.data['objectId'];
      } else {
        // Em caso de falha na criação, imprime o código de status e retorna nulo
        print("Erro ao criar CEP no Back4App: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna nulo
      print("Erro ao criar CEP no Back4App: $e");
      return null;
    }
  }

  // Método para excluir um registro de CEP do Back4App
  Future<void> excluir(String objectId) async {
    try {
      // Realiza uma requisição DELETE para excluir o CEP do Back4App
      final response = await _dio.delete("/Cep/$objectId");
      // Se o status da requisição for 200 (sucesso), imprime mensagem de sucesso.
      if (response.statusCode == 200) {
        print('CEP excluído no Back4App');
      } else {
        // Em caso de falha na exclusão, imprime mensagem de erro
        print("Erro ao excluir CEP no Back4App");
      }
    } catch (e) {
      // Em caso de erro, imprime o erro
      print("Erro ao excluir CEP no Back4App: $e");
    }
  }
  // Método para atualizar um registro de CEP no Back4App
  Future<void> atualizar(CepBack4AppModel cepBack4AppModel) async {
    try {
      // Realiza uma requisição PUT para atualizar o CEP no Back4App
      var response = await _dio.put("/Cep/${cepBack4AppModel.objectId}", data: cepBack4AppModel.toJson());
      // Se o status da requisição for 200 (sucesso), imprime mensagem de sucesso.
      if (response.statusCode == 200) {
        print('CEP atualizado no Back4App');
      } else {
        // Em caso de falha na atualização, imprime mensagem de erro
        print("Erro ao atualizar CEP no Back4App");
      }
    } catch (e) {
      // Em caso de erro, imprime o erro
      print("Erro ao atualizar CEP no Back4App: $e");
    }
  }

  // Método para listar todos os registros de CEP no Back4App
  Future<List<CepBack4AppModel>?> listar() async {
    try {
      // Realiza uma requisição GET para obter a lista de CEPs do Back4App
      var response = await _dio.get("/Cep");
      // Se a requisição foi bem-sucedida (código 200), converte os resultados em uma lista de modelos de CEP e retorna
      if (response.statusCode == 200) {
        // Converte os resultados em uma lista de modelos de CEP e retorna
        List<dynamic> results = response.data["results"];
        List<CepBack4AppModel> cepList = results.map((json) => CepBack4AppModel.fromJson(json)).toList();
        
        return cepList;
      } else {
        // Em caso de falha na requisição, imprime o código de status e retorna nulo
        print("Erro ao buscar lista de CEPs: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna nulo
      print("Erro ao buscar lista de CEPs: $e");
      return null;
    }
  }

  // Cria um Future que busca o ID do CEP no Back4App
Future<String?> buscarIdPorCep(String cep) async {
  try {
    // Realiza uma chamada GET para obter o CEP com o valor fornecido
    var response = await _dio.get("/Cep?where={\"cep\":\"$cep\"}");
    // Se o status da requisição for 200 (sucesso) e houver resultados, retorna o objectId do primeiro resultado encontrado.
    if (response.statusCode == 200 && response.data["results"].length > 0) {
      // Retorna o objectId do primeiro resultado encontrado
      return response.data["results"][0]["objectId"];
    } else {
      // Se não houver resultados, retorne null
      return null;
    }
  } catch (e) {
    // Em caso de erro, capture a exceção e retorne null
    print("Erro ao buscar ID por CEP: $e");
    return null;
  }
}
}

 
