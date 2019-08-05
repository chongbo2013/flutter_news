import 'package:FlutterNews/pages/datail/detail.dart';
import 'package:FlutterNews/pages/home/home_view.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/util/FadeInRoute.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../main.dart';
import 'page_transformer.dart';

class IntroNews {
  IntroNews(this.title, this.category, this.imageUrl, this.description,
      this.date, this.link, this.origin, this.learnMark, this.id);

  final String title;
  final String category;
  final String imageUrl;
  final String date;
  final String description;
  final String link;
  final String origin;
  final int learnMark;
  final int id;

  IntroNews.fromNotice(Notice notice)
      : title = notice.title,
        category = notice.category,
        imageUrl = notice.img,
        description = notice.description,
        date = notice.date,
        link = notice.link,
        origin = notice.origin,
        learnMark = notice.learnMark,
        id = notice.id;
}

class IntroNewsItem extends StatefulWidget {
  IntroNewsItem({
    @required this.item,
    @required this.pageVisibility,
  });

  final IntroNews item;
  final PageVisibility pageVisibility;

  @override
  IntroNewsItemState createState() =>
      IntroNewsItemState(item: item, pageVisibility: pageVisibility);
}

class IntroNewsItemState extends State<IntroNewsItem> {
  IntroNewsItemState({
    @required this.item,
    @required this.pageVisibility,
  });

  final IntroNews item;
  final PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return new Opacity(
      opacity: pageVisibility.visibleFraction,
      child: new Transform(
        alignment: FractionalOffset.topLeft,
        transform: new Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: new Text(
          item.title,
          style: textTheme.title.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return new Positioned(
      bottom: 76.0,
      left: 32.0,
      right: 32.0,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleText,
        ],
      ),
    );
  }

  //显示答案
  void showAnswer() {
    setState(() {
      showTishi = false;
      showAnster = true;
    });
  }

  _buildShowContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget renshiWidget = new Text(
      '提示',
      style: textTheme.title.copyWith(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
      textAlign: TextAlign.center,
    );

    final renshiText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FlatButton(
          onPressed: showAnswer,
          child: renshiWidget,
        ),
      ),
    );

    return new Positioned(
      bottom: 56.0,
      left: 32.0,
      right: 32.0,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [renshiText],
      ),
    );
  }


  void refreshTab(){
    HomeView.featuredView.reload();

  }
  _buildDogContainer(BuildContext context) {




    final renshiText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FlatButton(
          onPressed: () {
            NewsApp.dbHelp.updateNoticeToDB(item.id, 2).whenComplete(refreshTab);
          },
          textColor: Theme.of(context).primaryColor,
          color: Color(0xFF82B1FF),
          child: Text('认识'),
        ),
      ),
    );



    final buquedingText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FlatButton(
          onPressed: () {
            NewsApp.dbHelp.updateNoticeToDB(item.id, 0).whenComplete(refreshTab);
          },
          textColor: Theme.of(context).primaryColor,
          color: Color(0xFF82B1FF),
          child: Text('不认识'),
        ),
      ),
    );


    final burenshiText = _applyTextEffects(
      translationFactor: 200.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FlatButton(
          onPressed: () {
            NewsApp.dbHelp.updateNoticeToDB(item.id, 1).whenComplete(refreshTab);
          },
            textColor: Theme.of(context).primaryColor,
            color: Color(0xFF82B1FF),
          child: Text('不确定'),
        ),
      ),
    );

    return new Positioned(
      bottom: 26.0,
      left: 16.0,
      right: 16.0,
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: [renshiText, buquedingText, burenshiText],
      ),
    );
  }

  Widget _getImageNetwork(url) {
    try {
      if (url != '') {
        return ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            placeholder: 'assets/place_holder.jpg',
            image: url,
            fit: BoxFit.cover,
            alignment: new FractionalOffset(
              0.5 + (pageVisibility.pagePosition / 3),
              0.5,
            ),
          ),
        );
      } else {
        return new Image.asset('assets/place_holder_2.jpg');
      }
    } catch (e) {
      return new Image.asset('assets/place_holder_2.jpg');
    }
  }

  String _getImageUrl(url, height, width) {
    return item.imageUrl;
//    return 'http://104.131.18.84/notice/tim.php?src=$url&h=$height&w=$width';
  }

  bool showTishi = true, showAnster = false;

  @override
  Widget build(BuildContext context) {
    final imageOverlayGradient = new DecoratedBox(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
          ],
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: new Material(
        elevation: 4.0,
        borderRadius: new BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            openDetail(context);
          },
          child: new Stack(
            fit: StackFit.expand,
            children: [
              new Hero(
                  tag: item.title,
                  child:
                      _getImageNetwork(_getImageUrl(item.imageUrl, 400, ''))),
              _getOverlayGradient(),
              new Visibility(
                child: _buildTextContainer(context),
                visible: showAnster,
              ),
              new Visibility(
                child: _buildDogContainer(context),
                visible: showAnster,
              ),
              new Visibility(
                child: _buildShowContainer(context),
                visible: showTishi,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getOverlayGradient() {
    return ClipRRect(
      borderRadius: new BorderRadius.only(
          bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
            colors: [
              const Color(0xFF000000),
              const Color(0x00000000),
            ],
          ),
        ),
      ),
    );
  }

  //打开详情
  void openDetail(BuildContext context) {
    Navigator.of(context).push(FadeInRoute(
        widget: DetailPage(item.imageUrl, item.title, item.date,
            item.description, item.category, item.link, item.origin)));
  }
}
