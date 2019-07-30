import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'home_screen.dart';

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => new _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "FLUTTER",
        description:
        "Get Faster Development, Flexible UI & Access Native Features. Learn More! High-Quality Interfaces. Flexible UI. Fast Development.",
        pathImage: "assets/images/flutter.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "DART",
        description:
        "Developers at Google and elsewhere use Dart to create high-quality, mission-critical apps for iOS, Android, and the web. With features aimed at client-side development, Dart is a great fit for both mobile and web apps.",
        pathImage: "assets/images/dart.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "WELECOME",
        description:
        "开始你的app",
        pathImage: "assets/images/flutterlogo.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: "home page",
            )),
            (route) => route == null);
  }

  void onSkipPress() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: "home page",
            )),
            (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}