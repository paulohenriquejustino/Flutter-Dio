class ContatoListApi {
  late List<Results> results;

  ContatoListApi({required this.results});

  ContatoListApi.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  String get nome {
    if (results.isNotEmpty) {
      return results.first.nome ?? "";
    } else {
      return "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Results {
  String? objectId = "";
  String? nome = "";
  String? createdAt = "";
  String? updatedAt = "";
  String? contato = "";
  String? pathImg = "";

  Results({
    required this.objectId,
    required this.nome,
    required this.createdAt,
    required this.updatedAt,
    required this.contato,
    required this.pathImg,
  });

  Results.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    contato = json['contato'];
    pathImg = json['path_img'];
  }

  get numero => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['contato'] = contato;
    data['path_img'] = pathImg;
    return data;
  }
}