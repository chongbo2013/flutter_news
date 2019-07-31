import 'dart:convert';

import 'package:FlutterNews/pages/guide/intro_slider_demo.dart';
import 'package:FlutterNews/pages/home/home_view.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/di/inject_bloc.dart';
import 'package:FlutterNews/support/di/inject_repository.dart';
import 'package:FlutterNews/support/localization/MyLocalizationsDelegate.dart';
import 'package:FlutterNews/support/util/DBHelper.dart';
import 'package:FlutterNews/support/util/sharePreferenceUtil.dart';
import 'package:FlutterNews/support/util/sp_util.dart';
import 'package:bsev/bsev.dart';
import 'package:bsev/flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(new NewsApp());

class NewsApp extends StatefulWidget {
  static final dbHelp = new DBHelper();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<NewsApp> {

  MyLocalizationsDelegate myLocation = const MyLocalizationsDelegate();

  @override
  void initState() {
    super.initState();
    _initAsync();
    Flavors.configure(Flavor.PROD);
    injectRepository(Injector.appInstance);
    injectBloc(Injector.appInstance);
    SharedPreferenceUtil.getbool("isFirst")
        .then((isFrist) => initFirst(isFrist))
        .catchError(onFirstError);
  }

  void onComplete() {
    print("Task Complete");
    //初始化数据
  }

  void initFirst(bool isFrist) {
    if (isFrist == null || isFrist) {
      NewsApp.dbHelp
          .initializeUserDB()
          .then((database) => addAllInfo2Db(database))
          .then((notices) => NewsApp.dbHelp.addAllNoticeToDB(notices))
          .whenComplete(onComplete)
          .catchError(onFirstError);
      SharedPreferenceUtil.savebool("isFirst", false);
    } else {
      NewsApp.dbHelp.initializeUserDB().whenComplete(onComplete);
    }
  }

  void onFirstError(error) {
    print(error);
  }

  //
  Future<List<Notice>> addAllInfo2Db(Database database) async {
    String data = await rootBundle.loadString('assets/data/dog.json');
    final Map result = json.decode(data);
    return result['dogs']
        .map<Notice>((notice) => new Notice.fromMapDog(notice))
        .toList();
  }
  bool isFirstInit=false;
  bool showBlackPage=true;
  /// SpUtil example.
  void _initAsync() async {
    await SpUtil.getInstance();
    isFirstInit=SpUtil.getBool("FirstInit");
    showBlackPage=false;
    if (!SpUtil.getBool("FirstInit")) {
      SpUtil.putBool("FirstInit", true);
    }
    //重新刷新
    setState(() {

    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(showBlackPage)
      return  new Stack();
    if (isFirstInit) {
      return getGuide();
    }
    return getHomeWidget();
  }

  Widget getGuide() {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SliderScreen(),
    );
  }

  Widget getHomeWidget() {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News',
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          accentColor: Colors.blue,
          brightness: Brightness.light),
      supportedLocales: MyLocalizationsDelegate.supportedLocales(),
      localizationsDelegates: [
        myLocation,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: myLocation.resolution,
      home: HomeView(),
    );
  }
}
