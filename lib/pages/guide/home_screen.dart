import 'package:FlutterNews/pages/home/home_view.dart';
import 'package:FlutterNews/support/localization/MyLocalizationsDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MyLocalizationsDelegate myLocation = const MyLocalizationsDelegate();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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