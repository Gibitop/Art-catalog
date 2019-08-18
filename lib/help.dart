import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Help extends StatelessWidget {
  final String title;
  Help({Key key, @required this.title}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Text('Art catalog is an app that helps artists keep track of their artworks. The app uses artchive.ru to cache data about your artworks, so you can access it anywhere you go'),
            ]),
          )
        ],
      ),
    );
  }
}
