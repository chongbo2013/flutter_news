import 'package:FlutterNews/pages/featured/dogFeaturedView.dart';
import 'package:FlutterNews/pages/info/info.dart';
import 'package:FlutterNews/pages/news/news_view.dart';
import 'package:FlutterNews/widgets/bottom_navigation.dart';
import 'package:FlutterNews/widgets/search.dart';
import 'package:flutter/material.dart';

class DogHomeView extends StatefulWidget {
  DogHomeViewState state;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    state=new DogHomeViewState();
    return state;
  }

  
}
class DogHomeViewState extends State<DogHomeView>{

  @override
  Widget build(BuildContext context) {
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
                child: _getContent()
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation((index){
        setState(() {
          position=index;
        });

      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  int position=0;
  Widget _getContent(){
    if(position==0){
      return DogFeaturedView((){
          setState(() {

          });
      });
    }else if(position==1){
      return NewsView();
    }else if(position==2){
      return Info();
    }
    return Container();

  }

}

