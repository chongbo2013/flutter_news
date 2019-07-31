
import 'dart:convert';

import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'model/dogInfo.dart';

abstract class NoticeRepository{
  Future<List<Notice>> loadNews(int page);
  Future<List<Notice>> loadNewsRecent();
  Future<List<Notice>> loadDogLists();
  Future<List<Notice>> loadSearch(String query);
}
class NoticeRepositoryImpl implements NoticeRepository{

  final Api _api;

  NoticeRepositoryImpl(this._api);

  Future<List<Notice>> loadNews( int page) async {
    final List<Map> result =await NewsApp.dbHelp.queryAll(page,10);
    List<Notice> noties=List<Notice>();
    for (Map value in result) {
      Notice notice=new Notice.fromMapDog(value);
      noties.add(notice);
    }
    return noties;
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
    final List<Map> result =await NewsApp.dbHelp.querySearch(query);
    if(result!=null&&result.isEmpty){
      return List();
    }
    List<Notice> noties=List<Notice>();
    for (Map value in result) {
      Notice notice=new Notice.fromMapDog(value);
      noties.add(notice);
    }
    return noties;

  }

}

