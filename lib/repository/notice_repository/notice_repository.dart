
import 'dart:convert';

import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:flutter/services.dart';

import 'model/dogInfo.dart';

abstract class NoticeRepository{
  Future<List<Notice>> loadNews(String category, int page);
  Future<List<Notice>> loadNewsRecent();
  Future<List<Notice>> loadDogLists();
  Future<List<Notice>> loadSearch(String query);
}
class NoticeRepositoryImpl implements NoticeRepository{

  final Api _api;

  NoticeRepositoryImpl(this._api);

  Future<List<Notice>> loadNews(String category, int page) async {
    final Map result = await _api.get("/notice/news/$category/$page");
    return result['data']['news'].map<Notice>( (notice) => new Notice.fromMap(notice)).toList();
  }

  Future<List<Notice>> loadNewsRecent() async {
    final Map result = await _api.get("/notice/news/recent");
    return result['data'].map<Notice>( (notice) => new Notice.fromMap(notice)).toList();
  }

  Future<List<Notice>> loadDogLists() async {

    String data = await rootBundle.loadString('assets/data/dog.json');
    final Map result = json.decode(data);
    return result['dogs'].map<Notice>( (notice) => new Notice.fromMapDog(notice)).toList();

  }

  Future<List<Notice>> loadSearch(String query) async {

    final Map result = await _api.get("/notice/search/$query");

    if(result['op']){
      return result['data'].map<Notice>( (notice) => new Notice.fromMap(notice)).toList();
    }else{
      return List();
    }
  }

}

