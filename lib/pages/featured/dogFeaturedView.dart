

import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:FlutterNews/widgets/erro_conection.dart';
import 'package:FlutterNews/widgets/pageTransform/intro_page_item.dart';
import 'package:FlutterNews/widgets/pageTransform/page_transformer.dart';
import 'package:flutter/material.dart';

import '../../main.dart';


class DogFeaturedView extends StatefulWidget {

  DogFeatureViewState dogFeatureViewState;
  final callBack;
  DogFeaturedView(this.callBack);

  @override
  DogFeatureViewState createState() {
    // TODO: implement createState
    dogFeatureViewState=DogFeatureViewState(callBack);

    return dogFeatureViewState;
  }

  void reload() {dogFeatureViewState.reload();}



}

class DogFeatureViewState extends State<DogFeaturedView>{
  final callBack;
  DogFeatureViewState(this.callBack);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              child: _buildFeatureds(),
            ),
            _getProgress()
          ],
        ),
        _buildErrorConnection()
      ],
    );
  }
  bool showError=false;
  bool showProgress=false;
  Widget _getProgress() {
    if (showProgress) {
      return new Container(
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    } else {
      return new Container();
    }
  }

  List<Notice> noticies=List();
  _buildFeatureds() {
    List _destaque = noticies;
    var length = _destaque.length ;

    Widget fearured =
    PageTransformer(pageViewBuilder: (context, visibilityResolver) {
      return new PageView.builder(
        controller: new PageController(viewportFraction: 0.9),
        itemCount: length,
        itemBuilder: (context, index) {
          final item = IntroNews.fromNotice(_destaque[index]);
          final pageVisibility =
          visibilityResolver.resolvePageVisibility(index);
          return new IntroNewsItem(
              item: item, pageVisibility: pageVisibility,callback: (){
                reload();
          },);
        },
      );
    });

    return AnimatedOpacity(
      opacity: length > 0 ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: fearured,
    );
  }

  Widget _buildErrorConnection() {
    if (showError) {
      return ErroConection(tryAgain: () {
         reload();
      });
    } else {
      return Container();
    }
  }
  Map<int, Notice> areadyUses = new Map();
  //重新加载
  void reload(){
    widget.callBack();
  }
  void load(){

    loadDogLists()
        .then((news) => _showNews(news))
        .catchError(_showImplError);
  }
//显示卡片
  _showNews(List<Notice> news) {
    //选择一个 不认识，或者不熟悉的，进行显示

    if (news != null) {
      for (Notice value in news) {
        if (!areadyUses.containsKey(value.id)) {
          areadyUses.putIfAbsent(value.id, () {
            value;
          });

          noticies.clear();
          noticies.add(value);
          showProgress=false;
          showError=false;
          setState(() {

          });

          return;
        }
      }
    }


    setState(() {
      showProgress=false;
      showError=true;
    });



  }

  //显示错误
  _showImplError(onError) {
    print(onError);
    if (onError is FetchDataException) {
      print("codigo: ${onError.code()}");
    }
    setState(() {
      showProgress=false;
      showError=true;
    });
  }

  Future<List<Notice>> loadDogLists() async {
    final List<Map> result =await NewsApp.dbHelp.queryLearnAll();
    List<Notice> noties=List<Notice>();
    for (Map value in result) {
      Notice notice=new Notice.fromMapDog(value);
      noties.add(notice);
    }
    return noties;
  }

}