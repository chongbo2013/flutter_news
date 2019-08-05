import 'package:FlutterNews/pages/featured/dogFeaturedView.dart';
import 'package:FlutterNews/pages/home/home_bloc.dart';
import 'package:FlutterNews/pages/home/home_streams.dart';
import 'package:FlutterNews/pages/info/info.dart';
import 'package:FlutterNews/pages/news/news_view.dart';
import 'package:FlutterNews/widgets/bottom_navigation.dart';
import 'package:FlutterNews/widgets/search.dart';
import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Bsev<HomeBloc,HomeStreams>(
      builder: (context,dispatcher,streams){

        return Scaffold(
          body: Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: SearchWidget(),
                ) ,
                Expanded(
                    child: _getContent(streams)
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigation((index){
            streams.tabPosition.set(index);
          }), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }

  static DogFeaturedView featuredView=null;

  Widget _getContent(HomeStreams streams){

    return StreamBuilder(
        stream: streams.tabPosition.get,
        initialData: 0,
        builder:  (BuildContext context, AsyncSnapshot snapshot){

          var position = snapshot.hasData ? snapshot.data:0;
          if(position==0){
            if(featuredView==null)
            featuredView=DogFeaturedView((){

            });
            return featuredView;
          }else if(position==1){
            return NewsView();
          }else if(position==2){
            return Info();
          }
          return Container();


        }
    );
  }
  
}