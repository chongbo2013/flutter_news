
import 'package:FlutterNews/pages/news/news_events.dart';
import 'package:FlutterNews/pages/news/news_streams.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/repository/notice_repository/notice_repository.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:FlutterNews/support/util/StringsLocation.dart';
import 'package:bsev/bsev.dart';

class NewsBloc extends BlocBase<NewsStreams,NewsEvents>{

  final NoticeRepository repository;

  int _page = 0;


  List<Notice> _newsInner = List();
  bool _carregando = false;

  NewsBloc(this.repository){

  }

  @override
  void initView() {

    _load(false);
  }

  @override
  void eventReceiver(event) {

    if(event is LoadNews){
      _load(false);
    }

    if(event is LoadMoreNews){
      _load(true);
    }

    if(event is ClickCategory){

      cleanList();
      _load(false);
    }

  }

  _load(bool isMore){

    if(!_carregando){

      _carregando = true;

      if(isMore){
        _page++;
      }else{
        _page = 0;
      }

      streams.errorConection.set(false);

      streams.progress.set(true);



      repository.loadNews( _page)
          .then((news) => _showNews(news,isMore))
          .catchError(_showImplError);

    }

  }

  _showNews(List<Notice> news, bool isMore) {

    streams.progress.set(false);

    if(isMore){
      _newsInner.addAll(news);
    }else{
      _newsInner = news;
    }

    streams.noticies.set(_newsInner);

    _carregando = false;

  }

  _showImplError(onError) {
    print(onError);
    if(onError is FetchDataException){
      print("codigo: ${onError.code()}");
    }
    streams.errorConection.set(true);
    streams.progress.set(false);
    _carregando = false;
  }

  void cleanList() {
    _newsInner = List();
    streams.noticies.set(_newsInner);
  }

}
