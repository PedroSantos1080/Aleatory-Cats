import 'dart:convert';
import 'package:consumindo_api/app/data/constants/constants.dart';
import 'package:consumindo_api/app/data/http/exception.dart';
import 'package:consumindo_api/app/data/http/http_client.dart';
import 'package:consumindo_api/app/data/model/cat_models.dart';

abstract class ICatReposity {
  Future<List<CatModel>> getCats();
}

class CatRepository implements ICatReposity {

  final IHttpClient client;

  CatRepository({required this.client});

  @override
  Future<List<CatModel>> getCats() async {
    final response = await client.get(url: 'https://api.thecatapi.com/v1/images/search?breed_ids=beng&api_key=${Constants.apiKey}');

    if (response.statusCode == 200) {
      final List<CatModel> Cats = [];

      final body = jsonDecode(response.body);

      body.map((item) {
        final CatModel Cat = CatModel.fromMap(item);
        Cats.add(Cat);
      }).toList();


      return Cats;

    }else if (response.statusCode == 404) {
      throw NotFoundExpection('A url informada não é válida');
    }else {
      throw Exception('Não foi possível carregar os Cats');
    }
  }

}