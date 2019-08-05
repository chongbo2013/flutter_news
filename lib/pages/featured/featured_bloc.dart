import 'package:FlutterNews/pages/featured/featured_events.dart';
import 'package:FlutterNews/pages/featured/featured_streams.dart';
import 'package:FlutterNews/repository/notice_repository/model/dogInfo.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/repository/notice_repository/notice_repository.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:bsev/bsev.dart';

class FeaturedBloc extends BlocBase<FeaturedStreams, FeaturedEvents> {
  //数据请求
  final NoticeRepository repository;

  FeaturedBloc(this.repository);

  @override
  void initView() {
    _load();
  }

  //接收 重新加载数据
  @override
  void eventReceiver(FeaturedEvents event) {
    if (event is LoadFeatured) {
      _load();
    }
  }

  _load() {
    //进度显示
    streams.progress.set(true);
    //错误连接false
    streams.errorConnection.set(false);

    repository
        .loadDogLists()
        .then((news) => _showNews(news))
        .catchError(_showImplError);
  }

  Map<int, Notice> areadyUses = new Map();

  //显示卡片
  _showNews(List<Notice> news) {
    //选择一个 不认识，或者不熟悉的，进行显示
    bool isAdd=false;
    if (news != null) {
      for (Notice value in news) {
        if (!areadyUses.containsKey(value.id)) {
          areadyUses.putIfAbsent(value.id, () {
            value;
          });


          List<Notice> finalList=new List();
          finalList.add(value);

          streams.progress.set(false);
          streams.noticies.set(finalList);
          streams.errorConnection.set(false);
          isAdd=true;
          return;
        }
      }
    }


      streams.errorConnection.set(true);
      streams.progress.set(false);



  }

  //显示错误
  _showImplError(onError) {
    print(onError);
    if (onError is FetchDataException) {
      print("codigo: ${onError.code()}");
    }
    streams.errorConnection.set(true);
    streams.progress.set(false);
  }
}
