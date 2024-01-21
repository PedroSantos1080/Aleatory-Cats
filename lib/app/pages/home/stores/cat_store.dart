import 'package:consumindo_api/app/data/http/exception.dart';
import 'package:consumindo_api/app/data/model/cat_models.dart';
import 'package:consumindo_api/app/data/repositories/cat_repository.dart';
import 'package:flutter/material.dart';

class CatStore {
  final ICatReposity repository;

  //Variável reativa para o loading
  final ValueNotifier<bool> isLoad = ValueNotifier<bool>(false);

  //Variável reativa para o state
  final ValueNotifier<List<CatModel>> state =
      ValueNotifier<List<CatModel>>([]);

  //Variável reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CatStore({required this.repository});

  Future getCats() async {
    isLoad.value = true;

    try {
      final result = await repository.getCats();
      state.value = result;
    } on NotFoundExpection catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoad.value = false;
  }
}
